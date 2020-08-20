library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;
use std.textio.all;
use ieee.std_logic_textio.all;

entity tb_diff_ecuation is
end tb_diff_ecuation;

architecture Behavioral of tb_diff_ecuation is

    --Bits de la palabra de entrada
    constant N : integer := 8;
    --Bits de la palabra de salida
    constant M : integer := 16;
        
    constant CLK_PERIOD : time := 10 ns;
    signal clk_sig : std_logic := '1';    
    signal rst_sig : std_logic := '0';
    
    signal s_axis_tdata_tb     : std_logic_vector(N-1 downto 0);
    signal s_axis_tvalid_tb    : std_logic;
    signal s_axis_tready_tb    : std_logic;
    signal m_axis_tdata_tb     : std_logic_vector(M-1 downto 0);
    signal m_axis_tvalid_tb    : std_logic;
    signal m_axis_tready_tb    : std_logic;
    
    --Entidad del módulo ecuación diferencial 
    component diff_ecuation is
    generic (
        --Bits de la palabra de entrada
        N : integer := 8;
        --Bits de la palabra de salida
        M : integer := 16);
    Port ( 
        clk_i           : in STD_LOGIC;
        rst_i           : in STD_LOGIC;
        s_axis_tdata_i  : in  STD_LOGIC_VECTOR (N-1 downto 0);
        s_axis_tvalid_i : in  STD_LOGIC;
        s_axis_tready_o : out STD_LOGIC;
        m_axis_tdata_o  : out STD_LOGIC_VECTOR (M-1 downto 0);
        m_axis_tvalid_o : out STD_LOGIC;
        m_axis_tready_i : in  STD_LOGIC);
    end component diff_ecuation;
    
    constant in_file    : string  := "data_in.txt"; 
    constant out_file   : string  := "data_out.txt"; 

    file r_fptr,w_fptr : text;
    
    --Items para guardar
    constant ITEMS_TO_SAVE : integer := 200; 
    
    constant C_CLK_PERIOD : real := 10.0e-9; -- NS
begin

    -----------------------------------------------------------
    -- Clocks and Reset
    -----------------------------------------------------------
    
    clk_sig <= not clk_sig after CLK_PERIOD/2;
    rst_sig <= '1'after 100 ns; 
    
    -----------------------------------------------------------
    --Estimulos a las señales
    -----------------------------------------------------------
    -- Read file process
    p_read_file : process is
        variable fstatus    : file_open_status;
        variable file_line  : line;
        variable slv_v      : integer;
    begin
        --Por defecto deshabilitamos la transacción
        --Abrimos el archivo
        file_open(fstatus, r_fptr,in_file, read_mode);
        --Asignación por defecto.
        s_axis_tdata_tb     <= (others => '0');
        s_axis_tvalid_tb    <= '0';
        wait until (rst_sig = '1');
        --Hacemos un espera en ciclos de reloj
        delay_1 : for i in 0 to 10-1 loop
            wait until (clk_sig'event and clk_sig = '1');           
        end loop;
        --Recorremos el archivo
        loop_file : while not endfile(r_fptr) loop
            readline(r_fptr,file_line);
            read(file_line,slv_v);
            report "Valor leido: " & integer'image(slv_v);
            --Generemos la señal AXI con el pulso en '1' cuando recibamos el tready. 
            if (s_axis_tready_tb = '1') then
                s_axis_tdata_tb <= std_logic_vector(to_signed(slv_v, N));
                s_axis_tvalid_tb <= '1';                
            end if;
            --Esperamos 10 ciclos de relog y se obtiene el periodo de la frecuencia de muestreo
            wait until (clk_sig'event and clk_sig = '1');                       
            s_axis_tvalid_tb <= '0';                           
            delay_2 : for i in 0 to 9-1 loop
                wait until (clk_sig'event and clk_sig = '1');           
            end loop;
        end loop ; -- loop_file
        s_axis_tdata_tb     <= (others => '0');
        s_axis_tvalid_tb    <= '0';
        report "Fin lectura del archivo";
        file_close(r_fptr);
        wait;
    end process; -- p_read_file    
    
     p_write_file : process is
        variable fstatus    : file_open_status;
        variable file_line  : line;
        variable v_int      : integer;
        variable v_std_lv   : std_logic_vector((m_axis_tdata_tb'LENGTH - 1) downto 0);
    begin
        -- Para este caso vamos a aceptar todos los datos que salgan.
        m_axis_tready_tb <= '1';
        --Abrimos el archivo
        file_open(fstatus, w_fptr,out_file,write_mode);
        wait until (rst_sig = '1');
        
        --Vamos a escribir solo 200.
        write_file : for i in 0 to ITEMS_TO_SAVE loop
            wait until (m_axis_tvalid_tb = '1');
            v_int    := to_integer(signed(m_axis_tdata_tb));    
            v_std_lv := m_axis_tdata_tb;
            write(file_line,v_int);
            write(file_line,v_std_lv,right,40);
            writeline(w_fptr, file_line);
            report "Valor ESCRITO: " & integer'image(v_int);
            report "Indice: " & integer'image(i);
        end loop;
        report "Fin escritura del archivo";
        file_close(w_fptr);
        wait;
    end process; -- p_write_file   
    
-----------------------------------------------------------
--Instancia que se pone a prueba en el testbench
-----------------------------------------------------------

    inst_diff_ecuation : diff_ecuation
        generic map (
            N  => 8,
            M  => 16
        )
        port map (
            clk_i           => clk_sig,
            rst_i           => rst_sig,
            s_axis_tdata_i  => s_axis_tdata_tb,
            s_axis_tvalid_i => s_axis_tvalid_tb,
            s_axis_tready_o => s_axis_tready_tb,
            m_axis_tdata_o  => m_axis_tdata_tb,
            m_axis_tvalid_o => m_axis_tvalid_tb,
            m_axis_tready_i => m_axis_tready_tb
        );
    
end Behavioral;