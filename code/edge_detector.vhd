 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity edge_detector is
    generic(
	   high_edges: STD_LOGIC := '1'; -- Zero: detects low edges
	   clock_sample_edge: STD_LOGIC := '1' -- Edge of iClk to sample on
	 );
    port (
      iInput     : in STD_LOGIC := '0';
      iEn        : in STD_LOGIC := '0';
      iClk       : in STD_LOGIC := '0';
	   oPulse     : out STD_LOGIC := '0'
    );
end edge_detector;

architecture detector of edge_detector is

signal reg0_d : STD_LOGIC := '0';
signal reg0_q : STD_LOGIC := '0';
signal reg1_d : STD_LOGIC := '0';
signal reg1_q : STD_LOGIC := '0';
signal reg2_d : STD_LOGIC := '0';
signal reg2_q : STD_LOGIC := '0';

begin
  reg1_d <= reg0_q;

  process(reg1_q, reg0_q)
  begin
  if (high_edges = '0') then
    reg2_d <= (reg1_q AND NOT reg0_q);
  else
    reg2_d <= ((NOT reg1_q) AND reg0_q);
  end if;
  end process;

  process(iEn, iInput, reg2_q)
  begin
  if (iEn = '1') then
    reg0_d <= iInput;
    oPulse <= reg2_q;
  else
    reg0_d <= '0';
    oPulse <= '0';
  end if;
  end process;

  process (iClk)
  begin
    if (iClk'EVENT AND iClk = clock_sample_edge) then
      reg0_q <= reg0_d;
      reg1_q <= reg1_d;
      reg2_q <= reg2_d;
	 end if;
	 
  end process;

end detector;
