// UART receiver

module rx(CLK, RX_LINE, DATA, BUSY);
   
   input CLK, RX_LINE;
   
   output [7:0] DATA; 
   output BUSY;

   reg [9:0] datafll;
   reg rx_flag = 0;
   reg busy_out = 0;
   reg [12:0] prescalar = 0;
   reg [3:0] index = 0;
   reg [7:0] data_out;
   
   always@(posedge CLK) begin
   
      if (rx_flag == 0 && RX_LINE == 0) begin   // if we are not receiving
         index = 0;                             // and there is a start bit on RX
         prescalar = 0;
         busy_out = 1;
         rx_flag = 1;
      end
      
      if (rx_flag == 1) begin             // begin receiving
         datafll[index] = RX_LINE;        // fill one data bit
         if (prescalar < 5207)
            prescalar = prescalar + 1;
         else
            prescalar = 0;
         if (prescalar == 2600) begin     // roughly every half cycle
            if (index < 9) 
               index = index + 1;
            else begin
               if (datafll[0] == 0 && datafll[9] == 1)   // verify a correct frame
                  data_out = datafll[8:1];               // write data
               else 
                  datafll = 0;            // all zeros if the frame is bad
               rx_flag = 0;
               busy_out = 0;
            end
         end
      end
         
   end // end always

   assign BUSY = busy_out;
   assign DATA = data_out;
   

endmodule

