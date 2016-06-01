# miniSpartan3

FPGA examples on Scarab Hardware miniSpartan3 board. All include ISE project files.

## led_test

LED counter, with inputs from the switches to control 'speed'.

## hdmi_out

DVID output from the HDMI port. Uses TMDS Encoders from Michael Field, as well as a modified version of his VGA signal generator.

Use the switches to change the output: All on is a test pattern, with the rest displaying all red, green and blue. LEDs reference the RGB setting.

## uart_ftdi

Uses Xilinx-provided Spartan3 UART modules and implements loopback rx/tx via the lines connected to port B of the FTDI USB chip. Can connect to the COMx port via a serial terminal when the miniSpartan3 is connected over USB. Switches determine echo or a '@' reply per-byte.