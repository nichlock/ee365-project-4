library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity spi is
    generic(
        N : integer := 8;
        CLK_SPEED_HZ: integer := 125000000;         -- Clock speed used for communicating with the rest of the system
        CLK_SPEED_TRANSMIT_HZ: integer := 250000;    -- Clock speed used for SPI transmission
        CLK_DIV : integer := 500
    );
    
    port(
        iData    : in std_logic_vector(7 downto 0);
        iClk     : in std_logic;
        iRst     : in std_logic;
        iTrigger : in std_logic;
        oReady   : out std_logic;
        oSCK     : out std_logic;
        oSS      : out std_logic;
        oMOSI    : out std_logic
    );
end spi;

architecture Behavioral of spi is

    type t_spi_state is (START, TRANSMIT, DONE);
    
    -- Counter signals
    
    signal sig_counter_clk : integer range 0 to 2*CLK_DIV;
    signal sig_sck_rise : std_logic;
    signal sig_sck_fall : std_logic;
    signal sig_counter_en : std_logic;
    
    signal sig_counter : integer range 0 to N;
    signal sig_counter_status : std_logic;
    
    
    -- State signals   
    signal sig_state_present : t_spi_state;
    signal sig_state_next : t_spi_state;
    signal sig_trigger : std_logic;
    signal sig_data : std_logic_vector(N-1 downto 0);
    
begin

    sig_counter_status <= '0' when(sig_counter > 0) else '1';
    
    -- State machine background process
    sm_bg : process(iClk, iRst)
    begin
        if(iRst = '1') then
            sig_state_present <= START;
        elsif(rising_edge(iClk)) then
            sig_state_present <= sig_state_next;
        end if;
    end process sm_bg;
    
    -- State machine process
    sm : process(sig_state_present, sig_counter_status, sig_trigger, sig_sck_rise, sig_sck_fall)
    begin
        case sig_state_present is
        
            when START
                if (sig_trigger = '1') then
                    sig_state_next <= TRANSMIT;
                else
                    sig_state_next <= START;
            when TRANSMIT
                if ( (sig_sck_rise = '1') and (sig_counter <= 0)) then
                    sig_state_next <= DONE;
                else
                    sig_state_next <= TRANSMIT;
            
             when DONE
                if (sig_sck_fall = '1') then
                    sig_state_next <= START;
                else
                    sig_state_next <= DONE;
                    
            when others -- This should never happen, but VHDL requires this
                if (sig_sck_rise = '1') then
                    sig_state_next <= START;
               
                   
              
    
    
            


end Behavioral;
