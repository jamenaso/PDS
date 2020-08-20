library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity mul_module is
    generic (
        N : integer := 17;
        M : integer := 18);
    Port ( coeff_in : in  STD_LOGIC_VECTOR (N - 1 downto 0);
           data_in  : in  STD_LOGIC_VECTOR (N - 1 downto 0);
           data_out : out STD_LOGIC_VECTOR (M-1 downto 0));
end mul_module;

architecture Behavioral of mul_module is
 
    --Señal que ontiene el resultado de la multimplicación de la entrada y su factor. 
    --EL resultado tiene una palabra de 34bits con formato Q4.30
    signal mul : std_logic_vector(2*N - 1 downto 0);         
    
begin

    --Se realiza la multiplicacion de la entrada con el factor los formatos de los dos numeros son Q1.15, 16bits
    mul <= std_logic_vector(to_signed(to_integer(signed(coeff_in)) * to_integer(signed(data_in)), 2*N));   
    --Se realiza el truncado del resultado quedando un número con formato Q1.17, 18bits 
    data_out <= mul(30 downto 13); 

end Behavioral;
