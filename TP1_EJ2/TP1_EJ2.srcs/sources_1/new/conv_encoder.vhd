library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity conv_encoder is
    generic (
        POL_1            : integer := 8#171#;
        POL_2            : integer := 8#133#;
        N                : integer := 16;
        M                : integer := 32
        );
    Port ( 
        clk_i            : in  std_logic;
        rst_i            : in  std_logic;
        s_axis_tdata_i   : in  std_logic_vector (N-1 downto 0);
        s_axis_tvalid_i  : in  std_logic;
        s_axis_tready_o  : out std_logic;
        m_axis_tdata_o   : out std_logic_vector (M-1 downto 0);
        m_axis_tvalid_o  : out std_logic;
        m_axis_tready_i  : in  std_logic);
end conv_encoder;

architecture Behavioral of conv_encoder is

    --Tamaño del shift register.
    constant  K : integer := 7; 

    --Polinomios Generadores.
    constant POL1_SLV : std_logic_vector(K-1 downto 0) := std_logic_vector(to_unsigned(POL_1,K));
    constant POL2_SLV : std_logic_vector(K-1 downto 0) := std_logic_vector(to_unsigned(POL_2,K));
        
    --Ciclos del proceso del encoder
    constant CYCLES_PROCESS  : integer := N + 1;

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
        --Registro de corrimiento de entrada de 16 bits
        data_in_reg : std_logic_vector(N-1 downto 0);
        --Registro shift register para la comvolución 
        shift_reg : std_logic_vector(K-1 downto 0);
        --contador del proceso     
        process_count : integer range 0 to CYCLES_PROCESS;  
        --Señal de Ready del puerto de salida del AXI Stream Slave 
        s_axis_tready : std_logic;
        --Señales para el manejo del puerto AXIS4-Stream
        m_axis_tdata  : std_logic_vector(m_axis_tdata_o'RANGE);
        m_axis_tvalid       : std_logic;
    end record;
       
     --Valor por defecto de los registros.
    constant reg_ctr_default : reg_axi_type := (
        state           => ST_WAIT_DATA,
        data_in_reg     => (others => '0'),
        shift_reg       => (others => '0'),
        process_count   => 0,
        s_axis_tready   => '0',
        m_axis_tdata    => (others => '0'),
        m_axis_tvalid   => '0'
    );    
    
    --Registros internos de variables de control
    signal axi_crt : reg_axi_type := reg_ctr_default;
                
begin

    --Maquina de estado Moore, que maneja los cambios de los estados del encoder de convolución
    --Proceso que actualiza el estado actual de la maquina de estados y los registros de cada flanco de subida del la señal clk
    --Realiza la lectura de la entrada y almacena la información en el shift register
    --Actualiza el contador en el estado de proceso     
    --Realiza el manejo de la señal ready del AXI Stream slave.
    --Realiza el manejo de la señal valid del AXI Stream Master.     
    --Proceso que actualiza las señales que estan conectadas a las salidas de la maquina de estados
    fsm_process : process (clk_i, rst_i) 
        variable result : std_logic_vector(1 downto 0) := (others => '0');
        variable tdata  : std_logic_vector(m_axis_tdata_o'RANGE) := (others => '0');    
    begin
        if(rst_i = '0') then
            axi_crt <= reg_ctr_default;
            result := (others => '0');
            tdata := (others => '0');
        elsif rising_edge(clk_i) then       
            case(axi_crt.state) is
                when ST_WAIT_DATA =>
                    axi_crt.s_axis_tready <= '1';
                    axi_crt.process_count <= 0; 
                    axi_crt.m_axis_tvalid <= '0'; 
                                      
                    if (s_axis_tvalid_i = '1' and s_axis_tready_o = '1') then
                        axi_crt.state <= ST_PROCESS_DATA;
                        axi_crt.s_axis_tready <= '0';  
                        axi_crt.data_in_reg <= s_axis_tdata_i;
                        tdata := (others => '0'); 
                    end if;    
                when ST_PROCESS_DATA =>
                    axi_crt.s_axis_tready <= '0';
                    
                    if(axi_crt.process_count >= 0 and axi_crt.process_count <= 15) then                   
                        axi_crt.shift_reg <= axi_crt.data_in_reg(axi_crt.process_count) & axi_crt.shift_reg(axi_crt.shift_reg'LEFT downto 1);
                    end if;
                    
                    result(0) := xor(axi_crt.shift_reg and POL1_SLV);
                    result(1) := xor(axi_crt.shift_reg and POL2_SLV);
                    
                    tdata := result & tdata(tdata'LEFT downto 2);
                    
                    if (axi_crt.process_count >= CYCLES_PROCESS - 1) then
                        axi_crt.process_count <= 0;
                        axi_crt.m_axis_tvalid <= '1';                       
                        axi_crt.state <= ST_TRANSMIT_DATA; 
                    else
                        axi_crt.process_count <= axi_crt.process_count + 1;  
                    end if; 
                when ST_TRANSMIT_DATA =>
                    axi_crt.s_axis_tready <= '1';
                    axi_crt.m_axis_tvalid <= '0'; 
                    axi_crt.process_count <= 0; 
                                     
                    if (m_axis_tready_i = '1' and m_axis_tvalid_o = '1') then
                        axi_crt.state <= ST_WAIT_DATA;
                    end if;
                when others => null;
            end case;       
        end if;     
        
        axi_crt.m_axis_tdata <= tdata;  
         
    end process;
    
    m_axis_tdata_o  <= axi_crt.m_axis_tdata;
    m_axis_tvalid_o <= axi_crt.m_axis_tvalid;
    s_axis_tready_o <= axi_crt.s_axis_tready;
        
end Behavioral;
