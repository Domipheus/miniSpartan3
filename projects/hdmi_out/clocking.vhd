----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:25:40 04/27/2016 
-- Design Name: 
-- Module Name:    clocking - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VComponents.all;


entity clocking is
    Port ( I_unbuff_clk32 : in  STD_LOGIC; 
           O_buff_clkpixel : out  STD_LOGIC;
           O_buff_clk5xpixel : out  STD_LOGIC;
           O_buff_clk5xpixelinv : out  STD_LOGIC; 
           O_buff_clk32 : out STD_LOGIC
			  );
end clocking;

architecture Behavioral of clocking is
   signal clock_core            : std_logic;
   signal clock_core_unbuffered : std_logic;
   signal clock_pixel            : std_logic;
   signal clock_pixel_unbuffered : std_logic;
   signal clock_x5pixel            : std_logic;
   signal clock_x5pixel_unbuffered : std_logic;
   signal clock_x5pixelinv            : std_logic;
   signal clock_x5pixelinv_unbuffered : std_logic;
	signal clock_fmem : std_logic;
	signal clock_fmem_unbuffered : std_logic;
   signal clk32_buffered : std_logic;
	
	signal   CLK0    : std_logic; -- => CLK0,     -- 0 degree DCM CLK ouptput
	signal   CLK180  : std_logic; -- => CLK180, -- 180 degree DCM CLK output
	signal   CLK270 : std_logic; --  => CLK270, -- 270 degree DCM CLK output
	signal   CLKFX  : std_logic; -- => CLKFX,   -- DCM CLK synthesis out (M/D)
	signal   CLKFX180  : std_logic; -- => CLKFX180, -- 180 degree CLK synthesis out
	signal   LOCKED  : std_logic; -- => LOCKED, -- DCM LOCK status output
	signal   PSDONE : std_logic; --  => PSDONE, -- Dynamic phase adjust done output
	signal   STATUS  : std_logic; -- => STATUS, -- 8-bit DCM status bits output
	signal   CLKFB  : std_logic; -- => CLKFB,   -- DCM clock feedback

	signal   CLK02    : std_logic; -- => CLK0,     -- 0 degree DCM CLK ouptput
   signal   LOCKED2  : std_logic; -- => LOCKED, -- DCM LOCK status output
   signal   PSDONE2 : std_logic; --  => PSDONE, -- Dynamic phase adjust done output
   signal   CLKFB2  : std_logic; -- => CLKFB,   -- DCM clock feedback
	
begin
	
	-- 32MHz -> ~25MHz
   DCM_SP_inst : DCM_SP
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 19,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 15, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 32.0, --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of "NONE", "FIXED" or "VARIABLE" 
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of "NONE", "1X" or "2X" 
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
                                             --     an integer from 0 to 15
      DLL_FREQUENCY_MODE => "LOW",     -- "HIGH" or "LOW" frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
   port map (
      CLK0 => CLK0,     -- 0 degree DCM CLK ouptput
      CLK180 => CLK180, -- 180 degree DCM CLK output
      CLK270 => CLK270, -- 270 degree DCM CLK output
      CLK2X => open,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => clock_pixel_unbuffered,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => CLKFX180, -- 180 degree CLK synthesis out
      LOCKED => LOCKED, -- DCM LOCK status output
      PSDONE => PSDONE, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => CLKFB,   -- DCM clock feedback
      CLKIN => clk32_buffered,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => open,   -- Dynamic phase adjust clock input
      PSEN => open,     -- Dynamic phase adjust enable input
      PSINCDEC => open, -- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
	
	
	
	-- Create the 5x pixel clock, including the 180 degree output
   DCM_SP_inst2 : DCM_SP
   generic map (
      CLKDV_DIVIDE => 2.0, --  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
                           --     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE => 1,   --  Can be any interger from 1 to 32
      CLKFX_MULTIPLY => 5, --  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 => FALSE, --  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD => 40.0, --  Specify period of input clock
      CLKOUT_PHASE_SHIFT => "NONE", --  Specify phase shift of "NONE", "FIXED" or "VARIABLE" 
      CLK_FEEDBACK => "1X",         --  Specify clock feedback of "NONE", "1X" or "2X" 
      DESKEW_ADJUST => "SYSTEM_SYNCHRONOUS", -- "SOURCE_SYNCHRONOUS", "SYSTEM_SYNCHRONOUS" or
                                             --     an integer from 0 to 15
      DLL_FREQUENCY_MODE => "LOW",     -- "HIGH" or "LOW" frequency mode for DLL
      DUTY_CYCLE_CORRECTION => TRUE, --  Duty cycle correction, TRUE or FALSE
      PHASE_SHIFT => 0,        --  Amount of fixed phase shift from -255 to 255
      STARTUP_WAIT => FALSE) --  Delay configuration DONE until DCM_SP LOCK, TRUE/FALSE
   port map (
      CLK0 => CLK02,     -- 0 degree DCM CLK ouptput
      CLK180 => open, -- 180 degree DCM CLK output
      CLK270 => open, -- 270 degree DCM CLK output
      CLK2X => open,   -- 2X DCM CLK output
      CLK2X180 => open, -- 2X, 180 degree DCM CLK out
      CLK90 => open,   -- 90 degree DCM CLK output
      CLKDV => open,   -- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX => clock_x5pixel_unbuffered,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => clock_x5pixelinv_unbuffered, -- 180 degree CLK synthesis out
      LOCKED => LOCKED2, -- DCM LOCK status output
      PSDONE => PSDONE2, -- Dynamic phase adjust done output
      STATUS => open, -- 8-bit DCM status bits output
      CLKFB => CLKFB2,   -- DCM clock feedback
      CLKIN => clock_pixel,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK => open,   -- Dynamic phase adjust clock input
      PSEN => open,     -- Dynamic phase adjust enable input
      PSINCDEC => open, -- Dynamic phase adjust increment/decrement
      RST => '0'        -- DCM asynchronous reset input
   );
	
	CLKFB2 <= CLK02;
	CLKFB <= CLK0;

	BUFG_clk : BUFG port map 
	( 
		I => I_unbuff_clk32,                
		O => clk32_buffered
	);
		
	BUFG_pclock : BUFG port map 
	( 
	  I => clock_pixel_unbuffered,  
	  O => clock_pixel
	);

	BUFG_pclockx5 : BUFG port map 
	( 
	  I => clock_x5pixel_unbuffered,  
	  O => clock_x5pixel
	);

	BUFG_pclockx5_180 : BUFG port map 
	( 
	  I => clock_x5pixelinv_unbuffered,  
	  O => clock_x5pixelinv
	);
	
	 
   O_buff_clk32 <= CLK0; 
   O_buff_clkpixel <= clock_pixel;
   O_buff_clk5xpixel <= clock_x5pixel;
   O_buff_clk5xpixelinv <= clock_x5pixelinv; 
end Behavioral;

