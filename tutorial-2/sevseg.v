// Christopher Hays 12/30/16
// demo #2 from the same youtube channel
// using verilog instead of vhdl

module sevseg(CLOCK_50, KEY, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7);

	input CLOCK_50;
	input [3:0] KEY;
	input [17:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

	wire [3:0] ones, tens, hundreds, thousands;
	
	reg [25:0] prescaler = 0;		// roughly 64M
	reg [13:0] counter = 0;			// roughly 14k

	
	assign HEX4 = 127;		// turn off the highest 4 displays
	assign HEX5 = 127;
	assign HEX6 = 127;
	assign HEX7 = 127;

	// instantiate the splitter
	digit_splitter S0 (.in_value(counter), .out0(ones), .out1(tens), .out2(hundreds), .out3(thousands));
	
	// instantiate the decoders
	sev_seg_decoder D0 (.in_value(ones), 		.out_value(HEX0));
	sev_seg_decoder D1 (.in_value(tens), 		.out_value(HEX1));
	sev_seg_decoder D2 (.in_value(hundreds), 	.out_value(HEX2));
	sev_seg_decoder D3 (.in_value(thousands), .out_value(HEX3));

	always@(posedge CLOCK_50) begin
		if (prescaler < 100000 * SW)		// augmented by the value on the switches
			prescaler = prescaler + 1;
		else
			prescaler = 0;
			
		if (prescaler == 0) begin
			if (KEY[0] == 1) begin
				if (counter < 9999)
					counter = counter + 1;
				else
					counter = 0;
			end
			else begin
				if (counter > 0)
					counter = counter -1;
				else
					counter = 9999;
			end
		end	
	end  // end always

endmodule













