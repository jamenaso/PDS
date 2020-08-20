library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity full_adder is
    Port ( a_i : in std_logic;
           b_i : in std_logic;
           c_in_i : in std_logic;
           sum_o : out std_logic;
           c_out_o : out std_logic);
end full_adder;

architecture Behavioral of full_adder is

    component half_adder is
        Port ( a_i : in std_logic;
               b_i : in std_logic;
               sum_o : out std_logic;
               c_out_o : out std_logic);
    end component half_adder;

    signal a_xor_b_sig : std_logic;
    signal a_and_b_sig : std_logic;
    
    signal a_xor_b_and_c_sig : std_logic;

begin

	half_adder_1 : half_adder
	port map
	(
		a_i 	=>	a_i, 
		b_i		=>	b_i,	
		sum_o	=>	a_xor_b_sig,
		c_out_o	=>	a_and_b_sig	  
	);
	
    half_adder_2 : half_adder
    port map
    (
        a_i     =>    a_xor_b_sig, 
        b_i     =>    c_in_i,    
        sum_o   =>    sum_o,
        c_out_o =>    a_xor_b_and_c_sig      
    );
    
    c_out_o <= a_and_b_sig or a_xor_b_and_c_sig;

end Behavioral;
