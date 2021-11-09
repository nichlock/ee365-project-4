library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity spi is
   generic(SCK_SPEED_HZ: integer := 250000;
           CLK_SPEED_HZ: integer := 125000000);
   port(
      iData		: in  std_logic_vector(7 downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
      iTrigger  : in  std_logic;
      oReady    : out std_logic := '0';
	  oMosi     : out std_logic;
	  oSs_n     : out std_logic;
	  oSck      : out std_logic
      );
end spi;

architecture Behavioral of spi is

signal bit_num      : integer range 0 to 17 := 0;
signal timer        : unsigned (15 downto 0) := x"0000";

begin

    process(iClk)
    begin
        if(iClk'EVENT and iClk = '1') then
            if(iRst = '1') then
                oMosi <= '1';
                oSck <= '0';
                oSs_n <= '1';
                timer <= x"0000";
                bit_num <= 0;
                oReady <= '0';
            else
                if(NOT(timer = 0)) then -- Needs timer to be started first by setting it to 1
                    timer <= timer + 1;
                    oReady <= '0';
                    oSs_n <= '0';
                else 
                    oMosi <= '1';
                    oSck <= '0';
                    oReady <= '1';
                    oSs_n <= '1';
                end if;
                
                -- Triggered to start outputting iData
                if(iTrigger = '1') then
                    oMosi <= '1';
                    oSck <= '0';
                    oReady <= '0';
                    timer <= x"0001"; -- Kick things off by starting the timer
                end if;
                
                -- Time for a new data output
                if(timer = ((CLK_SPEED_HZ / SCK_SPEED_HZ))) then
                    case bit_num is 
                        when 0  => oMosi <= iData(7);
                        when 1  => oSck <= '1';
                        when 2  => oMosi <= iData(6); oSck <= '0';
                        when 3  => oSck <= '1';
                        when 4  => oMosi <= iData(5); oSck <= '0';
                        when 5  => oSck <= '1';
                        when 6  => oMosi <= iData(4); oSck <= '0';
                        when 7  => oSck <= '1';
                        when 8  => oMosi <= iData(3); oSck <= '0';
                        when 9  => oSck <= '1';
                        when 10 => oMosi <= iData(2); oSck <= '0';
                        when 11 => oSck <= '1';
                        when 12 => oMosi <= iData(1); oSck <= '0';
                        when 13 => oSck <= '1';
                        when 14 => oMosi <= iData(0); oSck <= '0';
                        when 15 => oSck <= '1';
                        when others => oMosi <= '1'; -- Stop condition
                    end case;
                    
                    if(bit_num = 16) then
                        -- Stop condition is written now, so we can stop the timer
                        timer <= x"0000";
                        bit_num <= 0;
                        oReady <= '1';
                    else
                        timer <= x"0001"; -- Wait for next bit
                        bit_num <= bit_num  + 1; -- Keep it moving
                    end if;
                    
                end if;
            end if;
        end if;
    end process;

end Behavioral;
