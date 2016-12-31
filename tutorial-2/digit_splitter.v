// digit splitter
// splits an input signal into 4 output signals
// value -> thousands hundreds tens ones

module digit_splitter(in_value, out0, out1, out2, out3);

   input [13:0] in_value;		// about 16k max, needed to be over 10k

   output [3:0] out0, out1, out2, out3;
	
   reg [13:0] temp;
   reg [3:0] t0, t1, t2, t3;

   always@(in_value) begin
      temp = in_value;
      if (temp > 999) begin
         t3 = temp/1000;
         temp = temp - t3*1000;
      end
      else 
         t3 = 0;
      if (temp > 99) begin
         t2 = temp/100;
         temp = temp - t2*100;
      end
      else 
         t2 = 0;
      if (temp > 9) begin
         t1 = temp/10;
         temp = temp - t1*10;
      end
      else 
         t1 = 0;
      t0 = temp;
   end

   assign out0 = t0;
   assign out1 = t1;
   assign out2 = t2;
   assign out3 = t3;

endmodule
