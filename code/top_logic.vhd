library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_logic is
    generic(
      N: integer := 10;
      B: integer := 4;
      BAUD: integer := 9600;
      SCK_SPEED: integer := 25000;
      COUNT_FREQ_HZ: integer := 1;
      CLK_SPEED_HZ: integer := 125000000
	 );
    port (
      iRst          : in  std_logic := '1'; 
      iClk          : in  std_logic;
      iToggle       : in  std_logic; 
      iStep         : in  std_logic;
      iEn           : in  std_logic;
      oData         : out std_logic_vector(15 downto 0);
      oTx           : out std_logic;
      oSCK          : out std_logic;
      oSS           : out std_logic;
      oMOSI         : out std_logic
    );
end top_logic;


architecture Structural of top_logic is

    component univ_bin_counter is
     generic(N: integer := B);
     port(
        clk        : in std_logic;
        reset      : in std_logic;
        syn_clr    : in std_logic;
        load       : in std_logic;
        en         : in std_logic;
        up         : in std_logic;
        clk_en     : in std_logic;
        d          : in std_logic_vector(B-1 downto 0) := (others => '0');
        max_tick   : out std_logic;
        min_tick   : out std_logic;
        q          : out std_logic_vector(B-1 downto 0)
     );
    end component;
    
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
    
   component spi is
   generic(SCK_SPEED_HZ: integer := SCK_SPEED;
           CLK_SPEED_HZ: integer := CLK_SPEED_HZ);
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
    end component;
    
    
    component serial_controller is
    generic(BAUD: integer := 9600;
           B: integer := 15; 
           CLK_SPEED_HZ: integer := CLK_SPEED_HZ);
    port(
      iData		: in  std_logic_vector(B downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
      oTx 		: out std_logic := '1';
      serialData		: out std_logic_vector(7 downto 0);
      serialTrigger		: out std_logic;
      serialReady       : in  std_logic
      );
    end component;
    
    
   component periodic_pulse is
   generic(FREQ_HZ: integer := 1;
           CLK_SPEED_HZ: integer := CLK_SPEED_HZ);
   port(
      iClk		: in  std_logic;
      iRst      : in  std_logic;
	  oPulse    : out std_logic
      );
    end component;
    
    component look_up_table is
     generic(N: integer := N; B: integer := B);
     port(
      iRst       : in STD_LOGIC;
      iCnt       : in STD_LOGIC_VECTOR(B-1 downto 0); 
      iClk       : in STD_LOGIC;
      oData      : out STD_LOGIC_VECTOR(15 downto 0)
     );
    end component;
    
    component edge_detector is
    generic(
       high_edges: STD_LOGIC := '1'
     );
    port (
      iInput     : in STD_LOGIC;
      iEn        : in STD_LOGIC;
      iClk       : in STD_LOGIC;
       oPulse     : out STD_LOGIC
    );
    end component;
    
    -- Counter logic signals
--    signal toggle_pulse         :std_logic := '0';
    signal step_pulse           :std_logic := '0';
--    signal ctr_up               :std_logic := '1';
    signal ctr_count_this_cycle :std_logic := '0';
    signal ctr_reached_max      :std_logic := '0';
    signal ctr_reached_min      :std_logic := '0';
    
    -- Internal logic to avoid surpassing maximum entries
    signal reached_n            :std_logic := '0';
    signal counter_value        :STD_LOGIC_VECTOR(B-1 downto 0) := x"0";
    
    -- For pulse generation enable line
    signal rst_n                :std_logic := '0';
    
    signal lut_result :std_logic_vector(15 downto 0);
    
    
    -- For seven segment serial output
    signal ttl_serial_ctrl_data    :std_logic_vector(7 downto 0) := x"00";
    signal ttl_serial_ctrl_trigger :std_logic := '0';
    signal ttl_serial_ctrl_ready   :std_logic;
    signal spi_serial_ctrl_data    :std_logic_vector(7 downto 0) := x"00";
    signal spi_serial_ctrl_trigger :std_logic := '0';
    signal spi_serial_ctrl_ready   : std_logic;


begin

    rst_n <= NOT iRst;
    
    -- Cancels the step pulse out if over/underflow is imminent
    ctr_count_this_cycle <= step_pulse AND NOT ((ctr_reached_min AND NOT iToggle) OR ((reached_n OR ctr_reached_max) AND iToggle));
    
    reached_n <= '1' when unsigned(counter_value) = to_unsigned(N-1, 4) else '0';
    
    oData <= lut_result;
    
    counter: univ_bin_counter 
    port map (
        clk        => iClk,
        reset      => iRst,
        syn_clr    => iRst,
        load       => iRst,
        en         => iEn,
        up         => iToggle,
        clk_en     => ctr_count_this_cycle,
        max_tick   => ctr_reached_max,
        min_tick   => ctr_reached_min,
        q          => counter_value
    );
 
    ttl_data_output: serial_controller
    port map (
        iData     => lut_result,
        iClk      => iClk,
        iRst      => iRst,
        oTx 	  => oTx,
        serialData     => ttl_serial_ctrl_data,
        serialTrigger  => ttl_serial_ctrl_trigger,
        serialReady    => ttl_serial_ctrl_ready
    );
    
    ttl_output: ttl_serial 
    port map (
        iClk      => iClk,
        iRst      => iRst,
        iData		=> ttl_serial_ctrl_data,
        iTrigger  => ttl_serial_ctrl_trigger,
        oReady    => ttl_serial_ctrl_ready,
        oTx 		=> oTx
    );
	 
	 
	spi_data_output: serial_controller
	port map(
	   iData   => lut_result,
	   iClk    => iClk,
	   iRst    => iRst,
	   oTx     => oTx,
	   serialData => spi_serial_ctrl_data,
	   serialTrigger => spi_serial_ctrl_trigger,
	   serialReady => spi_serial_ctrl_ready
	);
	
    spi_output: spi
    port map (
        iClk => iClk,
        iRst => iRst,
        iData => spi_serial_ctrl_data,
        iTrigger => spi_serial_ctrl_trigger,
        oReady => spi_serial_ctrl_ready,
        oSck => oSCK,
        oSs_n => oSS,
        oMosi => oMOSI
    );
	 
     lut: look_up_table
     port map (
      iRst        => iRst,
      iCnt        => counter_value,
      iClk        => iClk,
      oData       => lut_result
     );
        
     counter_pulse: periodic_pulse
     port map(
        iClk   => iClk,
        iRst   => iRst,
        oPulse => step_pulse
        );

end Structural;
