library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_ripple_carry_adder is
end tb_ripple_carry_adder;

architecture Behavioral of tb_ripple_carry_adder is

component ripple_carry_adder is
    Port ( a_i : in std_logic_vector (3 downto 0);
           b_i : in std_logic_vector (3 downto 0);
           s_o : out std_logic_vector (3 downto 0);
           c_o : out std_logic);
end component ripple_carry_adder;

signal tb_a_sig : std_logic_vector(3 downto 0);
signal tb_b_sig : std_logic_vector(3 downto 0);
signal tb_s_sig : std_logic_vector(3 downto 0);
signal tb_c_sig : std_logic;

begin

	inst_ripple_carry_adder : ripple_carry_adder
	port map
	(
		a_i   =>	tb_a_sig, 
		b_i	  =>	tb_b_sig,	
		s_o	  =>	tb_s_sig,
		c_o	  =>	tb_c_sig 
	);
	
    process
	begin
		tb_a_sig   <= std_logic_vector(to_unsigned(4,4));
		tb_b_sig   <= std_logic_vector(to_unsigned(3,4));
		wait for 250 ns;

		tb_a_sig   <= std_logic_vector(to_unsigned(10,4));
		tb_b_sig   <= std_logic_vector(to_unsigned(6,4));
		wait for 250 ns;
		
        tb_a_sig   <= std_logic_vector(to_unsigned(8,4));
		tb_b_sig   <= std_logic_vector(to_unsigned(8,4));
		wait for 250 ns;
		
		tb_a_sig   <= std_logic_vector(to_unsigned(2,4));
		tb_b_sig   <= std_logic_vector(to_unsigned(7,4));
		wait for 250 ns;
		
		wait;
	end process;

end Behavioral;
