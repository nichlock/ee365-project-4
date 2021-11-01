library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity edge_detector_tb is
end edge_detector_tb ;

architecture tb of edge_detector_tb is
	signal sys_clk			: std_logic;
	signal input_signal	: std_logic;
	signal enable			: std_logic;
	signal pulse			: std_logic;
	signal pulse_n			: std_logic;

begin
-- PORT MAP TO TOP_LEVEL ------------------------------------------------------
   DUT : entity work.edge_detector
		generic map(high_edges => '1', clock_sample_edge => '1') 
			port map (
           iInput   => input_signal,
           iEn      => enable,
           iClk     => sys_clk,
	        oPulse   => pulse
		   );

   DUT_n : entity work.edge_detector
		generic map(high_edges => '0') 
			port map (
           iInput   => input_signal,
           iEn      => enable,
           iClk     => sys_clk,
	        oPulse   => pulse_n
		   );

clock_driver : process
begin -- Clock rising edge every 10 ns
	sys_clk <= '1';
	wait for 5ns;
	sys_clk <= '0';
	wait for 5ns;
end process;


tb1 : process
begin
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
   -- BEGIN TEST CODE ---------------------------------------------------------
	assert (pulse = '0') report "FAILED: Non-zero startup value" severity error;
	enable <= '0';
	input_signal <= '0';
	wait for 1ns; -- Sample after clocking
	wait for 20ns; -- Settle registers
	assert (pulse = '0') report "FAILED: Non-zero startup value" severity error;
	
	-- NO PULSE ---------------------------------------------------------------
	enable <= '0';
	input_signal <= '1';
	wait for 20ns; -- Settle registers
	assert (pulse = '0') report "FAILED: Pulse should be low when not enabled" severity error;
	input_signal <= '0';
	wait for 20ns;
	
	-- HIGH PULSE --------------------------------------------------------------
	enable <= '1';
	input_signal <= '1';
	wait for 10ns;
	assert (pulse = '0') report "FAILED: Pulse went high faster than anticipated" severity error;
	wait for 10ns;
	assert (pulse = '1') report "FAILED: Pulse does not go high" severity error;
	wait for 10ns;
	assert (pulse = '0') report "FAILED: Pulse does not go away after one clock cycle" severity error;
	input_signal <= '0';
	wait for 20ns;

	input_signal <= '1';
	wait for 10ns;
	input_signal <= '0';
	wait for 10ns;
	assert (pulse = '1') report "FAILED: Pulse does not go high for a pusled input" severity error;
	wait for 10ns;
	
	
	-- LOW PULSES --------------------------------------------------------------
	wait for 20ns; -- Visually seperate in the waveform viewer
	
	input_signal <= '1';
	wait for 20ns;
	assert (pulse_n = '0') report "FAILED: Pulse occured on rising edge, but configuration is for falling edge" severity error;
	input_signal <= '0';
	wait for 20ns;
	assert (pulse_n = '1') report "FAILED: Pulse does not go high for a falling edge input when configured to" severity error;
	
	-- END OF TEST CODE --------------------------------------------------------
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	wait;
end process;
end tb;