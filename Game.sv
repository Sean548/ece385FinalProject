  
/************************************************************************
					ECE 385 Final Project: Super Gene Bros
					Peter Hevrdejs & Sean McGee Fall 2019
							  University of Illinois
************************************************************************/

module Game (
	input  logic        CLK,
	input  logic 		  RESET,
	output logic [8:0]  LEDG,
	input  logic [1:0]  Dpad,
	input  logic 		  Button_A,
	input  logic		  Button_B,
	input  logic        Pause,
	
	output logic [7:0]  VGA_R,        //VGA Red
                       VGA_G,        //VGA Green
                       VGA_B,        //VGA Blue
   output logic        VGA_CLK,      //VGA Clock
                       VGA_SYNC_N,   //VGA Sync signal
                       VGA_BLANK_N,  //VGA Blank signal
                       VGA_VS,       //VGA virtical sync signal
                       VGA_HS,       //VGA horizontal sync signal
	
	output logic [6:0]  HEX0, HEX1, HEX2, HEX3,
	output logic [6:0]  HEX4, HEX5, HEX6, HEX7,
	
	input	 logic [15:0] SRAM_Data, //	Read-Only
	output logic [19:0] SRAM_ADDR, // Address For the SRAM
	output logic CE, UB, LB, OE, WE // SRAM Controls 
	
	
);
logic [1:0] Dpad_data;
logic Button_A_data, Button_B_data, Pause_data;
logic [7:0] Coins; //Displays Hex5 & Hex 4 up to 99 coins then after is 1 up
logic [15:0] Score; //Total Score of the game Hex 3 - Hex 0
logic INIT_wire;	//When you raise it high, signifies the start and has set up time
logic INIT_FINISH_wire; //output to signify set up time has completed
logic adc_full_wire; //raised when a full 32bit sample has been read
logic [31:0] ADCDATA_wire; //the ouput of the 32bit sample
logic data_over_wire; //when sample correctly loaded into DAC high,, when begin read_out this is set Low
logic [9:0] DrawX, DrawY;
logic Is_Mario;

vga_clk vga_clk_instance(
		.inclk0(CLK),
		.c0(VGA_CLK)
		);
		
VGA_controller VGA_controller(
		.Clk(CLK),
		.Reset(~RESET),
		.VGA_CLK(VGA_CLK),
		.DrawX,
		.DrawY,
		.VGA_HS,
		.VGA_VS,
		.VGA_BLANK_N,
		.VGA_SYNC_N
		);
		
color_mapper Color_Instance(
		.Is_Mario(Is_Mario),
		.DrawX(DrawX),
		.DrawY(DrawY),
		.VGA_R(VGA_R),
		.VGA_G(VGA_G),
		.VGA_B(VGA_B)
		);

Mario Mario(
		.Clk(CLK),
		.Reset(~RESET),
		.frame_clk(VGA_VS),
		.DrawX,
		.DrawY,
		.keymove(Dpad_data),
		.keypress_B(Button_B_data),
		.keypress_A(Button_A_data),
		.pause(Pause),
		.Size(1'b0),
		.Is_Mario
		);
		
		
audio_interface audio_instance(
		.Clk(CLK),
		.Reset(~RESET),
		.LDATA(SRAM_Data), //input the sound data
		.RDATA(SRAM_Data),
		.INIT(INIT_wire), //
		.INIT_FINISH(INIT_FINISH_wire),
		.adc_full(adc_full_wire),
		.data_over(data_over_wire),
		.ADCDATA(ADCDATA_wire)
		);
		
//Sound	Sound_SM(
//		.Clk(CLK),
//		.Reset(RESET),
//		.Initialize(INIT_wire),
//		.Initialize_Done(INIT_FINISH_wire),
//		.Full_Samp_Read(adc_full_wire), //dont worry about this one
//		.A2D_SampOut(ADCDATA_wire), // dont worry about this one
//		.Digital_Out(data_over_wire) //this is the little guy we will be using (digital sound file --> analog output)
//		);
		
Reg_Dpad Dpad_Reg(
		.Clk(CLK),
		.Reset(~RESET),
		.Reg_In(Dpad),
		.Reg_Out(Dpad_data)
		);

Reg_Button Button_A_Reg(
		.Clk(CLK),
		.Reset(~RESET),
		.Reg_In(Button_A),
		.Reg_Out(Button_A_data)
		);

Reg_Button ButtonB_Reg(
		.Clk(CLK),
		.Reset(~RESET),
		.Reg_In(Button_B),
		.Reg_Out(Button_B_data)
		);

Reg_Button Pause_Reg(
		.Clk(CLK),
		.Reset(~RESET),
		.Reg_In(Pause),
		.Reg_Out(Pause_data)
		);




// Display the first 4 and the last 4 hex values of the received message
HexDriver hexdrv0 (
	.In0(Score[3:0]),
   .Out0(HEX0)
);
HexDriver hexdrv1 (
	.In0(Score[7:4]),
   .Out0(HEX1)
);
HexDriver hexdrv2 (
	.In0(Score[11:8]),
   .Out0(HEX2)
);
HexDriver hexdrv3 (
	.In0(Score[15:12]),
   .Out0(HEX3)
);
HexDriver hexdrv4 (
	.In0(Pause),
   .Out0(HEX4)
);
HexDriver hexdrv5 (
	.In0(Button_B),
   .Out0(HEX5) 
);
HexDriver hexdrv6 (
	.In0(Button_A),
   .Out0(HEX6)
);
HexDriver hexdrv7 (
	.In0(Dpad),
   .Out0(HEX7)
);

endmodule


// Comments & Concerns
// No frame buffer
// music sram
// pixels onchip
