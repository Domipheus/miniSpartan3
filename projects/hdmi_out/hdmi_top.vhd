----------------------------------------------------------------------------------
-- Company: Domipheus Labs
-- Engineer: Colin Riley
-- 
-- Create Date:    22:34:21 05/11/2016 
-- Design Name: HDMI out test on Spartan3
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

Library UNISIM;
use UNISIM.vcomponents.all;

 
entity hdmi_top is
    Port ( I_clk : in  STD_LOGIC;
           O_leds : out  STD_LOGIC_VECTOR (2 downto 0);
			  O_hdmi_p : out STD_LOGIC_VECTOR (3 downto 0);
			  O_hdmi_n : out STD_LOGIC_VECTOR (3 downto 0);
			  I_switches : in STD_LOGIC_VECTOR (1 downto 0));
end hdmi_top;

architecture Behavioral of hdmi_top is
	COMPONENT clocking
   PORT ( 
	        I_unbuff_clk32 : in  STD_LOGIC;
           O_buff_clkpixel : out  STD_LOGIC;
           O_buff_clk5xpixel : out  STD_LOGIC;
           O_buff_clk5xpixelinv : out  STD_LOGIC;
           O_buff_clk32 : out STD_LOGIC
			  );
	END COMPONENT;

	COMPONENT dvid
   PORT(
      clk      : IN std_logic;
      clk_n    : IN std_logic;
      clk_pixel: IN std_logic;
      red_p   : IN std_logic_vector(7 downto 0);
      green_p : IN std_logic_vector(7 downto 0);
      blue_p  : IN std_logic_vector(7 downto 0);
      blank   : IN std_logic;
      hsync   : IN std_logic;
      vsync   : IN std_logic;          
      red_s   : OUT std_logic;
      green_s : OUT std_logic;
      blue_s  : OUT std_logic;
      clock_s : OUT std_logic
      );
   END COMPONENT;
	
   COMPONENT vga_gen
   PORT(    
		pixel_clock     : in std_logic; 

		pixel_h 			 : out STD_LOGIC_VECTOR(11 downto 0);
		pixel_v 			 : out STD_LOGIC_VECTOR(11 downto 0);

		pixel_h_pref : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		pixel_v_pref : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
		blank_pref : OUT std_logic;

		blank           : OUT std_logic;
		hsync           : OUT std_logic;
		vsync           : OUT std_logic
      );
   END COMPONENT;

	signal clk_pixel : std_logic;
	signal clk_5xpixel : std_logic;	
	signal clk_5xpixel_inv : std_logic;
	signal clk_32 : std_logic;
	
	signal red_p   : std_logic_vector(7 downto 0) := X"FF";
   signal green_p : std_logic_vector(7 downto 0) := X"00";
   signal blue_p  : std_logic_vector(7 downto 0) := X"00";
   signal blank   : std_logic;
   signal hsync   : std_logic;
   signal vsync   : std_logic;   
	
   signal red_s   : std_logic;
   signal green_s : std_logic;
   signal blue_s  : std_logic;
   signal clock_s : std_logic;
	
	signal pixel_h : STD_LOGIC_VECTOR(11 downto 0);
	signal pixel_v : STD_LOGIC_VECTOR(11 downto 0);
	
begin

	-- clock engine, generating pixel clocks and dvid 5x clocks 
	clock_engine: clocking port map (
		    I_unbuff_clk32 => I_clk,
          O_buff_clkpixel => clk_pixel,
          O_buff_clk5xpixel => clk_5xpixel,
          O_buff_clk5xpixelinv => clk_5xpixel_inv,
			 O_buff_clk32 => clk_32
			 );

   -- depending on the state of the switches, set the colours for the pixel given pixel h/v values.
	red_p   <= ((pixel_h(6 downto 1) or pixel_v(6 downto 1) ) & "00") when  I_switches = "11" else
	            X"FF" when I_switches = "00" else X"00";
	green_p <= pixel_h(8 downto 1) when  I_switches = "11" else
	            X"FF" when I_switches = "01" else X"00";
	blue_p  <= pixel_v(8 downto 1) when  I_switches = "11" else
	            X"FF" when I_switches = "10" else X"00";
			 
	-- this generates the dvi tmds signalling, depening on the inputs for pixels
	-- and sync/blank controls. Input signal needs to be well formed.
	-- clk and clk_n should be 5x pixel, with clkn at 180 degrees phase
	dvid_1: dvid PORT MAP(
      clk       => clk_5xpixel,
      clk_n     => clk_5xpixel_inv, 
      clk_pixel  => clk_pixel,
		
      red_p      => red_p,
      green_p    => green_p,
      blue_p     => blue_p,
		
      blank      => blank,
      hsync      => hsync,
      vsync      => vsync,
		
      -- outputs to TMDS drivers
      red_s      => red_s,
      green_s    => green_s,
      blue_s     => blue_s,
      clock_s    => clock_s
   );

	-- This generates controls and offsets required for a fixed resolution
	Inst_vga_gen: vga_gen PORT MAP( 
      pixel_clock => clk_pixel,    
 
		pixel_h	=> pixel_h,
		pixel_v	=> pixel_v,
		
		pixel_h_pref 	=> open,
		pixel_v_pref 	=> open,     
		blank_pref    => open,
		
      blank    => blank,
      hsync    => hsync,
      vsync    => vsync
   );

	
   -- output drivers
	OBUFDS_blue  : OBUFDS port map ( O  => O_hdmi_p(0), OB => O_hdmi_n(0), I  => blue_s );
	OBUFDS_green   : OBUFDS port map ( O  => O_hdmi_p(1), OB => O_hdmi_n(1), I  => green_s );
	OBUFDS_red : OBUFDS port map ( O  => O_hdmi_p(2), OB => O_hdmi_n(2), I  => red_s );
	OBUFDS_clock : OBUFDS port map ( O  => O_hdmi_p(3), OB => O_hdmi_n(3), I  => clock_s );


   -- status leds: signifying RGB of output - 111 is test pattern
   O_leds <= "111" when I_switches = "11" else
	          "100" when I_switches = "00" else
	          "010" when I_switches = "01" else
	          "001";

end Behavioral;

