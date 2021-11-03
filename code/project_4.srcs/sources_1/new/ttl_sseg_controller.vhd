library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity ttl_sseg_controller is
   generic(BAUD: integer := 9600;
	       B: integer := 15; 
           CLK_SPEED_HZ: integer := 125000000);
   port(
      iData		: in  std_logic_vector(B downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
	  oTx 		: out std_logic := '1';
      serialData		: out std_logic_vector(7 downto 0);
      serialTrigger		: out std_logic;
      serialReady       : in std_logic
      );
end ttl_sseg_controller;

architecture Behavioral of ttl_sseg_controller is
  
  -- For TTL Serial output
  signal ttl_data    :std_logic_vector(7 downto 0) := x"00";
  signal ttl_trigger :std_logic := '0';
  signal ttl_ready   :std_logic;
  
  -- For state machine controls
  signal data_to_output : std_logic_vector(B downto 0);
  signal byte_sel       : integer range 0 to 9 := 0;
  

begin

  serialData <= ttl_data;
  serialTrigger <= ttl_trigger;
  ttl_ready <= serialReady;
  
process(iClk)
begin
    if(iClk'EVENT and iClk = '1') then
        if(iRst = '1') then
            byte_sel <= 0;
            ttl_data <= x"00";
            data_to_output <= iData;
        else
            if(ttl_ready = '1' and ttl_trigger = '0') then -- Send more data the moment it's available
                case byte_sel is
                    when 0 => ttl_data <= x"76";
                    when 1 => ttl_data <= x"7A";
                    when 2 => ttl_data <= x"FF";
                    when 3 => ttl_data <= x"77";
                    when 4 => ttl_data <= x"00";
                    when 5 => ttl_data <= x"0"&data_to_output(15 downto 12);
                    when 6 => ttl_data <= x"0"&data_to_output(11 downto 8);
                    when 7 => ttl_data <= x"0"&data_to_output(7  downto 4);
                    when 8 => ttl_data <= x"0"&data_to_output(3  downto 0);
                    when others => data_to_output <= iData;
                end case;
                
                if(NOT(byte_sel = 9)) then
                    ttl_trigger <= '1';
                    byte_sel <= byte_sel + 1;
                elsif(NOT(data_to_output = iData)) then
                    byte_sel <= 5;
                end if;
            else 
                ttl_trigger <= '0';
            end if;
        end if;
    end if;
end process;

end Behavioral;
