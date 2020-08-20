#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Sat Aug 15 12:00:45 -05 2020
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto e8da10fab4c445ee9e7dbf233ca8f22e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_full_adder_behav xil_defaultlib.tb_full_adder -log elaborate.log"
xelab -wto e8da10fab4c445ee9e7dbf233ca8f22e --incr --debug typical --relax --mt 8 -L xil_defaultlib -L secureip --snapshot tb_full_adder_behav xil_defaultlib.tb_full_adder -log elaborate.log

