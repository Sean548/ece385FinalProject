//  Register Module by Peter Hevrdejs & Sean McGee
////////////////////////////////////////////////////////////////////////////////////////////////
module Register (input  logic Clk, Reset, load, Write, CS,
					  input logic [3:0] byteenable,
                      input  logic [31:0] Reg_In,
                      output logic [31:0] Reg_Out);

  always_ff @ (posedge Clk)
    begin
	 	 if (Reset)
			Reg_Out <= 32'h00000000;
		else if (Write && CS)
		begin
				if (byteenable == 4'b1111 && load == 1'b1)
					Reg_Out <= Reg_In; 
				if(byteenable == 4'b1100 && load == 1'b1)
					Reg_Out [31:16] <= Reg_In [31:16];
				if(byteenable == 4'b0011 && load == 1'b1)
					Reg_Out [15:0] <= Reg_In [15:0];
				if (byteenable == 4'b1000 && load == 1'b1)
					Reg_Out [31:24] <= Reg_In [31:24];
				if (byteenable == 4'b0100 && load == 1'b1)
					Reg_Out [23:16] <= Reg_In [23:16];
				if (byteenable == 4'b0010 && load == 1'b1)
					Reg_Out [15:8] <= Reg_In [15:8];
				if (byteenable == 4'b0001 && load == 1'b1)
					Reg_Out [7:0] <= Reg_In [7:0];
		end
    end
endmodule


module BigReg (input logic Clk, Reset, load,
					input logic [31:0] RegA_In, RegB_In, RegC_In, RegD_In,
					output logic [127:0] Reg_Out);
	always_ff @ (posedge Clk)
		begin
			if (Reset)
				Reg_Out <= 127'h00000000000000000000000000000000;
			else if(load)
				begin
					Reg_Out[31:0] <= RegA_In;
					Reg_Out[63:32] <= RegB_In;
					Reg_Out[95:64] <= RegC_In;
					Reg_Out[127:96] <= RegD_In;
				end
		end
endmodule

module SmallReg(input logic Clk, Reset, load,
					 input logic [31:0] Reg_In,
					output logic Reg_Out);
		
	always_ff @ (posedge Clk)
		begin
			if (Reset)
				Reg_Out <= 1'b0;
			else
				Reg_Out <= Reg_In[0];	
		end
endmodule

module ThickReg(input logic Clk, Reset, load,
					 input logic [1407:0] Reg_In,
					 output logic [1407:0] Reg_Out);
	always_ff @ (posedge Clk)
		begin
			if (Reset)
				Reg_Out <= 0;
			else
				Reg_Out <= Reg_In;
		end
endmodule


module ColReg(input logic Clk, Reset, load,
					input logic [1:0] Select,
					input logic [31:0] Reg_In,
					output logic [127:0] Reg_Out);
	always_ff @ (posedge Clk)
		begin
			if (Reset)
				Reg_Out <= 0;
			else if (load == 1'b1)
			begin
				if(Select == 2'b00)
					Reg_Out[31:0] <= Reg_In;
				if(Select == 2'b01)
					Reg_Out[63:32] <= Reg_In;
				if(Select == 2'b10)
					Reg_Out[95:64] <= Reg_In;
				if(Select == 2'b11)
					Reg_Out[127:96] <= Reg_In;
			end
		end
endmodule



					