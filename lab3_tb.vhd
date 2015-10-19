-- pragma translate_off
library ieee;
use ieee.std_logic_1164.all;

entity lab3_tb is
end lab3_tb;

architecture test of lab3_tb is

  signal clk : std_logic;
  signal KEY                 :  std_logic_vector(3 downto 0);
  signal SW                  :  std_logic_vector(17 downto 0);
  signal VGA_R, VGA_G, VGA_B :  std_logic_vector(9 downto 0);  -- The outs go to VGA controller
  signal VGA_HS              :  std_logic;
  signal VGA_VS              :  std_logic;
  signal VGA_BLANK           :  std_logic;
  signal VGA_SYNC            :  std_logic;
  signal VGA_CLK             :  std_logic;
  
  
  
  
begin
  DUT: entity work.lab3 port map(clk, KEY, SW, VGA_R, VGA_G, VGA_B, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK);
	
  process begin
    clk <= '0'; wait for 5 ps;
    clk <= '1'; wait for 5 ps;
  end process;

end test;
-- pragma translate_on
