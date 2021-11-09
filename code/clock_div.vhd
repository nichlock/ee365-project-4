library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity clock_div is
port(
  iClk     : in  std_logic;
  iRst     : in  std_logic;
  oDiv2    : out std_logic;
  oDiv4    : out std_logic;
  oDiv8    : out std_logic;
  oDiv16   : out std_logic);
end clock_div;
architecture Behavioral of clock_div is

    signal clk_divider : unsigned(3 downto 0);

begin
    process(iClk, iRst)
    begin
      if(iRst = '1') then
        clk_divider <= x"0";
      elsif(rising_edge(iClk)) then
        clk_divider <= clk_divider + 1;
      end if;
    end process;
 
    oDiv2  <= clk_divider(0);
    oDiv4  <= clk_divider(1);
    oDiv8  <= clk_divider(2);
    oDiv16 <= clk_divider(3);
end Behavioral;