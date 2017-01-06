// Christopher Hays
// 01/04/2017 
// vga tutorial from Toni's youtube channel
// translating his vhdl into a verilog equivalent

// PLL: 50MHz in, 65Mhz out, created in QSYS
// monitor: HP vs15 - 1024x768 @ 60Hz (specific to my case)
// the de2 board is different than the one used in the tutorial so:
// tie VGA_BLANK and VGA_SYNC to 1
// connect VGA_CLK to the output of the PLL
// use 10 bits for the rgb values

// top level is vga.v
// the PLL files and sync.v were added to the project in Quartus
// the task file was not added, just included in the module when needed


module vga(CLOCK_50, VGA_HS, VGA_VS, VGA_R, VGA_G, VGA_B, VGA_SYNC, VGA_BLANK, VGA_CLK, KEY, SW);

   input CLOCK_50;
   input [3:0] KEY;
   input [17:0] SW;
   output VGA_HS, VGA_VS, VGA_SYNC, VGA_BLANK, VGA_CLK;
   output [9:0] VGA_R, VGA_G, VGA_B;
   
   wire vgaclk;
   reg reset = 0;
   
   sync S0 (.CLK(vgaclk), .HSYNC(VGA_HS), .VSYNC(VGA_VS), .R(VGA_R), .G(VGA_G), .B(VGA_B), .KEY(KEY), .SW(SW));

   PLL P0 (.clk_in_clk(CLOCK_50), .reset_reset(reset), .clk_out_clk(vgaclk));

   assign VGA_SYNC = 1;
   assign VGA_BLANK = 1;
   assign VGA_CLK = vgaclk;

endmodule

