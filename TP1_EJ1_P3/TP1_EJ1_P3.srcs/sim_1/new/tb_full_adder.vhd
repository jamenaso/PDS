library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_full_adder is
end tb_full_adder;

architecture Behavioral of tb_full_adder is

component full_adder is
    Port ( a_i : in std_logic;
           b_i : in std_logic;
           c_in_i : in std_logic;
           sum_o : out std_logic;
           c_out_o : out std_logic);
end component full_adder;

    signal tb_a_sig : std_logic;
    signal tb_b_sig : std_logic;
    signal tb_c_in_sig : std_logic;
    signal tb_sum_sig : std_logic;
    signal tb_c_out_sig : std_logic;
    
begin

	inst_full_adder : full_adder
	port map(
		a_i 	=>	tb_a_sig, 
		b_i		=>	tb_b_sig,	
		c_in_i	=>	tb_c_in_sig,
		sum_o	=>	tb_sum_sig,
		c_out_o => 	tb_c_out_sig  
	);
	
    process
    begin
        tb_a_sig <= '0';
        tb_b_sig <= '0';
        tb_c_in_sig <= '0';
        wait for 125 ns;
        tb_a_sig <= '0';
        tb_b_sig <= '0';
        tb_c_in_sig <= '1';
        wait for 125 ns;
        tb_a_sig <= '0';
        tb_b_sig <= '1';
        tb_c_in_sig <= '0';
        wait for 125 ns;
        tb_a_sig <= '0';
        tb_b_sig <= '1';
        tb_c_in_sig <= '1';
        wait for 125 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '0';
        tb_c_in_sig <= '0';
        wait for 125 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '0';
        tb_c_in_sig <= '1';
        wait for 125 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '1';
        tb_c_in_sig <= '0';
        wait for 125 ns;
        tb_a_sig <= '1';
        tb_b_sig <= '1';
        tb_c_in_sig <= '1';
        wait for 125 ns; 
    wait;
    end process;     
end Behavioral;