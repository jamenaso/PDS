library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_half_adder is
end tb_half_adder;

architecture Behavioral of tb_half_adder is

component half_adder is
    Port ( a_i : in std_logic;
           b_i : in std_logic;
           sum_o : out std_logic;
           c_out_o : out std_logic);
end component half_adder;

	signal tb_a_sig : std_logic;
	signal tb_b_sig : std_logic;
    signal tb_sum_sig : std_logic;
    signal tb_c_out_sig : std_logic;
	
begin

	inst_half_adder : half_adder
	port map
	(
		a_i 	=>	tb_a_sig, 
		b_i		=>	tb_b_sig,	
		sum_o	=>	tb_sum_sig,
		c_out_o	=>	tb_c_out_sig	  
	);
	
	--Proceso que simula todos lo posible estados de las entrada a y b
    process
    begin
        tb_a_sig <= '0';
        tb_b_sig <= '0';
        wait for 250 ns;
        tb_a_sig <= '0';
        tb_b_sig <= '1';
        wait for 250 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '0';
        wait for 250 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '1';
        wait for 250 ns;
        wait;
    end process;
	
end Behavioral;
