library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity diff_ecuation is
    generic (
        --Bits de la palabra de entrada
        N : integer := 16;
        --Bits de la palabra de salida
        M : integer := 18);
    Port ( 
        clk_i : in STD_LOGIC;
        rst_i : in STD_LOGIC;
        s_axis_tdata_i  : in  STD_LOGIC_VECTOR (N-1 downto 0);
        s_axis_tvalid_i : in  STD_LOGIC;
        s_axis_tready_o : out STD_LOGIC;
        m_axis_tdata_o  : out STD_LOGIC_VECTOR (M-1 downto 0);
        m_axis_tvalid_o : out STD_LOGIC;
        m_axis_tready_i : in  STD_LOGIC);
end diff_ecuation;

architecture Behavioral of diff_ecuation is

    constant FACT_X : integer := 3;
    constant FACT_Y : integer := 2;

    --Vector con los datos que se van a ir almacenando
    type vector_type_x is array (integer range <>) of std_logic_vector(s_axis_tdata_i'RANGE);
    signal x_vector_reg : vector_type_x(0 to FACT_X);
    
    type vector_type_y is array (integer range <>) of std_logic_vector(16-1 downto 0);
    signal y_vector_reg : vector_type_y(0 to FACT_Y);
    
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
    
    constant SIZE_Q4_7 : integer := 4+7;
    constant SIZE_32 : integer := 32;
    
    signal result_x : signed(SIZE_Q4_7-1 downto 0);  
    signal result_y : signed(SIZE_32-1 downto 0);  
    signal result_t : signed(SIZE_Q4_7-1 downto 0); 

    --Se escribe lo factores de multimplicacion en Q2.7 
    constant MUL_FACTOR_REAL_0_5  : real := (0.5)*real((2**(7)));
    constant MUL_FACTOR_0_5       : integer := integer(MUL_FACTOR_REAL_0_5);
    
    constant MUL_FACTOR_REAL_0_25 : real := (0.25)*real((2**(7)));
    constant MUL_FACTOR_0_25      : integer := integer(MUL_FACTOR_REAL_0_25); 
    
--------------------------------------------------------------
--Comienzo del comportamiento del la entidad diff_ecuation
--------------------------------------------------------------
begin

    x_vector_reg(0) <= s_axis_tdata_i;
    gen_array_ff_x : for i in 0 to FACT_X - 1 generate
        reg_inst : ff_module
            generic map (
                N => N
            )
            port map (
                clk_i       => clk_i,
                rst_i       => rst_i,
                enable_t_i  => axi_crt.enable_process,
                data_i      => x_vector_reg(i),
                data_o      => x_vector_reg(i + 1)
            );              
    end generate;
    
    y_vector_reg(0) <= std_logic_vector(resize(result_t,16));
    gen_array_ff_y : for i in 0 to FACT_Y - 1 generate
        reg_inst : ff_module
            generic map (
                N => 16
            )
            port map (
                clk_i       => clk_i,
                rst_i       => rst_i,
                enable_t_i  => axi_crt.enable_process,
                data_i      => y_vector_reg(i),
                data_o      => y_vector_reg(i + 1)
            );              
    end generate;

    --Suma de los factores de x => x(n) - x(n-1) + x(n-2) + x(n+3)  
    result_x <= to_signed(to_integer(signed(x_vector_reg(0))) 
                        - to_integer(signed(x_vector_reg(1))) 
                        + to_integer(signed(x_vector_reg(2))) 
                        + to_integer(signed(x_vector_reg(3))),SIZE_Q4_7); 
                        
    --Suma de los factores de y => 0.5 * y(n-1) + 0.25 * y(n-2)  
    result_y <= to_signed(MUL_FACTOR_0_5  * to_integer(signed(y_vector_reg(1))), SIZE_32) 
              + to_signed(MUL_FACTOR_0_25  * to_integer(signed(y_vector_reg(2))), SIZE_32);
              
    --Suma de los factores de x & y, 
    --acomodando el formato de destino que es Q4.7 en un vector de 16 bits  
    result_t <= result_x + result_y(17 downto 7);
    
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
                    axi_crt.m_axis_tdata <= std_logic_vector(resize(result_t,16));                              
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