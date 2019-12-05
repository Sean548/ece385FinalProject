//module testbench();
//
//timeunit 100ns;
//
//timeprecision 1ns;
//
//
//logic [7:0] READ_ADDR = 8'b00000000;
//logic Clk = 0;
//logic [3:0] DATA_OUT;
//						
//ROM_Mario toplevel(.*);
//
//always begin : CLOCK_GENERATION
//#1 Clk = ~Clk;
//end
//
//initial begin : CLOCK_INITIALIZATION
//	Clk = 0;
//	READ_ADDR = 8'b00000000;
//end
//
//initial begin : TEST
//#2 READ_ADDR = 8'b01100110;
//#2 READ_ADDR = 8'b01010001;
//#2 READ_ADDR = 8'b11011100;
//#2 READ_ADDR = 8'b00011010;
//
//
//end
//endmodule

module testbench();

timeunit 100ns;

timeprecision 1ns;

logic Is_Mario;
//logic Is_Block1;
//logic Is_Gomba1;
//logic [9:0] DrawX = 9'b000000000;
//logic [9:0] DrawY = 9'b000000000;
//logic [9:0] mario_distx = 9'b000000000;
//logic [9:0] mario_disty = 9'b000000000;
logic CLK = 0;
logic [7:0] VGA_R;
logic [7:0] VGA_G;
logic [7:0] VGA_B;
logic [3:0] Mario_in;
logic [7:0] ADDRESS;
logic [7:0] Red;
logic [7:0] Green;
logic [7:0] Blue;
						
color_mapper toplevel(.*);

always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin : CLOCK_INITIALIZATION
	CLK = 0;
end

initial begin : TEST
#1 Is_Mario =1'b1;
#1 ADDRESS = 8'd27s
#2 READ_ADDR = 8'b01100110;
#2 READ_ADDR = 8'b01010001;
#2 READ_ADDR = 8'b11011100;
#2 READ_ADDR = 8'b00011010;


end
endmodule

