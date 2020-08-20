library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
    
entity ff_module is
    generic (
        N : integer := 8
    );
    Port ( clk_i      : in  STD_LOGIC;
           rst_i      : in  STD_LOGIC;
           enable_t_i : in  STD_LOGIC;
           data_i     : in  STD_LOGIC_VECTOR (N-1 downto 0);
           data_o     : out STD_LOGIC_VECTOR (N-1 downto 0));
end ff_module;

architecture Behavioral of ff_module is
    signal reg_signal : std_logic_vector(data_o'RANGE);
begin

    reg_process : process (clk_i, rst_i)
    begin
      if (rst_i = '0') then
        reg_signal <= (others => '0');
      elsif (rising_edge(clk_i)) then
        if (enable_t_i = '1') then
            reg_signal <= data_i;         
        end if;    
      end if;
    end process reg_process;

    data_o <= reg_signal;

end Behavioral;
