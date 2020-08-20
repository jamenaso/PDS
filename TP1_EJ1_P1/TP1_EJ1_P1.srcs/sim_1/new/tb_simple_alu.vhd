library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_simple_alu is
    generic (Nb : integer := 16);
end tb_simple_alu;

architecture Behavioral of tb_simple_alu is

	component simple_alu is
		generic (N : integer);
		port (
			sel_i : in std_logic_vector(1 downto 0);
			a_i : in std_logic_vector(N-1 downto 0);
			b_i : in std_logic_vector(N-1 downto 0);
			c_o : out std_logic_vector(N-1 downto 0)
		);
	end component simple_alu;

	constant M : integer := Nb;
	signal tb_sel_sig : std_logic_vector(1 downto 0);
	signal tb_a_sig : std_logic_vector(Nb-1 downto 0);
	signal tb_b_sig : std_logic_vector(Nb-1 downto 0);
	signal tb_c_sig : std_logic_vector(Nb-1 downto 0);
	
begin

	inst_simple_alu : simple_alu
	generic map(
		N => 16
	)
	port map(
		sel_i 	=>	tb_sel_sig, 
		a_i		=>	tb_a_sig,	
		b_i		=>	tb_b_sig,
		c_o		=>	tb_c_sig	  
	);

    --Se implementa un proceso que introduce dos valores de entrada (26 y 38) y realiza 
    --las cuatro operaciones cambiando la señal de selección sobre la intancia de la ALU, 
    --realiza el mismo proceso con otro dos valores de entrada (15 y 38)
	process
	begin
		tb_a_sig   <= std_logic_vector(to_unsigned(26,M));
		tb_b_sig   <= std_logic_vector(to_unsigned(38,M));
		tb_sel_sig   <= "00";
		wait for 125 ns;
		tb_sel_sig   <= "01";
		wait for 125 ns;
		tb_sel_sig   <= "10";
		wait for 125 ns;
		tb_sel_sig   <= "11";
		wait for 125 ns;
		tb_a_sig   <= std_logic_vector(to_unsigned(15,M));
		tb_b_sig   <= std_logic_vector(to_unsigned(41,M));
		tb_sel_sig   <= "00";
		wait for 125 ns;
		tb_sel_sig   <= "01";
		wait for 125 ns;
		tb_sel_sig   <= "10";
		wait for 125 ns;
		tb_sel_sig   <= "11";
		wait for 125 ns;		
		wait;
	end process;
end Behavioral;
