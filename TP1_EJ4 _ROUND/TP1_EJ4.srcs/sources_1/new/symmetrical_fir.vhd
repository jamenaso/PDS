library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity symmetrical_fir is
    generic (
        --Bits de la palabra de entrada
        N : integer := 16;
        --Bits de la palabra de salida
        M : integer := 23);
    Port ( 
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        s_axis_tdata_i  : in  STD_LOGIC_VECTOR (N-1 downto 0);
        s_axis_tvalid_i : in  STD_LOGIC;
        s_axis_tready_o : out STD_LOGIC;
        m_axis_tdata_o  : out STD_LOGIC_VECTOR (M-1 downto 0);
        m_axis_tvalid_o : out STD_LOGIC;
        m_axis_tready_i : in  STD_LOGIC);
end symmetrical_fir;

architecture Behavioral of symmetrical_fir is

    constant n_taps: integer := 6;

    --Vector con los datos que se van a ir almacenando
    type vector_type is array (integer range <>) of std_logic_vector(s_axis_tdata_i'RANGE);
    signal vector_reg : vector_type(0 to n_taps);
    
    component ff_module is
        generic (
            N : integer := N
        );
        Port ( clk_i      : in  STD_LOGIC;
               rst_i      : in  STD_LOGIC;
               enable_t_i : in  STD_LOGIC;
               data_i     : in  STD_LOGIC_VECTOR (N-1 downto 0);
               data_o     : out STD_LOGIC_VECTOR (N-1 downto 0));
    end component ff_module;

    component mul_module is
        generic (
            N : integer := 16;
            M : integer := 18);
        Port ( coeff_in : in STD_LOGIC_VECTOR (N - 1 downto 0);
               data_in : in STD_LOGIC_VECTOR (N - 1 downto 0);
               data_out : out STD_LOGIC_VECTOR (M - 1 downto 0));
    end component mul_module;

   --Definición de los estados de la maquina de estados del proceso del encoder.
    type state_type is 
    (
        ST_WAIT_DATA,
        ST_PROCESS_DATA,     
        ST_TRANSMIT_DATA
    );
    
    --Generamos el arreglo de registro
    type reg_axi_type is record 
        state               : state_type;
        --Señal de Ready del puerto de salida del AXI Stream Slave 
        s_axis_tready       : std_logic;
        --Señales para el manejo del puerto AXIS4-Stream
        m_axis_tdata        : std_logic_vector(m_axis_tdata_o'RANGE);
        m_axis_tvalid       : std_logic;
        enable_process      : std_logic;
    end record;
       
     --Valor por defecto de los registros.
    constant reg_ctr_default : reg_axi_type := (
        state           => ST_WAIT_DATA,
        s_axis_tready   => '0',
        m_axis_tdata    => (others => '0'),
        m_axis_tvalid   => '0',
        enable_process  => '0'
    );    
    
    --Registros internos de variables de control
    signal axi_crt : reg_axi_type := reg_ctr_default;
    
    type coeff_type is array(0 to n_taps) of real;
    constant coeff : coeff_type := (
        -0.04895593695235194,
        0.06275537458572507,
        0.29246401053451393,
        0.4226075033374576,
        0.29246401053451393,
        0.06275537458572507,
        -0.04895593695235194);
    
    --constante para los decimales de los factores en este caso es Q1.15
    constant NDEC_FACTOR : integer := 15;
    
    --Se realiza una conversión de los coeficientes de los factores de real
    --a un entero con formato Q1.15
    type coeff_type_Q15 is array(0 to n_taps) of integer;
    constant coeff_Q15 : coeff_type_Q15 := (
        integer((coeff(0))*real((2**(NDEC_FACTOR)))),
        integer((coeff(1))*real((2**(NDEC_FACTOR)))),
        integer((coeff(2))*real((2**(NDEC_FACTOR)))),
        integer((coeff(3))*real((2**(NDEC_FACTOR)))),
        integer((coeff(4))*real((2**(NDEC_FACTOR)))),
        integer((coeff(5))*real((2**(NDEC_FACTOR)))),
        integer((coeff(6))*real((2**(NDEC_FACTOR))))
        );
   
    type factor_type_Q16 is array(0 to n_taps) of std_logic_vector(18 - 1 downto 0);    
    signal factor_Q16 : factor_type_Q16;     
    
    signal result_t : signed(M-1 downto 0); 
            
--------------------------------------------------------------
--Comienzo del comportamiento del la entidad diff_ecuation
--------------------------------------------------------------
begin

    --Se genera el arreglo de 5 registros de entrada de la señal 
    vector_reg(0) <= s_axis_tdata_i;
    gen_array_ff : for i in 0 to n_taps - 1 generate
        inst_ff_module : ff_module
            generic map (
                N => N
            )
            port map (
                clk_i       => clk_i,
                rst_i       => rst_i,
                enable_t_i  => axi_crt.enable_process,
                data_i      => vector_reg(i),
                data_o      => vector_reg(i + 1)
            );              
    end generate;

    --Se genera el arreglo de los multiplicadores y se incluye el truncado a Q1.17
    gen_array_mul : for i in 0 to n_taps generate
        inst_mul_module : mul_module
            port map (
                coeff_in  => std_logic_vector(to_signed(coeff_Q15(i),N)),
                data_in   => vector_reg(i),
                data_out  => factor_Q16(i)
            );              
    end generate;
    
    --Se realiza la suma de los resultados de la multiplicacón de las muestras con determinado factor
    --El resultado es un vector de 23bits con formato Q7.16
    sum_process : process(all) is
        variable temp : signed(M - 1 downto 0);
    begin
        temp := (others => '0');
        loop_vector : for i in 0 to n_taps loop
            temp := temp + signed(factor_Q16(i));
        end loop;
        result_t <= temp;
    end process; 
    
--------------------------------------------------------------
--Manejo de los AXI4 Stream (Slave y Master) 
--------------------------------------------------------------

    fsm_process : process (clk_i, rst_i)    
    begin
        if(rst_i = '0') then
            axi_crt <= reg_ctr_default;
        elsif rising_edge(clk_i) then       
            case(axi_crt.state) is
                when ST_WAIT_DATA =>
                    axi_crt.s_axis_tready <= '1';
                    axi_crt.m_axis_tvalid <= '0';    
                    axi_crt.enable_process <= '0';                                  
                    if (s_axis_tvalid_i = '1' and s_axis_tready_o = '1') then
                        axi_crt.state <= ST_PROCESS_DATA;
                        axi_crt.s_axis_tready <= '0'; 
                        axi_crt.enable_process <= '1'; 
                    end if;    
                when ST_PROCESS_DATA =>
                    axi_crt.s_axis_tready <= '0';
                    axi_crt.m_axis_tvalid <= '1'; 
                    axi_crt.enable_process <= '0';  
                    axi_crt.m_axis_tdata <= std_logic_vector(resize(result_t,M));                              
                    axi_crt.state <= ST_TRANSMIT_DATA; 
                when ST_TRANSMIT_DATA =>
                    axi_crt.s_axis_tready <= '1';
                    axi_crt.m_axis_tvalid <= '0'; 
                    axi_crt.enable_process <= '0';                 
                    if (m_axis_tready_i = '1' and m_axis_tvalid_o = '1') then
                        axi_crt.state <= ST_WAIT_DATA;
                    end if;
                when others => null;
            end case;       
        end if;             
    end process;
    
    m_axis_tdata_o  <= axi_crt.m_axis_tdata;
    m_axis_tvalid_o <= axi_crt.m_axis_tvalid;
    s_axis_tready_o <= axi_crt.s_axis_tready;

end Behavioral;