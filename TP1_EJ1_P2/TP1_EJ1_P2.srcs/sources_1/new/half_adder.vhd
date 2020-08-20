library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity half_adder is
    Port ( a_i : in std_logic;
           b_i : in std_logic;
           sum_o : out std_logic;
           c_out_o : out std_logic);
end half_adder;

architecture Behavioral of half_adder is

begin

    sum_o   <=  a_i xor b_i; 
    c_out_o <=  a_i and b_i; 

end Behavioral;
