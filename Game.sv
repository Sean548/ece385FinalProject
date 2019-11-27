/************************************************************************
					ECE 385 Final Project: Super Gene Bros

					Peter Hevrdejs & Sean McGee Fall 2019

							  University of Illinois
************************************************************************/

module Game (
	input  logic        CLK,
	input  logic 		  RESET,
	output logic [8:0]  LEDG,
	output logic [17:0] LEDR,
	input  logic [1:0]  Dpad,
	input  logic 		  Button_A,
	input  logic		  Button_B,
	input  logic        Pause,
	
	output logic [6:0]  HEX0,
	output logic [6:0]  HEX1,
	output logic [6:0]  HEX2,
	output logic [6:0]  HEX3,
	output logic [6:0]  HEX4,
	output logic [6:0]  HEX5,
	output logic [6:0]  HEX6,
	output logic [6:0]  HEX7,
	
	output logic [12:0] DRAM_ADDR,
	output logic [1:0]  DRAM_BA,
	output logic        DRAM_CAS_N,
	output logic        DRAM_CKE,
	output logic        DRAM_CS_N,
	inout  logic [31:0] DRAM_DQ,
	output logic [3:0]  DRAM_DQM,
	output logic        DRAM_RAS_N,
	output logic        DRAM_WE_N,
	output logic        DRAM_CLK
);

logic [7:0] Coins; //Displays Hex5 & Hex 4 up to 99 coins then after is 1 up
logic [15:0] Score; //Total Score of the game Hex 3 - Hex 0

// Instantiation of Qsys design
Game_soc Game_qsystem (
	.clk_clk(CLK),								// Clock input
	.pause_led_wire_export(LEDG[7]),				// Pause LED
	.reset_reset_n(RESET),							// Reset key
	.rpi_dpad_wire_export(Dpad),					// GPIO D-pad
	.rpi_key_wire_export(Button),	    		   // GPIO Keypress
	.rpi_pause_wire_export(Pause),						// GPIO Pause
	.sdram_wire_addr(DRAM_ADDR),					// sdram_wire.addr
	.sdram_wire_ba(DRAM_BA),						// sdram_wire.ba
	.sdram_wire_cas_n(DRAM_CAS_N),				// sdram_wire.cas_n
	.sdram_wire_cke(DRAM_CKE),						// sdram_wire.cke
	.sdram_wire_cs_n(DRAM_CS_N),					// sdram.cs_n
	.sdram_wire_dq(DRAM_DQ),						// sdram.dq
	.sdram_wire_dqm(DRAM_DQM),						// sdram.dqm
	.sdram_wire_ras_n(DRAM_RAS_N),				// sdram.ras_n
	.sdram_wire_we_n(DRAM_WE_N),					// sdram.we_n
	.sdram_clk_clk(DRAM_CLK)						// Clock out to SDRAM
);


Reg_Dpad Dpad_Reg(
		.Clk(CLK),
		.Reset(RESET),
		.Reg_In(Dpad),
		.Reg_Out(Dpad_data)
		);

Reg_Button Button_A_Reg(
		.Clk(CLK),
		.Reset(RESET),
		.Reg_In(Button_A),
		.Reg_Out(Button_A_data)
		);

Reg_Button ButtonB_Reg(
		.Clk(CLK),
		.Reset(RESET),
		.Reg_In(Button_B),
		.Reg_Out(Button_B_data)
		);

Reg_Button Pause_Reg(
		.Clk(CLK),
		.Reset(RESET),
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
