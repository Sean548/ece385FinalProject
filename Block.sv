module Block(input 			Clk, 
									Reset,
									frame_clk,
				 input [9:0]   DrawX,
									DrawY,
									BlockX,
									BlockY,
									MarioX,
									MarioY,
				 output 			Is_Block,
				 output [2:0]  Mario_Collision //0 no collision, 1 mario right, 2 mario below, 3 mario left, 4 mario up
				 );
logic Broken;
logic Broken_in;
logic [9:0] Block_Size_X = 32;
logic [9:0] Block_Size_Y = 32;
logic [9:0] Mario_Size_X = 32;
logic [9:0] Mario_Size_Y = 32;

always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            Broken <= 0;
        end
        else
        begin
            Broken <= Broken_in;
        end
    end

always_comb
	 begin
		 Mario_Collision = 3'b000;
		 Is_Block=1'b0;
		 Broken_in=Broken;
		 if(Broken)
			begin
				Broken_in=1;
			end

		 else
		 begin
		  if ( DrawX >= BlockX && DrawX < BlockX + Block_Size_X &&
				 DrawY >= BlockY && DrawY < BlockY + Block_Size_Y)
            Is_Block = 1'b1;
        else
            Is_Block = 1'b0;
		  if(BlockY-64<=MarioY&&MarioY+Mario_Size_Y<=BlockY)
		  begin
			if(MarioX-BlockX <=30||BlockX-MarioX <=30)// if mario hits block from above
					Mario_Collision = 3'b100;
		  end
		  if(BlockX+32>=MarioX&& MarioX>= BlockX+64) // if mario hits block from left
		  begin
				if(MarioY-BlockY <=30||BlockY-MarioY <=30)
					Mario_Collision = 3'b011;
		  end
		  if(BlockY+24<=MarioY&& MarioY<=BlockY+56) //if mario hit block from below
		  begin
				if(MarioX-BlockX <=30||BlockX-MarioX <=30)
				begin
					Mario_Collision = 3'b010;
					Broken_in = 1'b1;
				end
		  end
		 end
    end

endmodule
