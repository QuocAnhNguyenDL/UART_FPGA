module uart_tx
(
	input 			 	clk,
	output 				Tx_Serial,
	input			 		send,
	input		[7:0] 	Tx_Byte
);

localparam IDLE	 	= 3'b000;
//localparam START 		= 3'b001;
localparam T_DATA 	= 3'b010;
localparam STOP 		= 3'b011;
localparam CLEAN		= 3'b100;

localparam CLKS_PER_BIT = 87;

reg Tx_Data = 1'b1;
reg send_latch;
reg [6:0] clk_count = 7'b0;

reg [2:0] bit_index = 3'b000;
reg [2:0] state = 3'b000;

always @(posedge clk)
begin
	send_latch <= send;
end

assign Tx_Serial = Tx_Data;

always @(posedge clk)
begin
	case(state)
	
		IDLE :
		begin
			bit_index <= 1'b0;
			clk_count <= 7'b0;
			if(send_latch == 1'b1 && send == 1'b0) 
			begin
				Tx_Data <= 1'b0;
				state <= T_DATA;
			end
			else state <= IDLE;
		end
		
		T_DATA :
		begin
			if(clk_count < CLKS_PER_BIT - 1)
			begin
				clk_count <= clk_count + 1;
				state <= T_DATA;
			end
			else
			begin
				clk_count <= 0;
				Tx_Data <= Tx_Byte[bit_index];
				
				if(bit_index < 7)
				begin
					bit_index <= bit_index + 1;
					state <= T_DATA;
				end
				else
				begin
					bit_index <= 0;
					clk_count <= 7'b0;
					state <= STOP;
				end
			end
		end
		
		STOP :
		begin
			if(clk_count < CLKS_PER_BIT - 1)
			begin
				clk_count <= clk_count + 1;
				state <= STOP;
			end
			else
			begin
				clk_count <= 7'b0;
				Tx_Data = 1'b1;
				state <= CLEAN;
			end
		end
		
		CLEAN :
		begin
			state <= IDLE;
		end
		
	endcase
end

endmodule












