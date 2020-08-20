library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity simple_alu is
	generic (N : integer);
    port (
    sel_i : in std_logic_vector(1 downto 0);
    a_i : in std_logic_vector(N-1 downto 0);
    b_i : in std_logic_vector(N-1 downto 0);
    c_o : out std_logic_vector(N-1 downto 0)
    );
end simple_alu;

architecture Behavioral of simple_alu is

begin

	--Se implementa un multiplexor donde la operación de salida en (c_o) 
	--depende de la señal de selección (sel_i)
	out_mux :
	c_o <= 	std_logic_vector(unsigned(a_i) + unsigned(b_i)) when sel_i = "00" else
			std_logic_vector(unsigned(a_i) - unsigned(b_i)) when sel_i = "01" else
			a_i or b_i  when sel_i = "10" else
			a_i and b_i when sel_i = "11";
			
end Behavioral;

				