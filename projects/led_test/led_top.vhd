----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:34:21 05/11/2016 
-- Design Name: 
-- Module Name:    led_top - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

entity led_top is
    Port ( I_clk : in  STD_LOGIC;
           O_leds : out  STD_LOGIC_VECTOR (2 downto 0);
			  I_switches : in STD_LOGIC_VECTOR (1 downto 0));
end led_top;

architecture Behavioral of led_top is
	signal count: unsigned(31 downto 0) := X"00000000";
	signal threeBits: std_logic_vector(2 downto 0) := "000";
begin

   process(I_clk)
	begin
	  if rising_edge(I_clk) then
	    count <= count + 1;
		 
		 if I_switches(1) = '1' then
			threeBits <= std_logic_vector(count(25 downto 23));
		 else
		   threeBits <= std_logic_vector(count(28 downto 26));
		 end if;
	  end if;
	end process;

   O_leds <= threeBits when I_switches(0) = '1' else "111";

end Behavioral;

