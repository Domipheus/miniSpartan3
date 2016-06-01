----------------------------------------------------------------------------------
-- Company: Domipheus Labs
-- Engineer: Colin Riley
-- 
-- Description: UART test - using Xilinx Spartan3 UART libraries
--   
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_test_top is
    Port (I_clk : in  STD_LOGIC;
          O_leds : out  STD_LOGIC_VECTOR (2 downto 0);
          I_switches : in STD_LOGIC_VECTOR (1 downto 0);
          I_rx: in STD_LOGIC;
          O_tx: out STD_LOGIC);
end uart_test_top;

architecture Behavioral of uart_test_top is

--
-- declaration of UART transmitter with integral 16 byte FIFO buffer
--
  component uart_tx
    Port (            data_in : in std_logic_vector(7 downto 0);
                 write_buffer : in std_logic;
                 reset_buffer : in std_logic;
                 en_16_x_baud : in std_logic;
                   serial_out : out std_logic;
                  buffer_full : out std_logic;
             buffer_half_full : out std_logic;
                          clk : in std_logic);
    end component;
--
-- declaration of UART Receiver with integral 16 byte FIFO buffer
--
  component uart_rx
    Port (            serial_in : in std_logic;
                       data_out : out std_logic_vector(7 downto 0);
                    read_buffer : in std_logic;
                   reset_buffer : in std_logic;
                   en_16_x_baud : in std_logic;
            buffer_data_present : out std_logic;
                    buffer_full : out std_logic;
               buffer_half_full : out std_logic;
                            clk : in std_logic);
  end component;
  
--
  -- Signals for UART connections
  --
  signal          baud_count : integer range 0 to 255 :=0;
  signal        en_16_x_baud : std_logic;
  signal       write_to_uart : std_logic;
  signal             tx_full : std_logic;
  signal        tx_half_full : std_logic;
  signal      read_from_uart : std_logic;
  signal             rx_data : std_logic_vector(7 downto 0);
  signal             tx_data : std_logic_vector(7 downto 0);
  signal     rx_data_present : std_logic;
  signal             rx_full : std_logic;
  signal        rx_half_full : std_logic;

  signal count: unsigned(31 downto 0) := X"00000000";
  signal threeBits: std_logic_vector(2 downto 0) := "000";
begin

  ----------------------------------------------------------------------------------------------------------------------------------
  -- UART  
  ----------------------------------------------------------------------------------------------------------------------------------
  --
  -- Connect the 8-bit, 1 stop-bit, no parity transmit and receive macros.
  -- Each contains an embedded 16-byte FIFO buffer.
  --

  transmit: uart_tx 
  port map (            data_in => tx_data, 
             write_buffer => write_to_uart,
             reset_buffer => '0',
             en_16_x_baud => en_16_x_baud,
              serial_out => O_tx,
              buffer_full => tx_full,
          buffer_half_full => tx_half_full,
                   clk => I_clk );

  receive: uart_rx
  port map (            serial_in => I_rx,
                 data_out => rx_data,
               read_buffer => read_from_uart,
              reset_buffer => '0',
              en_16_x_baud => en_16_x_baud,
          buffer_data_present => rx_data_present,
               buffer_full => rx_full,
            buffer_half_full => rx_half_full,
                    clk => I_clk );  
                    
  --when switch 0 is off, print '@' for each incoming byte, else echo the byte back
  tx_data <= X"40" when I_switches(0) = '0' else rx_data;
  write_to_uart <= rx_data_present;
  read_from_uart <= rx_data_present;

  --
  -- Set baud rate to 9600 for the UART communications
  -- Requires en_16_x_baud to be 153,600 which is a single cycle pulse every 208 cycles at 32MHz 
  --
  baud_timer: process(I_clk)
  begin
    if rising_edge(I_clk) then
      if baud_count=208 then
           baud_count <= 0;
         en_16_x_baud <= '1';
       else
           baud_count <= baud_count + 1;
         en_16_x_baud <= '0';
      end if;
    end if;
  end process baud_timer;

   -- led counter still exists, as a debug tool
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

