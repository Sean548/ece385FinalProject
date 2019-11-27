////  Register Module by Peter Hevrdejs & Sean McGee
//////////////////////////////////////////////////////////////////////////////////////////////////


module Reg_Dpad(input logic Clk, Reset,
					 input logic [1:0] Reg_In,
					 output logic [1:0] Reg_Out);
		always_ff @ (posedge Clk)
			begin
				if (Reset)
					Reg_Out <= 0;
				else
					Reg_Out <= Reg_In;
			end
endmodule

module Reg_Button(input logic Clk, Reset,
					   input logic Reg_In,
					   output logic Reg_Out);
		always_ff @ (posedge Clk)
			begin
				if (Reset)
					Reg_Out <= 0;
				else
					Reg_Out <= Reg_In;
			end
endmodule
