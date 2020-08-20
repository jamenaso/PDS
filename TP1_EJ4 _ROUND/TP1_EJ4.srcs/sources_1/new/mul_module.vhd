library ieee;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

entity mul_module is
    generic (
        N : integer := 16;
        M : integer := 18);
    Port ( coeff_in : in  STD_LOGIC_VECTOR (N - 1 downto 0);
           data_in  : in  STD_LOGIC_VECTOR (N - 1 downto 0);
           data_out : out STD_LOGIC_VECTOR (M-1 downto 0));
end mul_module;

architecture Behavioral of mul_module is

    component round is
    generic (
        N           : integer   := 32;       --BITS DE ENTRADA
        M           : integer   := 18;       --BITS DE SALIDA
        ENA_ROUND   : std_logic := '1'      --Saturacion o Overflow
    );
    port (
        data_i : in  std_logic_vector(N-1 downto 0);
        data_o : out std_logic_vector(M-1 downto 0)
    ) ;
    end component round;
 
    --Señal que ontiene el resultado de la multimplicación de la entrada y su factor. 
    --EL resultado tiene una palabra de 32bits con formato Q2.30
    signal mul : std_logic_vector(2*N - 1 downto 0);         
    
begin


    --Se realiza la multiplicacion de la entrada con el factor los formatos de los dos numeros son Q1.15, 16bits
    mul <= std_logic_vector(to_signed(to_integer(signed(coeff_in)) * to_integer(signed(data_in)), 2*N));   
    --Se realiza el truncado del resultado quedando un número con formato Q2.16, 18bits 
    --Como nosp odemso pasar por uno siempre hay que saturar.
    saturation_inst : round
    generic map (
        N   => 32,
        M   => 18,
        ENA_ROUND => '1'
    )
    port map (
        data_i => mul,
        data_o => data_out
    ); 

end Behavioral;
