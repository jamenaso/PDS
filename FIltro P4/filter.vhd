-- ------------------------------------------------------------------------------------
-- 
-- VHDL FIR filter coefficient package file
-- Generated by pyFDA 0.3 (https://github.com/chipmuenk/pyfda)
-- 
-- Designed:	18-agosto-2020 11:30:41
-- Saved:	18-agosto-2020 11:31:15
-- 
-- Filter type:	LP, Manual_FIR (Order = 6)
-- Sample Frequency 	f_S =  f_Ny
-- 
-- Corner Frequencies:
-- 	F_PB = 0.1 f_Ny : A_PB = 0.9999999999999992 dB
-- 	F_SB = 0.3 f_Ny : A_SB = 20.0 dB
-- ------------------------------------------------------------------------------------
-- 
library IEEE;
use IEEE.math_real.all;
USE IEEE.std_logic_1164.all;

package coeff_package is
constant n_taps: integer := 6;
type coeff_type is array(0 to n_taps) of real;
constant coeff : coeff_type := (
	-0.04895593695235194,
	0.06275537458572507,
	0.29246401053451393,
	0.4226075033374576,
	0.29246401053451393,
	0.06275537458572507,
	-0.04895593695235194);

end coeff_package;