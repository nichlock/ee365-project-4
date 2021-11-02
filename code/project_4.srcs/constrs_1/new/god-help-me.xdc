

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

create_clock -add -name sys_clk_pin -period 40.00 -waveform {0 4} [get_ports { clk }];
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS18 } [get_ports { clk }];

set_property -dict {PACKAGE_PIN N15 IOSTANDARD LVCMOS18} [get_ports led0_r]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS18} [get_ports led1_r]
set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS18} [get_ports {btn[0]}]
set_property -dict {PACKAGE_PIN D19 IOSTANDARD LVCMOS18} [get_ports {btn[1]}]
set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS18} [get_ports {ja[0]}]
