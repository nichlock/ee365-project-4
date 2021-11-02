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
	  oTx 		: out std_logic := '1'
      );
end ttl_sseg_controller;

architecture Behavioral of ttl_sseg_controller is

type CounterDisplayState_t is (RESET, INIT, SEND_DATA);

 component ttl_serial is
	 generic(
	   BAUD_BPS: integer := BAUD; 
	   CLK_SPEED_HZ: integer := CLK_SPEED_HZ
     );
	 port(
      iData		: in  std_logic_vector(7 downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
      iTrigger  : in  std_logic;
      oReady    : out std_logic;
	  oTx 		: out std_logic
	 );
  end component;
  
  
  -- For TTL Serial output
  signal ttl_data    :std_logic_vector(7 downto 0) := x"00";
  signal ttl_trigger :std_logic := '0';
  signal ttl_ready   :std_logic;
  
  -- For state machine controls
  signal data_to_output : std_logic_vector(B downto 0);
  signal new_data_ready : std_logic := '0';
  signal state          : CounterDisplayState_t;
  signal byte_sel       : integer := 0;
  
  signal iData_q        : std_logic_vector(B downto 0);
  
  
  attribute mark_debug : string; 
  attribute mark_debug of state : signal is "true";

begin
    
    process(iClk)
    begin
    if(iClk = '1') then
        if(NOT(iData = iData_q)) then
            new_data_ready <= '1';
            iData_q <= iData;
        end if;
        
        if(iRst = '1') then
            state <= RESET;
        end if;
        
        if(state = RESET) then
            ttl_trigger <= '0';
            data_to_output <= x"0000";
            new_data_ready <= '0';
            if(iRst = '0') then
                state <= INIT;
            end if;
        elsif (state = INIT) then
            if(ttl_ready = '1' and ttl_trigger = '0') then
                case byte_sel is
                    when 0 => ttl_data <= x"76";
                    when 1 => ttl_data <= x"7A";
                    when 2 => ttl_data <= x"FF";
                    when 3 => ttl_data <= x"77";
                    when others => ttl_data <= x"00";
                end case;
                ttl_trigger <= '1';

                if(byte_sel = 4 and iRst = '0') then
                    byte_sel <= 0;
                    data_to_output <= iData;
                    state <= SEND_DATA;
                else
                    byte_sel <= byte_sel + 1;
                end if;
            else
                ttl_trigger <= '0';
                -- Wait for ttl to ready
            end if;
        
        elsif (state = SEND_DATA) then
            if(ttl_ready = '1' and ttl_trigger = '0') then
                case byte_sel is
                    when 0 => ttl_data <= x"0"&data_to_output(15 downto 12);
                    when 1 => ttl_data <= x"0"&data_to_output(11 downto 8);
                    when 2 => ttl_data <= x"0"&data_to_output(7  downto 4);
                    when 3 => ttl_data <= x"0"&data_to_output(3  downto 0);
                    when others => data_to_output <= iData; -- While waiting, refresh the input
                end case;

                if(byte_sel < 4) then -- Stop counting after 4 to avoid overflow
                    ttl_trigger <= '1';
                    byte_sel <= byte_sel + 1;
                elsif (new_data_ready = '1') then
                    -- All data has been sent, and updated data is available
                    byte_sel <= 0;
                    new_data_ready <= '0';
                end if;
            else
                ttl_trigger <= '0';
                -- Wait for ttl to ready
            end if;
            
        end if;
    end if;
    end process;

ttl_output: ttl_serial 
    port map (
      iClk      => iClk,
      iRst      => iRst,
      iData		=> ttl_data,
      iTrigger  => ttl_trigger,
      oReady    => ttl_ready,
      oTx 		=> oTx
    );
    
end Behavioral;
