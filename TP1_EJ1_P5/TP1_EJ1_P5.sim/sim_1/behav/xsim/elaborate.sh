#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Wed Aug 19 19:08:33 -05 2020
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto e7699f5c618c458381db612ce84adf3e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_sinc_system_behav xil_defaultlib.tb_sinc_system -log elaborate.log"
xelab -wto e7699f5c618c458381db612ce84adf3e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_sinc_system_behav xil_defaultlib.tb_sinc_system -log elaborate.log

