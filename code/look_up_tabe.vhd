library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity look_up_table is
    generic(
	   N: integer := 10;
	   B: integer := 4
	 );
    port (
      iRst       : in STD_LOGIC;
      iCnt       : in STD_LOGIC_VECTOR(B-1 downto 0); 
      iClk       : in STD_LOGIC;
	  oData      : out STD_LOGIC_VECTOR(15 downto 0)
    );
end look_up_table;

architecture table of look_up_table is

begin

  process (iRst, iClk)
  begin
    if(iRst = '1') then
	   oData <= x"0000";
    elsif (iClk = '1') then
      case iCnt is 
        when x"0" => oData <= x"0000";
        when x"1" => oData <= x"FADE";
        when x"2" => oData <= x"CAFE";
        when x"3" => oData <= x"4B1D";
        when x"4" => oData <= x"FEED";
        when x"5" => oData <= x"1BAD";
        when x"6" => oData <= x"D00D";
        when x"7" => oData <= x"DEAD";
        when x"8" => oData <= x"BEEF";
        when x"9" => oData <= x"F00D";
        when others => oData <= x"FFFF";
      end case;
    end if;
  end process;

end table;