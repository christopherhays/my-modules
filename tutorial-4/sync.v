// vga sync module (specific to the monitor I am using)
// 1024 x 768 @ 60Hz (different resolutions will have different values here)
// horizontal:    front porch 24
//                sync pulse 136
//                back porch 160
//                whole line 1344
//
// vertical:      front porch 3
//                sync pulse 6
//                back porch 29
//                whole frame 806



module sync(CLK, HSYNC, VSYNC, R, G, B, KEY, SW);

   `include "sq.v"
   
   input CLK;
   input [3:0] KEY;
   input [17:0] SW;
   output HSYNC, VSYNC;
   output [9:0] R, G, B;      // 10 bits for the de2 board
   
   reg hsync_out, vsync_out, draw1, draw2;
   reg [9:0] r_out, g_out, b_out, rgb;
   reg [13:0] hpos = 0;
   reg [13:0] vpos = 0;  // roughly 16k 
   reg [13:0] square_x1 = 500;
   reg [13:0] square_y1 = 300;
   reg [13:0] square_x2 = 500;
   reg [13:0] square_y2 = 500;
   
   always@(posedge CLK) begin
   
      square(hpos, vpos, square_x1, square_y1, rgb, draw1);
      square(hpos, vpos, square_x2, square_y2, rgb, draw2);
   
      if (draw1 == 1) begin
         if (SW[0] == 1) begin
            r_out = ~0;
            g_out = 0;
            b_out = 0;
         end
         else begin
            r_out = ~0;
            g_out = ~0;
            b_out = ~0;
         end
      end
      if (draw2 == 1) begin
         if (SW[1] == 1) begin
            r_out = ~0;
            g_out = 0;
            b_out = 0;
         end
         else begin
            r_out = ~0;
            g_out = ~0;
            b_out = ~0;
         end
      end
      if (draw1 == 0 && draw2 == 0) begin
         r_out = 0;
         g_out = 0;
         b_out = 0;
      end
            
      if (hpos < 1344)        // whole line
         hpos = hpos + 1;
      else begin
         hpos = 0;
         if (vpos < 806)      // whole frame
            vpos = vpos + 1;
         else begin     
            vpos = 0;
            // square position updates happen here, upon frame reset
            if (SW[0] == 1) begin
               if (KEY[0] == 0)
                  square_x1 = square_x1 + 5;
               if (KEY[1] == 0)
                  square_x1 = square_x1 - 5;
               if (KEY[2] == 0)
                  square_y1 = square_y1 + 5;
               if (KEY[3] == 0)
                  square_y1 = square_y1 - 5;   
            end
            if (SW[1] == 1) begin
               if (KEY[0] == 0)
                  square_x2 = square_x2 + 5;
               if (KEY[1] == 0)
                  square_x2 = square_x2 - 5;
               if (KEY[2] == 0)
                  square_y2 = square_y2 + 5;
               if (KEY[3] == 0)
                  square_y2 = square_y2 - 5;   
            end
         end
      end
      
      if (hpos > 24 && hpos < 160)  // horizontal sync during sync pulse time
         hsync_out = 0;             // pulse low
      else
         hsync_out = 1;
        
      if (vpos > 1 && vpos < 4)     // vertical sync
         vsync_out = 0;
      else
         vsync_out = 1;
   
      if ( (hpos > 0 && hpos < 320) || (vpos > 0 && vpos < 38)) begin
         r_out = 0;
         g_out = 0;     // output all zero during fp, sync, and bp
         b_out = 0;
      end
   
   end   // end always

   assign HSYNC = hsync_out;
   assign VSYNC = vsync_out;
   assign R = r_out;
   assign G = g_out;
   assign B = b_out;

endmodule

