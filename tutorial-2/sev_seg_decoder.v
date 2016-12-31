// takes an input 0-15 and returns the values to drive the display

module sev_seg_decoder(in_value, out_value);

   input [3:0] in_value;
   output [6:0] out_value;

   reg [6:0] result;

   always@(in_value) begin
      case (in_value)
         0: result = 7'b1000000;
         1: result = 7'b1111001;
         2: result = 7'b0100100;
         3: result = 7'b0110000;
         4: result = 7'b0011001;
         5: result = 7'b0010010;
         6: result = 7'b0000010;
         7: result = 7'b1111000;
         8: result = 7'b0000000;
         9: result = 7'b0010000;
         10: result = 7'b0001000;
         11: result = 7'b0000011;
         12: result = 7'b1000110;
         13: result = 7'b0100001;
         14: result = 7'b0000110;
         15: result = 7'b0001110;
      endcase
   end

   assign out_value = result;

endmodule
