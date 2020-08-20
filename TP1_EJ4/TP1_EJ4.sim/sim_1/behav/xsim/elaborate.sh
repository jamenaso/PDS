#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Tue Aug 18 17:10:21 -05 2020
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 7d0aa4b573f84fdaaee2eec824d3eb22 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_symmetrical_fir_behav xil_defaultlib.tb_symmetrical_fir -log elaborate.log"
xelab -wto 7d0aa4b573f84fdaaee2eec824d3eb22 --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_symmetrical_fir_behav xil_defaultlib.tb_symmetrical_fir -log elaborate.log

