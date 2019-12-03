module ROM_Mario( input [12:0] READ_ADDR,
						input Clk,
						output logic [1:0] DATA_OUT
					  );

logic [1:0] mem [0:6911]; //logic[<Number of Bits per address - 1> : 0] mem [0 : <Number of Addresses - 1>];

initial 
begin 
	$readmemb("txt_files/Mario.txt",mem);
end 

always_ff @ (posedge Clk)
begin
	DATA_OUT <= mem[READ_ADDR];
end 


endmodule 
