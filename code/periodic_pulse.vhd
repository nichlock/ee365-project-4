library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity periodic_pulse is
generic(FREQ_HZ: integer := 1;
        CLK_SPEED_HZ: integer := 125000000);
port(
  iClk     : in  std_logic;
  iRst     : in  std_logic;
  oPulse   : out std_logic);
end periodic_pulse;
architecture Behavioral of periodic_pulse is

    signal clk_divider : unsigned (32 downto 0) := (others => '0');

begin
    process(iClk, iRst)
    begin
      if(iRst = '1') then
        clk_divider <= (others => '0');
      elsif(rising_edge(iClk)) then
          if(clk_divider = (CLK_SPEED_HZ / FREQ_HZ)) then
            oPulse <= '1';
            clk_divider <= (others => '0');
          else
            oPulse <= '0';
            clk_divider <= clk_divider + 1;
          end if;
      end if;
      
    end process;
end Behavioral;