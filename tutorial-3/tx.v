// UART transmitter

module tx (CLK, START, BUSY, DATA, TX_LINE);

   input CLK, START;
   input [7:0] DATA;
   output BUSY, TX_LINE;
   
   reg [12:0] prescalar = 0;  // roughly 8k
   reg [3:0] index = 0;       // need room for 0-9
   reg [9:0] datafll = 0;     // 8 bits of data plus start/stop bits
   reg tx_flag = 0;           // 1 if we are transmitting
   
   reg busy_out = 0;
   reg tx_out = 1;            // idle is data high
   
   always@(posedge CLK) begin
      if (tx_flag == 0 && START == 1) begin
         tx_flag = 1;
         busy_out = 1;
         datafll[0] = 0;         // place data in datafll inbetween the control bits
         datafll[9] = 1;
         datafll[8:1] = DATA;   
      end
      
      if (tx_flag == 1) begin          // data is ready to transmit
         if (prescalar < 5207)         // 50MHz/9600 baud = 5207
            prescalar = prescalar + 1;
         else
            prescalar = 0;
         if (prescalar == 2600) begin  // every half of a cycle, roughly
            tx_out = datafll[index];   // place a bit on the data line 
            if (index < 9)
               index = index + 1;
            else begin                 // until the data is full
               tx_flag = 0;
               index = 0; 
               busy_out = 0;
            end
         end
      end
   end   // end always

   assign BUSY = busy_out;
   assign TX_LINE = tx_out;

endmodule
