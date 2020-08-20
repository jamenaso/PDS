library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity saturation is
  generic (
        N   : integer   := 6;     --BITS DE ENTRADA
        M   : integer   := 4;     --BITS DE SALIDA
        SAT : std_logic := '1'   --Saturacion o Overflow
    );
  port (
        data_i : in  std_logic_vector(N-1 downto 0);
        data_o : out std_logic_vector(M-1 downto 0)
    ) ;
end entity ; -- saturation

architecture behaivoral of saturation is
    constant MAX_OV : integer := (2**(M-1))-1; 
    constant MIN_OV : integer := (-2**(M-1)); 
begin


SAT_OR_OV : if (SAT = '1') generate
    comb_process : process( all )
    begin
        --Chequeamos el bit de signo target
        --Si (N-1) es '0' es positivo  
        if ((data_i(N-1) = '0') and (or data_i(N-1 downto M-1) = '1')) then
            data_o <= std_logic_vector(to_signed(MAX_OV,data_o'LENGTH));
        --Si (N-1) es '1' es negativo
        elsif (data_i(N-1) = '1' and (and data_i(N-1 downto M-1) = '0')) then
            data_o <= std_logic_vector(to_signed(MIN_OV,data_o'LENGTH));
        else
            data_o <= data_i(M-1 downto 0);
        end if;       
    end process ; -- comb_process    
else generate
    data_o <= data_i(M-1 downto 0);
end generate SAT_OR_OV;
end architecture ; -- behaivoral
