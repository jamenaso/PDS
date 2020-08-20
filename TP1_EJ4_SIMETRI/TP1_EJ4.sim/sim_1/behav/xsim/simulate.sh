#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Wed Aug 19 12:47:18 -05 2020
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim tb_symmetrical_fir_behav -key {Behavioral:sim_1:Functional:tb_symmetrical_fir} -tclbatch tb_symmetrical_fir.tcl -view /home/jamm/PDS/TP1_EJ4_SIMETRI/tb_symmetrical_fir_behav.wcfg -log simulate.log"
xsim tb_symmetrical_fir_behav -key {Behavioral:sim_1:Functional:tb_symmetrical_fir} -tclbatch tb_symmetrical_fir.tcl -view /home/jamm/PDS/TP1_EJ4_SIMETRI/tb_symmetrical_fir_behav.wcfg -log simulate.log

