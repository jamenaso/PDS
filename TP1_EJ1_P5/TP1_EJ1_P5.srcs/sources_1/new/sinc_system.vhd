library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

    entity sinc_system is
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
    end sinc_system;

architecture Behavioral of sinc_system is

signal out1_sig : std_logic_vector(7 downto 0);
signal out2_sig : std_logic_vector(7 downto 0);

begin
	
    reg_file : process (rst_i, clk_i)
    begin
        if (rst_i = '0') then
            out1_sig <= (others => '0');
            out2_sig <= (others => '0');
        elsif (rising_edge(clk_i)) then
        
            out1_sig <= std_logic_vector(unsigned(in1_i) 
                                       + unsigned(in2_i) 
                                       + unsigned(in3_i) 
                                       + unsigned(in4_i));
                                       
            out2_sig <= in1_i and in2_i and in3_i and in4_i;
        
        end if;
    end process reg_file;

    out1_o <= out1_sig; 
    out2_o <= out2_sig; 

end Behavioral;