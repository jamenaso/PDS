library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ripple_carry_adder is
    Port ( a_i : in std_logic_vector (3 downto 0);
           b_i : in std_logic_vector (3 downto 0);
           s_o : out std_logic_vector (3 downto 0);
           c_o : out std_logic);
end ripple_carry_adder;

architecture Behavioral of ripple_carry_adder is

    component full_adder is
        Port ( a_i : in std_logic;
               b_i : in std_logic;
               c_in_i : in std_logic;
               sum_o : out std_logic;
               c_out_o : out std_logic);
    end component full_adder;

    signal c_1_sig : std_logic;
    signal c_2_sig : std_logic;
    signal c_3_sig : std_logic;
    
begin

	full_adder_0 : full_adder
	port map
	(
		a_i 	=>	a_i(0), 
		b_i		=>	b_i(0),	
		c_in_i	=>	'0',
		sum_o	=>	s_o(0),
		c_out_o =>  c_1_sig	  
	);
	
    full_adder_1 : full_adder
	port map
	(
		a_i 	=>	a_i(1), 
		b_i		=>	b_i(1),	
		c_in_i	=>	c_1_sig,
		sum_o	=>	s_o(1),
		c_out_o =>  c_2_sig	  
	);
	
    full_adder_2 : full_adder
	port map
	(
		a_i 	=>	a_i(2), 
		b_i		=>	b_i(2),	
		c_in_i	=>	c_2_sig,
		sum_o	=>	s_o(2),
		c_out_o =>  c_3_sig	   
	);
	
    full_adder_3 : full_adder
	port map
	(
		a_i 	=>	a_i(3), 
		b_i		=>	b_i(3),	
		c_in_i	=>  c_3_sig,
		sum_o	=>	s_o(3),
		c_out_o =>  c_o	  
	);                  

end Behavioral;
