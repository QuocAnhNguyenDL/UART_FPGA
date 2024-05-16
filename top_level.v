module top_level
(
	input CLOCK_50,
	input Rx,
	
	output [17:0] LEDR
);

wire clk_rx;
wire [7:0] test;

assign LEDR[7:0] = test; 
assign LEDR[17] = Rx;

my_pll pll 
(
	.inclk0(CLOCK_50),
	.c0(clk_rx)
);

uart_rx rx
(
	.clk(clk_rx),
	.Rx_Serial(Rx),
	.Rx_Byte(test)
);

endmodule