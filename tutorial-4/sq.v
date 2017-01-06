// task to draw a square, given an initial position

task square;
      input [13:0] xcur, ycur, xpos, ypos;
      output [9:0] rgb;
      output draw;
      
      if (xcur > xpos && xcur < (xpos+100) && ycur > ypos && ycur < (ypos+100)) begin
         rgb = ~0;   // all ones
         draw = 1;
      end
      else
         draw = 0;
endtask

