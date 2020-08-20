library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_sinc_system is
end tb_sinc_system;

architecture Behavioral of tb_sinc_system is

    component sinc_system is
    Port ( 
        clk_i  : in  std_logic;
        rst_i  : in  std_logic;        
        in1_i  : in  std_logic_vector (7 downto 0);
        in2_i  : in  std_logic_vector (7 downto 0);
        in3_i  : in  std_logic_vector (7 downto 0);
        in4_i  : in  std_logic_vector (7 downto 0);
        out1_o : out std_logic_vector (7 downto 0);
        out2_o : out std_logic_vector (7 downto 0)
        );
    end component sinc_system;
    
    signal clk_sig  : std_logic;
    signal rst_sig  : std_logic;
    signal in1_sig  : std_logic_vector (7 downto 0);
    signal in2_sig  : std_logic_vector (7 downto 0);
    signal in3_sig  : std_logic_vector (7 downto 0);
    signal in4_sig  : std_logic_vector (7 downto 0);    
    signal out1_sig : std_logic_vector (7 downto 0);        
    signal out2_sig : std_logic_vector (7 downto 0);     
       
begin

	inst_sinc_system : sinc_system
	port map
	(
		clk_i     =>  clk_sig, 
		rst_i     =>  rst_sig, 
		in1_i     =>  in1_sig, 
		in2_i     =>  in2_sig, 
		in3_i     =>  in3_sig, 	 
		in4_i     =>  in4_sig, 
		out1_o    =>  out1_sig,
		out2_o    =>  out2_sig	
	);

    -----------------------------------------------------------
    -- Clocks y Reset
    -----------------------------------------------------------
    clk_gen : process
    begin
        clk_sig <= '1';
        wait for 5 ns;
        clk_sig <= '0';
        wait for 5 ns;
    end process clk_gen;

    rst_gen : process
    begin
        rst_sig <= '1';
        wait for 250 ns;
        rst_sig <= '0';
        wait for 250 ns;
    end process rst_gen;

    -----------------------------------------------------------
    -- Proceso de estimulos a las señales
    -----------------------------------------------------------
    
    process
    begin
        
        in1_sig   <= std_logic_vector(to_unsigned(32,8));
        in2_sig   <= std_logic_vector(to_unsigned(78,8));
        in3_sig   <= std_logic_vector(to_unsigned(8,8));
        in4_sig   <= std_logic_vector(to_unsigned(13,8));
        wait for 2 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(41,8));
        in2_sig   <= std_logic_vector(to_unsigned(59,8));
        in3_sig   <= std_logic_vector(to_unsigned(23,8));
        in4_sig   <= std_logic_vector(to_unsigned(45,8));
        wait for 2 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(12,8));
        in2_sig   <= std_logic_vector(to_unsigned(22,8));
        in3_sig   <= std_logic_vector(to_unsigned(24,8));
        in4_sig   <= std_logic_vector(to_unsigned(14,8));
        wait for 2 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(47,8));
        in2_sig   <= std_logic_vector(to_unsigned(12,8));
        in3_sig   <= std_logic_vector(to_unsigned(26,8));
        in4_sig   <= std_logic_vector(to_unsigned(17,8));
        wait for 2 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(4,8));
        in2_sig   <= std_logic_vector(to_unsigned(3,8));
        in3_sig   <= std_logic_vector(to_unsigned(2,8));
        in4_sig   <= std_logic_vector(to_unsigned(1,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(23,8));
        in2_sig   <= std_logic_vector(to_unsigned(18,8));
        in3_sig   <= std_logic_vector(to_unsigned(10,8));
        in4_sig   <= std_logic_vector(to_unsigned(56,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(12,8));
        in2_sig   <= std_logic_vector(to_unsigned(22,8));
        in3_sig   <= std_logic_vector(to_unsigned(24,8));
        in4_sig   <= std_logic_vector(to_unsigned(14,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(47,8));
        in2_sig   <= std_logic_vector(to_unsigned(12,8));
        in3_sig   <= std_logic_vector(to_unsigned(26,8));
        in4_sig   <= std_logic_vector(to_unsigned(17,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(48,8));
        in2_sig   <= std_logic_vector(to_unsigned(48,8));
        in3_sig   <= std_logic_vector(to_unsigned(48,8));
        in4_sig   <= std_logic_vector(to_unsigned(48,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(55,8));
        in2_sig   <= std_logic_vector(to_unsigned(54,8));
        in3_sig   <= std_logic_vector(to_unsigned(54,8));
        in4_sig   <= std_logic_vector(to_unsigned(38,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(32,8));
        in2_sig   <= std_logic_vector(to_unsigned(78,8));
        in3_sig   <= std_logic_vector(to_unsigned(8,8));
        in4_sig   <= std_logic_vector(to_unsigned(13,8));
        wait for 125 ns;
        
        in1_sig   <= std_logic_vector(to_unsigned(41,8));
        in2_sig   <= std_logic_vector(to_unsigned(59,8));
        in3_sig   <= std_logic_vector(to_unsigned(23,8));
        in4_sig   <= std_logic_vector(to_unsigned(45,8));
        wait for 125 ns;
        
    end process;
    
end Behavioral;
