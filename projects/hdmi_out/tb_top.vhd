--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:48:49 05/31/2016
-- Design Name:   
-- Module Name:   C:/dev/miniSpartan3/projects/hdmi_out/tb_top.vhd
-- Project Name:  hdmi_out
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: led_top
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
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hdmi_top
    PORT(
         I_clk : IN  std_logic;
         O_leds : OUT  std_logic_vector(2 downto 0);
         O_hdmi_p : OUT  std_logic_vector(3 downto 0);
         O_hdmi_n : OUT  std_logic_vector(3 downto 0);
         I_switches : IN  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal I_clk : std_logic := '0';
   signal I_switches : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal O_leds : std_logic_vector(2 downto 0);
   signal O_hdmi_p : std_logic_vector(3 downto 0);
   signal O_hdmi_n : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant I_clk_period : time := 32 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hdmi_top PORT MAP (
          I_clk => I_clk,
          O_leds => O_leds,
          O_hdmi_p => O_hdmi_p,
          O_hdmi_n => O_hdmi_n,
          I_switches => I_switches
        );

   -- Clock process definitions
   I_clk_process :process
   begin
		I_clk <= '0';
		wait for I_clk_period/2;
		I_clk <= '1';
		wait for I_clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for I_clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
