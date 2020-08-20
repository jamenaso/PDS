library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;


--Siempre N > M, sino tenemos que tirar un error o de lo contrario hay que usar el resize.
entity round is
  generic (
        N           : integer   := 6;       --BITS DE ENTRADA
        M           : integer   := 4;       --BITS DE SALIDA
        ENA_ROUND   : std_logic := '1'      --Saturacion o Overflow
    );
  port (
        data_i : in  std_logic_vector(N-1 downto 0);
        data_o : out std_logic_vector(M-1 downto 0)
    ) ;
end round;

architecture behaivoral of round is
    constant SUM_MASK : integer := 2**(N-M-1); 

    --Recordar que sumar dos numeros siempre puede llevar a que aumente en 1 la magitud.
    signal data_temp_pre_saturation : std_logic_vector(data_i'LEFT+1 downto 0 );
    signal data_temp_pos_saturation : std_logic_vector(data_i'LEFT   downto 0 );
begin


ROUND_OR_TRUNC : if (ENA_ROUND = '1') generate
    comb_process : process( all )
        variable v_temp : signed(data_temp_pre_saturation'RANGE);
    begin
        --Realizamos directamente la suma por la constante para reudicir.      
        v_temp  := to_signed(to_integer(signed(data_i)) 
                 + to_integer(to_signed(SUM_MASK,data_i'LENGTH)),v_temp'LENGTH);
        data_temp_pre_saturation    <= std_logic_vector(v_temp);
    end process ; -- comb_process    

    --Como nosp odemso pasar por uno siempre hay que saturar.
    saturation_inst : entity work.saturation
        generic map (
            N   => data_temp_pre_saturation'LENGTH,
            M   => data_temp_pos_saturation'LENGTH,
            SAT => '1'
        )
        port map (
            data_i => data_temp_pre_saturation,
            data_o => data_temp_pos_saturation
        );    
    --Ya aca afectivamente nos quedamos con el pedazo que corresponde despues de haber sumado 1.
    data_o <= data_temp_pos_saturation(data_temp_pos_saturation'LEFT downto (data_temp_pos_saturation'LEFT-M+1));
else generate
    --Esto solo es truncamiento.
    data_o <= data_i(data_i'LEFT downto (data_i'LEFT-M+1));
end generate ROUND_OR_TRUNC;
end architecture ; -- behaivoral