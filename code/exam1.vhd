library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity project_4 is
  port (
	 SW        : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	 KEY       : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
	 CLOCK_50  : IN STD_LOGIC;
	 GPIO_0    : OUT STD_LOGIC_VECTOR(33 downto 0);
	 LED       : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
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
	oData         : out std_logic_vector(15 downto 0)
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
  signal reset_btn_deb    : STD_LOGIC;
  signal reset_from_delay : STD_LOGIC;

  signal toggle    : STD_LOGIC;
  signal step      : STD_LOGIC;
  signal reset_n   : STD_LOGIC;
  signal toggle_n  : STD_LOGIC;
  signal step_n    : STD_LOGIC;
  signal data      : STD_LOGIC_VECTOR(15 downto 0);

begin

LED(7 downto 0) <= data(7 downto 0); -- For debuigging without a board
GPIO_0(15 downto 0) <= data(15 downto 0);

logic_reset <= reset_from_delay OR reset_btn_deb;

step_n <= NOT step;
toggle_n <= NOT toggle;
reset_n <= NOT logic_reset;

tl: top_logic
 port map(
	iRst     => reset_n,
	iClk     => CLOCK_50,
	iToggle  => toggle_n,
	iStep    => step_n,
	oData    => data
 );
 
toggle_deb: btn_debounce_toggle
port map (
   BTN_I      => KEY(0),
   BTN_O      => toggle,
   CLK        => CLOCK_50
);

step_deb: btn_debounce_toggle
port map (
   BTN_I      => KEY(1),
   BTN_O      => step,
   CLK        => CLOCK_50
);

reset_deb: btn_debounce_toggle
port map (
   BTN_I      => SW(0),
   BTN_O      => reset_btn_deb,
   CLK        => CLOCK_50
);

rst_del_inst: Reset_Delay
port map (
  iCLK  => CLOCK_50,
  oRESET => reset_from_delay
);

end HardwareLayer;