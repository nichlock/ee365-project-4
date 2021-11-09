library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_logic_tb is
end top_logic_tb;

architecture tb of top_logic_tb is
	-- inputs from top_logic
	signal rst			: std_logic;
	signal sys_clk		: std_logic;
	signal data_result	: STD_LOGIC_VECTOR(15 downto 0);
	
	signal toggle		 : std_logic;
	signal step	         : std_logic;
	signal en            : std_logic := '1';

begin
-- PORT MAP TO TOP_LEVEL ------------------------------------------------------
   DUT : entity work.top_logic
		generic map(N => 10, 
		            B => 4,
		            BAUD => 1,
		            CLK_SPEED_HZ => 2,
		            COUNT_FREQ_HZ => 1,
		            SCK_SPEED => 1
		            ) 
			port map (
			  iRst      => rst,
			  iEn       => en,
			  iClk      => sys_clk,
			  iToggle   => toggle,
			  iStep     => step,
			  oData     => data_result
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
	rst <= '1';
	toggle <= '1';
	step <= '0';
	wait for 1ns; -- Sample after clocking
	wait for 20ns; -- Settle registers
	assert (data_result = x"0000") report "FAILED: Loaded non-zero reset value" severity error;
	
	rst <= '0';
	wait for 600ns; -- Allow init to occur on TX
	
	-- COUNTS UP AND SETS OUTPUT -----------------------------------------------
	rst <= '0';
	step <= '1';
	wait for 10ns;
	step <= '0';
	wait for 40ns;
	assert (data_result = x"FADE") report "FAILED: Data did not increment correctly" severity error;

	-- FULL UPCOUNT WORKS ------------------------------------------------------
	
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"CAFE") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"4B1D") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"FEED") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"1BAD") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"D00D") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"DEAD") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"BEEF") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"F00D") report "FAILED: Data did not increment correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"F00D") report "FAILED: Data was allowed to count beyond N - 1" severity error;
	
	-- COUNTS DOWN -------------------------------------------------------------
	toggle <= '0';
	wait for 40ns;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"BEEF") report "FAILED: Data did not decrement correctly" severity error;
	
	
	-- FULL DOWNCOUNT WORKS ----------------------------------------------------
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"DEAD") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"D00D") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"1BAD") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"FEED") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"4B1D") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"CAFE") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"FADE") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"0000") report "FAILED: Data did not decrement correctly" severity error;
	step <= '1'; wait for 10ns; step <= '0'; wait for 40ns; assert (data_result = x"0000") report "FAILED: Data decrement below 0" severity error;
	
	-- PICKS UP SUDDEN CHANGE --------------------------------------------------
	
	wait for 500ns;
	toggle <= '1';
	wait for 50ns;
	toggle <= '0';
	en <= '0';
	
	-- END OF TEST CODE --------------------------------------------------------
	----------------------------------------------------------------------------
	----------------------------------------------------------------------------
	wait;
end process;
end tb;