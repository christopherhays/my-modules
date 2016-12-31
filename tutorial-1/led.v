// Christopher Hays 12/30/16
// led module from the youtube video, info on the blog
// used both case and if statements just to show both



module led(CLOCK_50, KEY, LEDR);

	input CLOCK_50;
	input [3:0] KEY;
	output [17:0] LEDR;
	
	reg [3:0] i;
	reg [7:0] counter = 0;
	reg [7:0] result;
	reg [18:0] prescalar = 0;		// 512k roughly
	
	always@(posedge CLOCK_50) begin
		if (prescalar < 500000)
			prescalar = prescalar + 1;
		else begin
			prescalar = 0;
			// KEY0 chooses the counting direction
			case (KEY[0])
				0: 	begin	// count up
						if (counter < 255)
							counter = counter + 1;
						else
							counter = 0;
					end
				1:	begin	// count down
						if (counter > 0)
							counter = counter - 1;
						else
							counter = 255;
					end
			endcase
		end
		
		// KEY1 chooses the output mode
		if (KEY[1] == 0)	// binary mode
			result = counter;
		else begin			// progress bar mode
			for (i=0; i<8; i = i+1) begin
				if (counter > 25*(i+1))
					result[i] = 1;
				else
					result[i] = 0;
			end
		end
	end	 // end always loop
		
	assign LEDR = result;

endmodule
