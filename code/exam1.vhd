library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_4 is
  port (
	 btn       : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
--	 BTN_ext   : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	 clk       : IN STD_LOGIC;
	 ja        : OUT STD_LOGIC_VECTOR(7 downto 0);
	 led0_r    : OUT STD_LOGIC;
	 led1_r    : OUT STD_LOGIC
  );
end project_4;

architecture HardwareLayer of project_4 is

 component top_logic is
 generic(
	N: integer := 10;
	B: integer := 4
 );
 port (
	iRst          : in  std_logic;
	iClk          : in  std_logic;
	iToggle       : in  std_logic;
	iStep         : in  std_logic;
	oData         : out std_logic_vector(15 downto 0);
	oTx           : out std_logic
 );
  end component;
  
  component btn_debounce_toggle is
    port (BTN_I 	 : in  STD_LOGIC;
          CLK 	    : in  STD_LOGIC;
          BTN_O 	 : out STD_LOGIC;
          TOGGLE_O : out STD_LOGIC
			 );
  end component;
  
  component Reset_Delay IS	
    port (
        SIGNAL iCLK  : IN  std_logic;	
        SIGNAL oRESET : OUT std_logic
			);
  end component;
  
  signal logic_reset      : STD_LOGIC;
  signal reset_btn_deb    : STD_LOGIC := '0';
  signal reset_from_delay : STD_LOGIC;

  signal toggle    : STD_LOGIC;
  signal step      : STD_LOGIC;
--  signal reset_n   : STD_LOGIC;
--  signal toggle_n  : STD_LOGIC;
--  signal step_n    : STD_LOGIC;
  signal data      : STD_LOGIC_VECTOR(15 downto 0);
  
  signal tx_signal : STD_LOGIC;

begin

ja(0) <= tx_signal;
ja(1) <= reset_from_delay;
LED0_R <= tx_signal; -- Show TX being sent for quick visual confirmation

led1_r <= toggle;


logic_reset <= reset_from_delay OR reset_btn_deb;

--step_n <= NOT step;
--toggle_n <= NOT toggle;
--reset_n <= NOT logic_reset;

tl: top_logic
 port map(
	iRst     => logic_reset,
	iClk     => CLK,
	iToggle  => toggle,
	iStep    => step,
	oData    => data,
	oTx      => tx_signal
 );
 
toggle_deb: btn_debounce_toggle
port map (
   BTN_I      => BTN(0),
   BTN_O      => toggle,
   CLK        => CLK
);

step_deb: btn_debounce_toggle
port map (
   BTN_I      => BTN(1),
   BTN_O      => step,
   CLK        => CLK
);

rst_del_inst: Reset_Delay
port map (
  iCLK  => CLK,
  oRESET => reset_from_delay
);

end HardwareLayer;