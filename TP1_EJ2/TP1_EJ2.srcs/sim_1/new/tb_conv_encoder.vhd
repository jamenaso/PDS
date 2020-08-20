library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_conv_encoder is
end tb_conv_encoder;

architecture Behavioral of tb_conv_encoder is

    constant CLK_PERIOD : time := 10 ns;
    signal clk_i : std_logic := '1';    
    signal rst_i : std_logic := '0';

    -- Testbench DUT generics
    constant POL_1 : integer := 8#171#;
    constant POL_2 : integer := 8#133#;

    -- Testbench DUT ports
    signal s_axis_tdata_w  : std_logic_vector(15 downto 0) := (others => '0');
    signal s_axis_tvalid_w : std_logic := '0';
    signal s_axis_tready_w : std_logic;
    signal m_axis_tdata_w  : std_logic_vector(31 downto 0);
    signal m_axis_tvalid_w : std_logic;
    signal m_axis_tready_w : std_logic;
    
    component conv_encoder is
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
    end component conv_encoder;

    constant S_AXIS_VALID_PERIOD : time := 250 ns;
    constant S_AXIS_DUTY_CYCLE : real := 0.1;

    --Procedimiento para generar retardos de M ciclos de reloj.
    procedure generate_delay (
        signal      clk_i   : in std_logic;
        constant    M_CYCLE : in integer 
    ) is    
    begin
        wait_ncycle : for i in 0 to M_CYCLE-1 loop
            wait until rising_edge(clk_i);                                    
        end loop;
    end procedure generate_delay;
    
begin

    clk_i <= not clk_i after CLK_PERIOD/2;
    rst_i <= '1' after 20 ns; 
    
    generate_stimulus : process is
        variable i : integer;
        variable tdata : integer := 32769;
    begin
        --Valores de reset del bus de las señales
        m_axis_tready_w <= '1';
        s_axis_tdata_w  <= (others => '0');
        s_axis_tvalid_w <= '0';
        wait until rst_i = '1';
        generate_delay(clk_i,10);
                
        loop_generate_data : for i in 0 to 4 loop            
            
            s_axis_tvalid_w <= '1';
            s_axis_tdata_w  <= std_logic_vector(to_unsigned(tdata, s_axis_tdata_w'LENGTH));
            generate_delay(clk_i,1);
            
            s_axis_tdata_w  <= (others => '0');
            s_axis_tvalid_w <= '0';
            
            generate_delay(clk_i,40);
            tdata := tdata + 1;
        end loop;
        
    wait;
    end process; -- generate_stimulus
    

    int_conv_encoder : conv_encoder
        generic map (
            POL_1 => POL_1,
            POL_2 => POL_2
        )
        port map (
            clk_i            => clk_i,
            rst_i            => rst_i,
            s_axis_tdata_i   => s_axis_tdata_w,
            s_axis_tvalid_i  => s_axis_tvalid_w,
            s_axis_tready_o  => s_axis_tready_w,
            m_axis_tdata_o   => m_axis_tdata_w,
            m_axis_tvalid_o  => m_axis_tvalid_w,
            m_axis_tready_i  => m_axis_tready_w
        );
        
end Behavioral;
