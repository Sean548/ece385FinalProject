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


module  Mario (input         Clk,                 // 50 MHz clock
                             Reset,               // Active-high reset signal
									  frame_clk,           // The clock indicating a new frame (~60Hz)
					input [9:0]   DrawX, DrawY,        // Current pixel coordinates
					input [1:0]   keymove,             // right x01, left x02, down x03
					input	        keypress_B,          // Run (allows for hold. high is 1, low is 0)
					input         keypress_A,	        // Jump (resets after every press aka no hold)
					input         pause,               // Pauses all elements. high is one.
					input         Size,		 			  // says what size mario is
					output [9:0]  mario_distx,mario_disty,
					output 		  Is_Mario             // Whether current pixel belongs to ball or background
              );
    
    parameter [9:0] Mario_X_Start = 10'd32;      // Center position on the X axis
    parameter [9:0] Mario_Y_Start = 10'd384;     // Center position on the Y axis //if it doesnt show change this to 100 
    parameter [9:0] Mario_X_Min = 10'd0;          // Leftmost point on the X axis
    parameter [9:0] Mario_X_Max = 10'd640;     	  // Rightmost point on the X axis
    parameter [9:0] Mario_Y_Min = 10'd0;       	  // Topmost point on the Y axis
    parameter [9:0] Mario_Y_Max = 10'd416;     	  // Bottommost point on the Y axis
    parameter [9:0] Mario_X_Step = 10'd3;      	  // Step size on the X axis
    parameter [9:0] Mario_Y_Step = 10'd20;        // Step size on the Y axis
    parameter [9:0] Mario_Size = 10'd32;          // Ball size
	 
//	 parameter [9:0] Small_Mario_Shape_X = 10'd32;
//	 parameter [9:0] Small_Mario_Shape_Y = 10'd32;
//	 parameter [9:0] Small_Mario_Shape_Size_X = 10'd32;
//	 parameter [9:0] Small_Mario_Shape_Size_Y = 10'd32;
//	 
//	 parameter [9:0] Big_Mario_Shape_X = 10'd32;
//	 parameter [9:0] Big_Mario_Shape_Y = 10'd32;
//	 parameter [9:0] Big_Mario_Shape_Size_X = 10'd32;
//	 parameter [9:0] Big_Mario_Shape_Size_Y = 10'd64;
	 
	 
    logic [9:0] Mario_X_Pos,
					 Mario_X_Motion,
					 Mario_Y_Pos,
					 Mario_Y_Motion;
					 
    logic [9:0] Mario_X_Pos_in,
					 Mario_X_Motion_in,
					 Mario_Y_Pos_in,
					 Mario_Y_Motion_in;
					 
	 logic [9:0] Ground_Height = 384;
					 
//	 logic [9:0] Mario_Shape_X = 300;
//	 logic [9:0] Mario_Shape_Y = 300;
	 logic [9:0] Mario_Size_X  = 32;
	 logic [9:0] Mario_Size_Y  = 32;
					 
	 
    //////// Do not modify the always_ff blocks. ////////
	 
    logic frame_clk_delayed, frame_clk_rising_edge;
    always_ff @ (posedge Clk) begin
        frame_clk_delayed <= frame_clk;
        frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
    end
	 
    /////////////////////////////////////////////////////
	 
	 
	 
	 
	 //////// Update Registers -- DO NOT MODIFY //////////
	 
    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Mario_X_Pos <= Mario_X_Start;
            Mario_Y_Pos <= Mario_Y_Start;
            Mario_X_Motion <= 10'd0;
            Mario_Y_Motion <= 10'd0;
        end
        else
        begin
            Mario_X_Pos <= Mario_X_Pos_in;
            Mario_Y_Pos <= Mario_Y_Pos_in;
            Mario_X_Motion <= Mario_X_Motion_in;
            Mario_Y_Motion <= Mario_Y_Motion_in;
        end
    end
	 
    /////////////////////////////////////////////////////
	 assign mario_distx = DrawX - Mario_X_Pos;
	 assign mario_disty = DrawY - Mario_Y_Pos;
	 
	 
	 /////////////////////////////////////////////////////
	 //left and right movement with sprint but no acceleration yet
	 
    always_comb
    begin
        // Default Position for Mario
        Mario_X_Pos_in = Mario_X_Pos;
        Mario_Y_Pos_in = Mario_Y_Pos;
        Mario_X_Motion_in = Mario_X_Motion;
        Mario_Y_Motion_in = Mario_Y_Motion; //+ 1'b1;
        
        if (frame_clk_rising_edge)
        begin
		  ////////////////////////////////////////////////////////////////
				if(keymove == 3'b000)
					Mario_X_Motion_in= 0; //If No buttons pressed, No Movement
		  ////////////////////////////////////////////////////////////////	
				if(keymove == 3'b001)
				begin
					if(keypress_B == 1'b0)
						Mario_X_Motion_in = Mario_X_Step;
					if(keypress_B == 1'b1)
						Mario_X_Motion_in = Mario_X_Step + 1'b11;
				end
		  ////////////////////////////////////////////////////////////////
				if(keymove == 3'b010)
				begin
					if(keypress_B == 1'b0)
						Mario_X_Motion_in =~(Mario_X_Step) + 1'b1;
					if(keypress_B == 1'b1)
						Mario_X_Motion_in =~(Mario_X_Step) - 1'b10;
				end
		  ////////////////////////////////////////////////////////////////		
		  //jump with acceleration
				if(keypress_A == 1'b1 && (Mario_Y_Pos >= Ground_Height + Mario_Size))
				begin
					if((Mario_Y_Pos + Mario_Size) >= Ground_Height)
					begin
						Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
						Mario_Y_Motion_in =~(Mario_Y_Step) + 1'b1;
					end
				end
		  ////////////////////////////////////////////////////////////////
//				else if((Mario_Y_Pos + Mario_Y_Motion + Mario_Size) > Ground_Height)
//				begin
//					Mario_Y_Pos_in = Mario_Y_Start - Mario_Size;
//					Mario_Y_Motion_in = 0;
//				end
// 			else
				else if((Mario_Y_Pos - Mario_Size) == Mario_X_Max)
					Mario_X_Motion_in = 0;
				
				else if(((Mario_X_Pos - Mario_Size) || (Ground_Height - Mario_Size) || (Mario_Y_Pos + Mario_Y_Motion + Mario_Size)) > Ground_Height)
					Mario_Y_Pos_in = (Ground_Height - Mario_Size);
				else
				begin
					Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
					Mario_Y_Motion_in = Mario_Y_Motion + 1'b1;
				end
		  ////////////////////////////////////////////////////////////////


            if( Mario_Y_Pos + Mario_Size >= Ground_Height )  // Ball is at the bottom edge, BOUNCE!
				begin
					 if(keypress_A==1'b1)
						Mario_Y_Motion_in = (~(Mario_Y_Step) + 1'b1);  // 2's complement.  
					 else
						Mario_Y_Motion_in = 0;
				end
            if ( Mario_Y_Pos <= Mario_Y_Min + Mario_Size )  // Ball is at the top edge, BOUNCE!
				begin
                Mario_Y_Motion_in = Mario_Y_Step;
				end
				if( Mario_X_Pos + Mario_Size >= 10'd320 )  // Ball is at the right edge, BOUNCE!
				begin
					 if(keymove == 3'b010)
						Mario_X_Motion_in = (~(Mario_X_Step) + 1'b1);
                else
						Mario_X_Motion_in = 0;
				end
				else if ( Mario_X_Pos <= Mario_X_Min + 10'd0 )  // Ball is at the left edge, BOUNCE!
				begin
					 if(keymove == 3'b001)
						Mario_X_Motion_in = Mario_X_Step;
                else
						Mario_X_Motion_in = 0;
				end
        
		  
            // Update the ball's position with its motion
            Mario_X_Pos_in = Mario_X_Pos + Mario_X_Motion;
            //Mario_Y_Pos_in = Mario_Y_Pos + Mario_Y_Motion;
        end
    end
    
    // Compute whether the pixel corresponds to Mario or background
    always_comb
	 begin
		  if ( DrawX >= Mario_X_Pos && DrawX < Mario_X_Pos + Mario_Size_X &&
				 DrawY >= Mario_Y_Pos && DrawY < Mario_Y_Pos + Mario_Size_Y)
            Is_Mario = 1'b1;
        else
            Is_Mario = 1'b0;
    end
	 
	 
endmodule 
