library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic);
end lab3;

architecture rtl of lab3 is

 --Component from the Verilog file: vga_adapter.v

  component vga_adapter
    generic(RESOLUTION : string);
    port (resetn                                       : in  std_logic;
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  end component;

  signal x      : unsigned(7 downto 0) := "00000000";
  signal y      : unsigned(6 downto 0) := "0000000";
  signal colour : std_logic_vector(2 downto 0);
  signal plot   : std_logic;
  
  signal INITY : std_logic := '0';
  signal INITX : std_logic := '0';
  signal XDONE : std_logic := '0';
  signal YDONE : std_logic := '0';
  signal LOADY : std_logic := '0';
  signal LOADX : std_logic := '0';
  
  signal STATE : std_logic_vector(3 downto 0) := "0001";
  signal NEXTSTATE : std_logic_vector(3 downto 0):= "0001";

begin


	  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour,
             x         => std_logic_vector(x),
             y         => std_logic_vector(y),
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);

 
    process(CLOCK_50)
      begin
        if(rising_edge(CLOCK_50)) then
            STATE <= NEXTSTATE;
        end if;
      
    end process;
 
		
		process(all)
		begin
			case STATE is
				when "0001" => INITX <= '1';
					             INITY <= '1';
					             LOADY <= '1';
					             plot <= '0';
					             NEXTSTATE <= "0100";				
				
				when "0010" => INITX <= '1';
					             INITY <= '0';
					             LOADY <= '1';
					             plot <= '0';
				              	NEXTSTATE <= "0100";
					
				when "0100" => INITX <= '0';
					             INITY <= '0';
					             LOADY <='0';
					             plot <= '1';
					             if(YDONE = '0') then
						             if(XDONE = '0') then
							             NEXTSTATE <= "0100";
						             else
							             NEXTSTATE <= "0010";
						            end if;
					             else 
						            NEXTSTATE  <= "1000";
					             end if;
					
				when "1000" => plot <= '0';
					             NEXTSTATE <= "1000";
					             INITX <= '0';
					             INITY <= '0';
					             LOADY <= '0';
					
				when others => INITX <= '0';
					             INITY <= '0';
					             LOADY <= '0';
					             plot <= '0';
					             NEXTSTATE <= "0001";
				
			end case;		
		end process;
		
		--END STATE MACHINE
		
		process(CLOCK_50)
			variable xi : unsigned(7 downto 0);
			variable yi : unsigned(6 downto 0);
			begin
			if(rising_edge(CLOCK_50)) then
				if(INITY = '1') then
					yi := "0000000";
				elsif(LOADY = '1') then
					yi := yi + 1;
				end if;
			
				if(INITX = '1') then
					xi := "00000000";
				else
					xi := xi + 1;
				end if;
				
				XDONE <= '0';
				YDONE <= '0';
				
				if(xi = 159) then
					XDONE <= '1';
				end if;
				
				if(yi = 120) then
					YDONE <= '1';				
				end if;
			
			end if;
			
			x <= xi;
			y <= yi;
			
			colour <= std_logic_vector(xi(2 downto 0));
		end process;
		
		
		
	


end RTL;


