/************************************************************************
					ECE 385 Final Project: Super Gene Bros

					Peter Hevrdejs & Sean McGee Fall 2019

							  University of Illinois
************************************************************************/

module Game_top (
	input  logic        CLOCK_50,
	input  logic [1:0]  KEY,
	output logic [7:0]  LEDG,
	output logic [17:0] LEDR,
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

// Python,Coin, and Score data to show on Hex displays
logic [7:0] Python_Input; // Input Verification Leftmost Displays Hex7 & Hex 6
logic [7:0] Coins; //Displays Hex5 & Hex 4 up to 99 coins then after is 1 up
logic [15:0] Score; //Total Score of the game Hex 3 - Hex 0

// Instantiation of Qsys design
Game_soc Game_qsystem (
	.clk_clk(CLOCK_50),								// Clock input
	.reset_reset_n(KEY[0]),							// Reset key
	.aes_export_export_data(AES_EXPORT_DATA),	// Exported data
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


// Display the first 4 and the last 4 hex values of the received message
hexdriver hexdrv0 (
	.In(Score[3:0]),
   .Out(HEX0)
);
hexdriver hexdrv1 (
	.In(Score[7:4]),
   .Out(HEX1)
);
hexdriver hexdrv2 (
	.In(Score[11:8]),
   .Out(HEX2)
);
hexdriver hexdrv3 (
	.In(Score[15:12]),
   .Out(HEX3)
);
hexdriver hexdrv4 (
	.In(Coins[3:0]),
   .Out(HEX4)
);
hexdriver hexdrv5 (
	.In(Coins[7:4]),
   .Out(HEX5)
);
hexdriver hexdrv6 (
	.In(Python_Input[3:0]),
   .Out(HEX6)
);
hexdriver hexdrv7 (
	.In(Python_Input[7:4]),
   .Out(HEX7)
);

endmodule
