--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   23:19:36 05/30/2016
-- Design Name:   
-- Module Name:   C:/dev/miniSpartan3/projects/hdmi_out/tb_clocking.vhd
-- Project Name:  hdmi_out
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: clocking
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_clocking IS
END tb_clocking;
 
ARCHITECTURE behavior OF tb_clocking IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT clocking
    PORT(
         I_unbuff_clk32 : IN  std_logic;
         O_buff_clkpixel : OUT  std_logic;
         O_buff_clk5xpixel : OUT  std_logic;
         O_buff_clk5xpixelinv : OUT  std_logic;
         O_buff_clk32 : OUT  std_logic 
        );
    END COMPONENT;
    

   --Inputs
   signal I_unbuff_clk32 : std_logic := '0'; 

 	--Outputs
   signal O_buff_clkpixel : std_logic;
   signal O_buff_clk5xpixel : std_logic;
   signal O_buff_clk5xpixelinv : std_logic;
   signal O_buff_clk32 : std_logic;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant I_unbuff_clk32_period : time := 32 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: clocking PORT MAP (
          I_unbuff_clk32 => I_unbuff_clk32,
          O_buff_clkpixel => O_buff_clkpixel,
          O_buff_clk5xpixel => O_buff_clk5xpixel,
          O_buff_clk5xpixelinv => O_buff_clk5xpixelinv,
          O_buff_clk32 => O_buff_clk32 
        );

   -- Clock process definitions
   clk_process :process
   begin
		I_unbuff_clk32 <= '0';
		wait for I_unbuff_clk32_period/2;
		I_unbuff_clk32 <= '1';
		wait for I_unbuff_clk32_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for I_unbuff_clk32_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
