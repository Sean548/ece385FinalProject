 
//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  12-08-2017                               --
//    Spring 2018 Distribution                                           --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  Mario ( input         Clk,                // 50 MHz clock
                             Reset,              // Active-high reset signal
									  frame_clk,          // The clock indicating a new frame (~60Hz)
          input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	       input [1:0]   keymove,            // right x01, left x02, down x03
	       input	      keypress_B,         // Run (allows for hold. high is 1, low is 0)
	       input         keypress_A,	        // Jump (resets after every press aka no hold)
	       input         pause,              // Pauses all elements. high is one.
	       input         Size,		 //says what size mario is
          output Is_Mario             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Ball_X_Center = 10'd32;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center = 10'd591;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min = 10'd0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max = 10'd639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min = 10'd0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max = 10'd479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step = 10'd1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step = 10'd20;      // Step size on the Y axis
    parameter [9:0] Ball_Size = 10'd32;        // Ball size
	 parameter [9:0] Ball_Y_Floor = 10'd575;
	 
	 //need to update ball size for different marios
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
    logic [9:0] Ball_X_Pos_in, Ball_X_Motion_in, Ball_Y_Pos_in, Ball_Y_Motion_in;
//    int check = 0;
    //////// Do not modify the always_ff blocks. ////////
    // Detect rising edge of frame_clk
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
    // Update registers
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Ball_X_Pos <= Ball_X_Center;
            Ball_Y_Pos <= Ball_Y_Center;
            Ball_X_Motion <= 10'd0;
            Ball_Y_Motion <= 10'd0;
        end
        else
        begin
            Ball_X_Pos <= Ball_X_Pos_in;
            Ball_Y_Pos <= Ball_Y_Pos_in;
            Ball_X_Motion <= Ball_X_Motion_in;
            Ball_Y_Motion <= Ball_Y_Motion_in;
        end
    end
    //////// Do not modify the always_ff blocks. ////////
    
    // You need to modify always_comb block.
    always_comb
    begin
        // By default, keep motion and position unchanged
        Ball_X_Pos_in = Ball_X_Pos;
        Ball_Y_Pos_in = Ball_Y_Pos;
        Ball_X_Motion_in = Ball_X_Motion;
        Ball_Y_Motion_in = Ball_Y_Motion +1'b1;
        
        // Update position and motion only at rising edge of frame clock
        if (frame_clk_rising_edge)
        begin
            // Be careful when using comparators with "logic" datatype because compiler treats 
            //   both sides of the operator as UNSIGNED numbers.
            // e.g. Ball_Y_Pos - Ball_Size <= Ball_Y_Min 
            // If Ball_Y_Pos is 0, then Ball_Y_Pos - Ball_Size will not be -4, but rather a large positive number.
				//check = check;
				
				
				//left and right movement with sprint but no acceleration yet
				if(keymove==3'b000)
					Ball_X_Motion_in=0;
				if(keymove==3'b001)
				begin
					if(keypress_B==1'b0)
						Ball_X_Motion_in=Ball_X_Step;
					if(keypress_B==1'b1)
						Ball_X_Motion_in=Ball_X_Step+1'b1;
				end
				if(keymove==3'b010)
				begin
					if(keypress_B==1'b0)
						Ball_X_Motion_in=~(Ball_X_Step)+ 1'b1;
					if(keypress_B==1'b1)
						Ball_X_Motion_in=~(Ball_X_Step);
				end
					
				
				
				//jump with acceleration
				Ball_Y_Motion_in = Ball_Y_Motion + 1;
				
				
				if(keypress_A==1'b1&&Ball_Y_Motion==0)
				begin
					if(Ball_Y_Pos + Size >= Ball_Y_Center)
						Ball_Y_Motion_in=~(Ball_Y_Step)+1'b1;
				end
				else if((Ball_Y_Pos + Ball_Y_Motion+Ball_Size) > Ball_Y_Floor)
					Ball_Y_Pos_in = Ball_Y_Floor-Ball_Size;
				else
					Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
				
				

//				
//				if(keycode == 8'h1a) //check for up
//				begin
//					Ball_Y_Motion_in = ~(Ball_Y_Step)+ 1'b1;
//					Ball_X_Motion_in= 0;
//				end
//				else if(keycode == 8'h16) //check for down
//				begin
//					Ball_Y_Motion_in = (Ball_Y_Step);
//					Ball_X_Motion_in= 0;
//				end
//				else if(keycode == 8'h4) //check for left
//				begin
//					Ball_Y_Motion_in = 0;
//					Ball_X_Motion_in= ~(Ball_X_Step)+ 1'b1;
//				end
//				else if(keycode == 8'h7) //check for right
//				begin
//					Ball_Y_Motion_in = 0;
//					Ball_X_Motion_in= Ball_X_Step;
//				end
//            if( Ball_Y_Pos + Ball_Size >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//				begin
//                Ball_Y_Motion_in = (~(Ball_Y_Step) + 1'b1);  // 2's complement.  
//					 Ball_X_Motion_in = 0;
//				end
//            else if ( Ball_Y_Pos <= Ball_Y_Min + Ball_Size )  // Ball is at the top edge, BOUNCE!
//				begin
//                Ball_Y_Motion_in = Ball_Y_Step;
//					 Ball_X_Motion_in = 0;
//				end
//				else if( Ball_X_Pos + Ball_Size >= Ball_X_Max )  // Ball is at the right edge, BOUNCE!
//				begin
//                Ball_X_Motion_in = (~(Ball_X_Step) + 1'b1);  // 2's complement.  
//					 Ball_Y_Motion_in = 0;
//				end
//				else if ( Ball_X_Pos <= Ball_X_Min + Ball_Size )  // Ball is at the left edge, BOUNCE!
//				begin
//                Ball_X_Motion_in = Ball_X_Step;
//					 Ball_Y_Motion_in = 0;
//				end
//            // TODO: Add other boundary detections and handle keypress here.
//        
        
            // Update the ball's position with its motion
            Ball_X_Pos_in = Ball_X_Pos + Ball_X_Motion;
            Ball_Y_Pos_in = Ball_Y_Pos + Ball_Y_Motion;
        end
    end
    
    // Compute whether the pixel corresponds to ball or background
    /* Since the multiplicants are required to be signed, we have to first cast them
       from logic to int (signed by default) before they are multiplied. */
    int DistX, DistY, SizeB;
    assign DistX = DrawX - Ball_X_Pos;
    assign DistY = DrawY - Ball_Y_Pos;
    assign SizeB = Ball_Size;
    always_comb begin
        if ( ( DistX*DistX + DistY*DistY) <= (SizeB*SizeB) ) 
            Is_Mario = 1'b1;
        else
            Is_Mario = 1'b0;
        /* The ball's (pixelated) circle is generated using the standard circle formula.  Note that while 
           the single line is quite powerful descriptively, it causes the synthesis tool to use up three
           of the 12 available multipliers on the chip! */
    end
endmodule 
