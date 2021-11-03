library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ttl_serial is
   generic(BAUD_BPS: integer := 9600;
           CLK_SPEED_HZ: integer := 125000000);
   port(
      iData		: in  std_logic_vector(7 downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
      iTrigger  : in  std_logic;
      oReady    : out std_logic := '0';
	  oTx 		: out std_logic := '1'
      );
end ttl_serial;

architecture Behavioral of ttl_serial is

signal bit_num      : unsigned (4 downto 0) := b"00000";
signal timer        : unsigned (15 downto 0) := x"0000";

begin

    process(iClk)
    begin
        if(iClk'EVENT and iClk = '1') then
            if(iRst = '1') then
                oTx <= '1';
                timer <= x"0000";
                bit_num <= b"00000";
                oReady <= '0';
            else
                if(timer > 0) then -- Needs timer to be started first by setting it to 1
                    timer <= timer + 1;
                    oReady <= '0';
                else 
                    oTx <= '1';
                    oReady <= '1';
                end if;
                
                -- Triggered to start outputting iData
                if(iTrigger = '1') then
                    oTx <= '1';
                    oReady <= '0';
                    timer <= x"0001"; -- Kick things off by starting the timer
                end if;
                
                -- Time for a new data output
                if(timer >= (CLK_SPEED_HZ / BAUD_BPS)) then
                    case bit_num is 
                        when b"00000" => oTx <= '0'; -- Start bit
                        when b"00001" => oTx <= iData(7);
                        when b"00010" => oTx <= iData(6);
                        when b"00011" => oTx <= iData(5);
                        when b"00100" => oTx <= iData(4);
                        when b"00101" => oTx <= iData(3);
                        when b"00110" => oTx <= iData(2);
                        when b"00111" => oTx <= iData(1);
                        when b"01000" => oTx <= iData(0);
                        when others => oTx <= '1'; -- Stop condition
                    end case;
                    
                    if(bit_num = x"9") then
                        -- Stop condition is written now, so we can stop the timer
                        timer <= x"0000";
                        bit_num <= b"00000";
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
