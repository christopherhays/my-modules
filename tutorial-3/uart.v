// Christopher Hays
// 12/31/2016 
// tutorial 3, uart on the de2 development board
// using verilog

// set parity to none, no flow control, 9600 baud

module uart(CLOCK_50, KEY, SW, LEDG, LEDR, UART_TXD, UART_RXD);

   input CLOCK_50;
   input [17:0] SW;
   input [3:0] KEY;
   output [7:0] LEDG;
   output [17:0] LEDR;
   output UART_TXD;
   input UART_RXD;
   
   reg [7:0] tx_data, ledg_out, ledr_out;
   reg tx_start = 0;
   wire tx_busy, rx_busy;
   wire [7:0] rx_data;
   
   // connect the modules
   tx T0 (.CLK(CLOCK_50), .START(tx_start), .BUSY(tx_busy), .DATA(tx_data), .TX_LINE(UART_TXD));
   rx R0 (.CLK(CLOCK_50), .RX_LINE(UART_RXD), .DATA(rx_data), .BUSY(rx_busy));

   always@(posedge CLOCK_50) begin
      if (KEY[0] == 0 && tx_busy == 0) begin    // when key0 is pressed and not busy
         tx_data = SW[7:0];                     // set the data and start tx
         tx_start = 1;
         ledg_out = tx_data;
      end
      else
         tx_start = 0;
   end   // end always
   
   always@(negedge rx_busy) begin         // as soon as receiver is not busy
      ledr_out = rx_data;                 // write the data to leds
   end   // end always
   
   assign LEDR = ledr_out;
   assign LEDG = ledg_out;

endmodule

