# stop any simulation that is currently running
quit -sim
# create the default "work" library
vlib work;
# compile the VHDL source code, and the testbench
vcom *.vhd
vcom *.vht
vsim +altera -do wave.do -l msim_transcript -gui work.exam1_tb
run 1200ns