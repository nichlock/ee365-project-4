library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_4 is
  port (
	 btn       : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
  -- BTN_ext   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	 clk       : IN STD_LOGIC;
	 --system_en : IN STD_LOGIC;
	 ja        : OUT STD_LOGIC_VECTOR(7 downto 0);
	 jb        : OUT STD_LOGIC_VECTOR(7 downto 0);
	 led0_r    : OUT STD_LOGIC;
	 led1_r    : OUT STD_LOGIC
  );
end project_4;

architecture HardwareLayer of project_4 is

 component top_logic is
 generic(
	N: integer := 10;
	B: integer := 4;
	CLK_SPEED_HZ: integer := 125000000 / 4
 );
 port (
	iRst          : in  std_logic;
	iClk          : in  std_logic;
	iToggle       : in  std_logic;
	iStep         : in  std_logic;
	oData         : out std_logic_vector(15 downto 0);
	oTx           : out std_logic;
	oSCK          : out std_logic;
    oSS           : out std_logic;
    oMOSI         : out std_logic
 );
  end component;
  
 component clock_div is
    generic (DIV_RATIO : integer := 4);
    port(
      iClk     : in  std_logic;
      iRst     : in  std_logic;
      oDiv2    : out std_logic;
      oDiv4    : out std_logic;
      oDiv8    : out std_logic;
      oDiv16   : out std_logic);
  end component;
  
  component btn_debounce_toggle is
    port (BTN_I 	 : in  STD_LOGIC;
          CLK 	    : in  STD_LOGIC;
          BTN_O 	 : out STD_LOGIC;
          TOGGLE_O : out STD_LOGIC
			 );
  end component;
  
  component Reset_Delay IS
    GENERIC (DELAY_LENGTH : unsigned(19 DOWNTO 0) := X"FFFFF");
    port (
        SIGNAL iCLK  : IN  std_logic;	
        SIGNAL oRESET : OUT std_logic
			);
  end component;
  
  signal logic_reset      : STD_LOGIC;
  signal reset_btn_deb    : STD_LOGIC := '0';
  signal reset_from_delay : STD_LOGIC;
  
  signal clk_divided    : STD_LOGIC;

  signal toggle    : STD_LOGIC;
  signal step      : STD_LOGIC;
--  signal reset_n   : STD_LOGIC;
--  signal toggle_n  : STD_LOGIC;
--  signal step_n    : STD_LOGIC;
  signal data      : STD_LOGIC_VECTOR(15 downto 0);
  
  signal tx_signal : STD_LOGIC;
  
  signal clk_div_reset : STD_LOGIC;

begin

ja(0) <= tx_signal;
ja(1) <= reset_from_delay;
ja(2) <= clk_div_reset;
ja(3) <= data(0);
LED0_R <= tx_signal; -- Show TX being sent for quick visual confirmation

led1_r <= toggle;


logic_reset <= reset_from_delay OR reset_btn_deb;

--step_n <= NOT step;
--toggle_n <= NOT toggle;
--reset_n <= NOT logic_reset;

tl: top_logic
 port map(
	iRst     => logic_reset,
	iClk     => clk_divided,
	iToggle  => toggle,
	iStep    => step,
	oData    => data,
	oTx      => tx_signal,
	oSCK     => jb(3),
	oSS      => jb(2),
	oMOSI    => jb(1)
 );
 
toggle_deb: btn_debounce_toggle
port map (
   BTN_I      => BTN(0),
   BTN_O      => toggle,
   CLK        => clk_divided
);

step_deb: btn_debounce_toggle
port map (
   BTN_I      => BTN(1),
   BTN_O      => step,
   CLK        => clk_divided
);

rst_del_inst: Reset_Delay
port map (
  iCLK  => clk_divided,
  oRESET => reset_from_delay
);

clk_div_rst_del: Reset_Delay
generic map(DELAY_LENGTH => x"FFFFF")
port map (
  iCLK  => CLK,
  oRESET => clk_div_reset
);

clk_div_inst: clock_div
port map (
  iCLK  => CLK,
  iRst => clk_div_reset, -- Only resets from the initial delay
  oDiv4 => clk_divided
);

end HardwareLayer;