module uart_rx
(
	input 		 clk,
	input 		 Rx_Serial,
	output [7:0] Rx_Byte
);

localparam IDLE	 	= 3'b000;
localparam START 		= 3'b001;
localparam R_DATA 	= 3'b010;
localparam STOP 		= 3'b011;
localparam CLEAN		= 3'b100;

parameter CLKS_PER_BIT = 87 ; //clk = 10 Mhz , baudrate = 115200

reg Rx_Data_R = 1'b1;
reg Rx_Data = 1'b1;
reg [7:0] buffer;

reg [6:0] clk_count = 0;
reg [2:0] state = IDLE;

reg [2:0] bit_index = 0;

assign Rx_Byte = buffer;

always @(posedge clk)
begin
	Rx_Data_R <= Rx_Serial;
	Rx_Data <= Rx_Data_R;
end

always @(posedge clk)
begin
	case(state)
		
		IDLE:
		begin
			bit_index <= 1'b0;
			clk_count <= 7'b0;
			
			if(Rx_Data == 1'b0) state <= START;
			else					  state <= IDLE ;
		end
		
		START:
		begin
			if(clk_count == (CLKS_PER_BIT - 1) / 2)
			begin
				if(Rx_Data == 1'b0)
				begin
					clk_count <= 7'b0;
					state <= R_DATA;
				end
				else
				begin
					state <=  IDLE;
				end
			end
			else
			begin
				clk_count <= clk_count + 1;
				state <= START;
			end
		end
		
		R_DATA:
		begin
			if(clk_count < CLKS_PER_BIT - 1)
			begin
				clk_count <= clk_count + 1;
				state <= R_DATA;
			end
			else
			begin
				buffer[bit_index] = Rx_Data;
				clk_count <= 0;
				
				if(bit_index < 7)
				begin
					bit_index <= bit_index + 1;
					state <= R_DATA;
				end
				else
				begin
					bit_index <= 0;
					state <= STOP;
				end
			end
		end
		
		STOP:
		begin
			if(clk_count < CLKS_PER_BIT - 1)
			begin
				clk_count <= clk_count + 1;
				state <= STOP;
			end
			else
			begin
				clk_count <= 0;
				state <= CLEAN;
			end
		end
		
		CLEAN:
		begin
			state <= IDLE;
		end
		
		default: 
			state <= IDLE;
	endcase
end	


endmodule








