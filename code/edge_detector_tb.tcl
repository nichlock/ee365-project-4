# stop any simulation that is currently running
quit -sim
# create the default "work" library
vlib work;
# compile the VHDL source code, and the testbench
vcom *.vhd
vcom *.vht
vsim +altera -do edge_detector.do -l msim_transcript -gui work.edge_detector_tb
run 250ns