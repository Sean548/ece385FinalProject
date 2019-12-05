module Gomba(input 			Clk, 
									Reset,
									frame_clk,
				 input [9:0]   DrawX,
									DrawY,
									GombaX,
									GombaY,
				 output 			Is_Gomba
//				 output [2:0]  Mario_Collision //0 no collision, 1 mario right, 2 mario below, 3 mario left, 4 mario up
				 );

parameter [9:0] Size = 32;
parameter [9:0] Gomba_X_Step = 10'd1;      	  // Step size on the X axis
logic [9:0] Gomba_X_Pos,Gomba_Y_Pos,Gomba_X_Pos_in,Gomba_Y_Pos_in,Gomba_X_Motion,Gomba_X_Motion_in,Comba_X_Motion;


logic frame_clk_delayed, frame_clk_rising_edge;
always_ff @ (posedge Clk) begin
    frame_clk_delayed <= frame_clk;
    frame_clk_rising_edge <= (frame_clk == 1'b1) && (frame_clk_delayed == 1'b0);
end
	 
always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Gomba_X_Pos <= GombaX;
            Gomba_Y_Pos <= GombaY;
				Gomba_X_Motion <= 10'd0;
        end
        else
        begin
            Gomba_X_Pos <= Gomba_X_Pos_in;
            Gomba_Y_Pos <= Gomba_Y_Pos_in;
				Gomba_X_Motion <= Gomba_X_Motion_in;
        end
    end

always_comb
	 begin
		  Gomba_X_Motion_in =Gomba_X_Motion;
		  Gomba_X_Pos_in = Gomba_X_Pos;
		  Gomba_Y_Pos_in = Gomba_Y_Pos;
		  if(frame_clk_rising_edge)
		  begin
				Gomba_X_Motion_in =~Gomba_X_Step;
				Gomba_X_Pos_in = Gomba_X_Pos + Gomba_X_Motion;
				Gomba_Y_Pos_in = Gomba_Y_Pos;
		  end
		  if ( DrawX >= Gomba_X_Pos && DrawX < Gomba_X_Pos + Size &&
				 DrawY >= Gomba_Y_Pos && DrawY < Gomba_Y_Pos + Size)
            Is_Gomba = 1'b1;
        else
            Is_Gomba = 1'b0;
	 end
endmodule
