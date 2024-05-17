module top_level
(
	input CLOCK_50,
	input Rx,
	output Tx,
	
	output [17:0] LEDR,
	input [17:0] SW,
	input [3:0] KEY
);

wire clk_uart;

my_pll pll 
(
	.inclk0(CLOCK_50),
	.c0(clk_uart)
);

uart_rx rx
(
	.clk(clk_uart),
	.Rx_Serial(Rx),
	.Rx_Byte(LEDR[7:0])
);

uart_tx tx
(
	.clk(clk_uart),
	.Tx_Serial(Tx),
	.send(KEY[0]),
	.Tx_Byte(SW[7:0])
);

endmodule










