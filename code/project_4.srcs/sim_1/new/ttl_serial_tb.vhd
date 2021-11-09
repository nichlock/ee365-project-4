library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ttl_serial_tb is
end ttl_serial_tb ;

architecture tb of ttl_serial_tb is
    signal dut_data	 	 : std_logic_vector(7 downto 0);
    signal sys_clk	 	 : std_logic;
    signal dut_trig      : std_logic;
    signal dut_rst       : std_logic;
    signal dut_ready     : std_logic := '0';
	signal dut_tx 		 : std_logic := '1';

begin
-- PORT MAP TO TOP_LEVEL ------------------------------------------------------
   DUT : entity work.ttl_serial
		generic map(BAUD_BPS => 1, CLK_SPEED_HZ => 1) 
			port map (
			  iData      => dut_data,
			  iClk       => sys_clk,
			  iRst       => dut_rst,
			  iTrigger   => dut_trig,
			  oReady     => dut_ready,
			  oTx        => dut_tx
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
	dut_trig <= '0';
	dut_rst <= '1';
	wait for 1ns; -- Sample after clocking
	wait for 20ns; -- Settle registers
	dut_rst <= '0';
	wait for 20ns;
	assert (dut_tx = '1') report "FAILED: TX default is not one" severity error;
	assert (dut_ready = '1') report "FAILED: DUT not ready" severity error;


	-- VALID OUTPUT SEQUENCE ---------------------------------------------------
    dut_data <= x"AA";
	dut_trig <= '1';
	wait for 10ns;
	dut_trig <= '0';
	wait for 20ns; assert (dut_tx = '0') report "FAILED: No start bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: No stop bit" severity error;

	-- VALID OUTPUT SEQUENCE 1 --------------------------------------------------
    dut_data <= x"55";
	dut_trig <= '1';
	wait for 10ns;
	dut_trig <= '0';
	wait for 20ns; assert (dut_tx = '0') report "FAILED: No start bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: No stop bit" severity error;
	

	-- VALID OUTPUT SEQUENCE 2 -------------------------------------------------
	wait for 10ns;
    dut_data <= x"6F";
	dut_trig <= '1';
	wait for 10ns;
	dut_trig <= '0';
	wait for 20ns; assert (dut_tx = '0') report "FAILED: No start bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '0') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: Invlaid bit" severity error;
	wait for 20ns; assert (dut_tx = '1') report "FAILED: No stop bit" severity error;
	

	-- END OF TEST CODE --------------------------------------------------------
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	wait;
end process;
end tb;