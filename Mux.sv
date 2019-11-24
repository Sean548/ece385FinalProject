
module Mux (input logic [3:0] Select,
				input logic [15:0] Mux_In,
            output logic Mux_Out);
// This Is a selecting unit with specific inputs
    always_comb
    begin
        if ( Select == 4'b0000)
            Mux_Out = Mux_In[0];
        else if ( Select == 4'b0001)
            Mux_Out = Mux_In[1];
        else if ( Select == 4'b0010)
            Mux_Out = Mux_In[2];
		  else if ( Select == 4'b0011)
            Mux_Out = Mux_In[3];
		  else if ( Select == 4'b0100)
            Mux_Out = Mux_In[4];
		  else if ( Select == 4'b0101)
            Mux_Out = Mux_In[5];
		  else if ( Select == 4'b0110)
            Mux_Out = Mux_In[6];
		  else if ( Select == 4'b0111)
            Mux_Out = Mux_In[7];
		  else if ( Select == 4'b1000)
            Mux_Out = Mux_In[8];
		  else if ( Select == 4'b1001)
            Mux_Out = Mux_In[9];
		  else if ( Select == 4'b1010)
            Mux_Out = Mux_In[10];
		  else if ( Select == 4'b1011)
            Mux_Out = Mux_In[11];
		  else if ( Select == 4'b1100)
            Mux_Out = Mux_In[12];
		  else if ( Select == 4'b1101)
            Mux_Out = Mux_In[13];
		  else if ( Select == 4'b1110)
            Mux_Out = Mux_In[14];
		  else
            Mux_Out = Mux_In[15];
    end
endmodule


module RegMuxOut (input logic [3:0] Select,
						input logic [31:0] A, B, C, D, E, F, G, H, I, J, K, L, O, P,
						output logic [31:0] Output);


		always_comb 
		begin
			case(Select)
				4'b0000:
					Output = A;
				4'b0001:
					Output = B;
				4'b0010:
					Output = C;
				4'b0011:
					Output = D;
				4'b0100:
					Output = E;
				4'b0101:
					Output = F;
				4'b0110:
					Output = G;
				4'b0111:
					Output = H;
				4'b1000:
					Output = I;
				4'b1001:
					Output = J;
				4'b1010:
					Output = K;
				4'b1011:
					Output = L;
				4'b1110:
					Output = O;
				4'b1111:
					Output = P;
				default:
					Output = A;
			endcase
		end
endmodule 

//gotta finish this



module Mux32b (input logic [31:0] in1,in2, in3, in4,
				  input logic [1:0] select,
				  output logic [31:0] out
				  );
				  
	always_comb
	begin
		if(select == 2'b00)
			out = in1;
		else if(select ==2'b01)
			out = in2;
		else if(select ==2'b10)
			out = in3;
		else
			out = in4;
	end
endmodule

module Mux128b (input logic [127:0] in1,in2, in3, in4,
				  input logic [1:0] select,
				  output logic [127:0] out
				  );
				  
	always_comb
	begin
		if(select == 2'b00)
			out = in1;
		else if(select ==2'b01)
			out = in2;
		else if(select ==2'b10)
			out = in3;
		else
			out = in4;
	end
endmodule

module MuxRoundKey (input logic [128:0] in1,in2, in3, in4,in5,in6,in7,in8,in9,in10,in11, in12,
				  input logic [3:0] select,
				  output logic [128:0] out
				  );
				  
	always_comb
	begin
		if(select == 4'b0000)
			out = in1;
		else if(select ==4'b0001)
			out = in2;
		else if(select ==4'b0010)
			out = in3;
		else if(select ==4'b0011)
			out = in4;
		else if(select == 4'b0100)
			out = in5;
		else if(select ==4'b0101)
			out = in6;
		else if(select ==4'b0110)
			out = in7;
		else if(select ==4'b0111)
			out = in8;
		else if(select == 4'b1000)
			out = in9;
		else if(select ==4'b1001)
			out = in10;
		else if(select ==4'b1010)
			out = in11;
		else if(select ==4'b1011)
			out = in12;
		else
			out = 128'hZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ;
	end
endmodule
				  