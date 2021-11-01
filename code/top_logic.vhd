library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_logic is
    generic(
      N: integer := 10;
      B: integer := 4;
      BAUD: integer := 9600;
      CLK_SPEED_HZ: integer := 125000000
	 );
    port (
      iRst          : in  std_logic := '1'; 
      iClk          : in  std_logic;
      iToggle       : in  std_logic; 
      iStep         : in  std_logic;
      oData         : out std_logic_vector(15 downto 0);
      oTx           : out std_logic
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
		en         : in std_logic := '1';
		up         : in std_logic;
		clk_en     : in std_logic;
		d          : in std_logic_vector(B-1 downto 0) := (others => '0');
		max_tick   : out std_logic;
		min_tick   : out std_logic;
		q          : out std_logic_vector(B-1 downto 0)
	 );
  end component;
  
 component ttl_sseg_controller is
	 generic(
	   BAUD: integer := BAUD; 
	   CLK_SPEED_HZ: integer := CLK_SPEED_HZ
     );
	 port(
      iData		: in  std_logic_vector(15 downto 0);
      iClk		: in  std_logic;
      iRst      : in  std_logic;
	  oTx 		: out std_logic
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
  signal toggle_pulse         :std_logic := '0';
  signal step_pulse           :std_logic := '0';
  signal ctr_up               :std_logic := '1';
  signal ctr_count_this_cycle :std_logic := '0';
  signal ctr_reached_max      :std_logic := '0';
  signal ctr_reached_min      :std_logic := '0';
  
  -- Internal logic to avoid surpassing maximum entries
  signal reached_n            :std_logic := '0';
  signal counter_value        :STD_LOGIC_VECTOR(B-1 downto 0) := x"0";
  
  -- For pulse generation enable line
  signal rst_n                :std_logic := '0';
  
  signal lut_result :std_logic_vector(15 downto 0);


begin

  rst_n <= NOT iRst;
  
  process(toggle_pulse)
  begin
    if (toggle_pulse = '1') then
	   ctr_up <= NOT ctr_up;
	 end if;
  end process;
	
  -- Cancels the step pulse out if over/underflow is imminent
  ctr_count_this_cycle <= step_pulse AND NOT ((ctr_reached_min AND NOT ctr_up) OR ((reached_n OR ctr_reached_max) AND ctr_up));
  
  reached_n <= '1' when unsigned(counter_value) = to_unsigned(N-1, 4) else '0';
  
  oData <= lut_result;

  counter: univ_bin_counter 
    port map (
		clk        => iClk,
		reset      => iRst,
		syn_clr    => iRst,
		load       => iRst,
		--en         => , -- Always enabled
		up         => ctr_up,
		clk_en     => ctr_count_this_cycle,
		max_tick   => ctr_reached_max,
		min_tick   => ctr_reached_min,
		q          => counter_value
    );
 
  data_output: ttl_sseg_controller
    port map (
        iData     => lut_result,
        iClk      => iClk,
        iRst      => iRst,
        oTx 	  => oTx
    );
	 
 lut: look_up_table
	 port map (
      iRst        => iRst,
      iCnt        => counter_value,
      iClk        => iClk,
	   oData      => lut_result
	 );
	 
 step_edd: edge_detector
    generic map (
	   high_edges => '0'
	 )
    port map (
      iInput => iStep,
      iEn    => rst_n,
      iClk   => iClk,
	   oPulse => step_pulse
    );
	 
 toggle_edd: edge_detector
    generic map (
	   high_edges => '0'
	 )
    port map (
      iInput => iToggle,
      iEn    => rst_n,
      iClk   => iClk,
	   oPulse => toggle_pulse
    );

end Structural;