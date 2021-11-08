set_property IOSTANDARD LVCMOS18 [get_ports {ja[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {ja[6]}]

set_property PACKAGE_PIN W19 [get_ports {ja[7]}]
set_property PACKAGE_PIN W18 [get_ports {ja[6]}]
set_property PACKAGE_PIN U19 [get_ports {ja[5]}]
set_property PACKAGE_PIN U18 [get_ports {ja[4]}]
set_property PACKAGE_PIN Y17 [get_ports {ja[3]}]
set_property PACKAGE_PIN Y16 [get_ports {ja[2]}]
set_property PACKAGE_PIN Y19 [get_ports {ja[1]}]

set_property IOSTANDARD LVCMOS18 [get_ports {jb[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {jb[6]}]

set_property PACKAGE_PIN W19 [get_ports {jb[7]}]
set_property PACKAGE_PIN W18 [get_ports {jb[6]}]
set_property PACKAGE_PIN U19 [get_ports {jb[5]}]
set_property PACKAGE_PIN U18 [get_ports {jb[4]}]
set_property PACKAGE_PIN Y17 [get_ports {jb[3]}]
set_property PACKAGE_PIN Y16 [get_ports {jb[2]}]
set_property PACKAGE_PIN Y19 [get_ports {jb[1]}]



create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports clk]
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS18} [get_ports clk]

set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports led0_r]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports led1_r]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS18} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS18} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS18} [get_ports {ja[0]}]

#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[0]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[1]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[2]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[3]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[6]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/ttl_data[7]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[1]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[3]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[5]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[6]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[8]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[15]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[0]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[4]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[7]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[10]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[11]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[12]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[13]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/data_to_output[14]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[4]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[11]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[14]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[15]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[23]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[29]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[6]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[1]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[5]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[8]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[13]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[16]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[22]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[28]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[31]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[3]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[9]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[12]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[18]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[21]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[24]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[25]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[27]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[2]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[0]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[7]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[10]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[17]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[19]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[20]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[26]}]
#set_property MARK_DEBUG true [get_nets {tl/data_output/byte_sel[30]}]
#set_property MARK_DEBUG true [get_nets tl/data_output/iClk]

#create_debug_core u_ila_0 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#set_property port_width 1 [get_debug_ports u_ila_0/clk]
#connect_debug_port u_ila_0/clk [get_nets [list tl/data_output/iClk]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
#set_property port_width 32 [get_debug_ports u_ila_0/probe0]
#connect_debug_port u_ila_0/probe0 [get_nets [list {tl/data_output/byte_sel[0]} {tl/data_output/byte_sel[1]} {tl/data_output/byte_sel[2]} {tl/data_output/byte_sel[3]} {tl/data_output/byte_sel[4]} {tl/data_output/byte_sel[5]} {tl/data_output/byte_sel[6]} {tl/data_output/byte_sel[7]} {tl/data_output/byte_sel[8]} {tl/data_output/byte_sel[9]} {tl/data_output/byte_sel[10]} {tl/data_output/byte_sel[11]} {tl/data_output/byte_sel[12]} {tl/data_output/byte_sel[13]} {tl/data_output/byte_sel[14]} {tl/data_output/byte_sel[15]} {tl/data_output/byte_sel[16]} {tl/data_output/byte_sel[17]} {tl/data_output/byte_sel[18]} {tl/data_output/byte_sel[19]} {tl/data_output/byte_sel[20]} {tl/data_output/byte_sel[21]} {tl/data_output/byte_sel[22]} {tl/data_output/byte_sel[23]} {tl/data_output/byte_sel[24]} {tl/data_output/byte_sel[25]} {tl/data_output/byte_sel[26]} {tl/data_output/byte_sel[27]} {tl/data_output/byte_sel[28]} {tl/data_output/byte_sel[29]} {tl/data_output/byte_sel[30]} {tl/data_output/byte_sel[31]}]]
#create_debug_port u_ila_0 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
#set_property port_width 2 [get_debug_ports u_ila_0/probe1]
#connect_debug_port u_ila_0/probe1 [get_nets [list {tl/data_output/state[0]} {tl/data_output/state[1]}]]
#create_debug_core u_ila_1 ila
#set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
#set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
#set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
#set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_1]
#set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
#set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
#set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
#set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
#set_property port_width 1 [get_debug_ports u_ila_1/clk]
#connect_debug_port u_ila_1/clk [get_nets [list tl/data_output/iClk]]
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
#set_property port_width 6 [get_debug_ports u_ila_1/probe0]
#connect_debug_port u_ila_1/probe0 [get_nets [list {tl/data_output/ttl_data[0]} {tl/data_output/ttl_data[1]} {tl/data_output/ttl_data[2]} {tl/data_output/ttl_data[3]} {tl/data_output/ttl_data[6]} {tl/data_output/ttl_data[7]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
#set_property port_width 14 [get_debug_ports u_ila_1/probe1]
#connect_debug_port u_ila_1/probe1 [get_nets [list {tl/data_output/data_to_output[0]} {tl/data_output/data_to_output[1]} {tl/data_output/data_to_output[3]} {tl/data_output/data_to_output[4]} {tl/data_output/data_to_output[5]} {tl/data_output/data_to_output[6]} {tl/data_output/data_to_output[7]} {tl/data_output/data_to_output[8]} {tl/data_output/data_to_output[10]} {tl/data_output/data_to_output[11]} {tl/data_output/data_to_output[12]} {tl/data_output/data_to_output[13]} {tl/data_output/data_to_output[14]} {tl/data_output/data_to_output[15]}]]
#create_debug_port u_ila_1 probe
#set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
#set_property port_width 1 [get_debug_ports u_ila_1/probe2]
#connect_debug_port u_ila_1/probe2 [get_nets [list tl/data_output/iClk]]
#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets clk_IBUF_BUFG]
