
module VerySimpleCPU(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

parameter SIZE = 14;

input clk, rst;
input wire [31:0] data_fromRAM;
output reg wrEn;
output reg [SIZE-1:0] addr_toRAM;
output reg [31:0] data_toRAM;

reg  [3:0]  state_current , state_next;
reg [SIZE -1:0]  pc_current , pc_next;
reg  [31:0]  iw_current , iw_next; 
reg  [31:0]  register_current , register_next;

always@(posedge  clk) begin

	if(rst) begin
		state_current  <= 0;
		pc_current  <= 14'b0;
		iw_current  <= 32'b0;
		register_current  <= 32'b0;
	end

	else  begin
		state_current  <= state_next;
		pc_current  <= pc_next;
		iw_current  <= iw_next;
		register_current  <= register_next;
	end
end

always@ (*)  begin

	state_next = state_current;
	pc_next = pc_current;
	iw_next = iw_current;
	register_next = register_current;
	wrEn = 0;
	addr_toRAM = 0;
	data_toRAM = 0;
	case(state_current)
		0: begin
			pc_next = 0;
			iw_next = 0;
			register_next = 0;
			state_next = 1;
		end
		1: begin
			addr_toRAM = pc_current;				
			state_next = 2;
		end
		2: begin
				iw_next = data_fromRAM;
				case(data_fromRAM [31:28])
					{3'b000 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b000 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b001 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b001 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b010 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b010 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b011 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b011 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b111 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b111 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b100 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b100 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b101 ,1'b0}: begin
					addr_toRAM = data_fromRAM [13:0];		
					state_next = 3;
					end
					{3'b101 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b110 ,1'b0}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
					{3'b110 ,1'b1}: begin
					addr_toRAM = data_fromRAM [27:14];		
					state_next = 3;
					end
				default: begin
					pc_next = pc_current;
					state_next = 1;
					end
				endcase
		end		
		3: begin
			case(iw_current [31:28])
				{3'b101 ,1'b0}: begin	
					addr_toRAM = data_fromRAM;
					state_next = 4;
					
				end
				default: begin
					register_next = data_fromRAM;
					addr_toRAM = iw_current [13:0];
					state_next = 4;
				end
			endcase
		end
			
		4: begin
			case(iw_current [31:28])
				{3'b000 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM + register_current;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b000 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = iw_current [13:0] + register_current;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b001 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = ~(data_fromRAM & register_current);
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b001 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = ~(iw_current [13:0] & register_current);
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b010 ,1'b0}: begin									   
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (data_fromRAM < 32) ? (register_current >> data_fromRAM) : (register_current << data_fromRAM-32);
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b010 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (iw_current [13:0] < 32) ? (register_current >> iw_current [13:0]) : (register_current << iw_current [13:0]-32);
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b011 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = register_current;
					data_toRAM = (register_current < data_fromRAM) ? 1 : 0;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b011 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = (register_current < iw_current [13:0]) ? 1 : 0;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b111 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM * register_current;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b111 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = iw_current [13:0] * register_current;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b100 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b100 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = iw_current [13:0];
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b101 ,1'b0}: begin									
					wrEn = 1;
					addr_toRAM = iw_current [27:14];
					data_toRAM = data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b101 ,1'b1}: begin									
					wrEn = 1;
					addr_toRAM = register_current;
					data_toRAM = data_fromRAM;
					pc_next = pc_current + 1'b1;
					state_next = 1;
				end
				{3'b110 ,1'b0}: begin									
					pc_next = (data_fromRAM == 0) ? register_current : (pc_current + 1);
					state_next = 1;
				end
				{3'b110 ,1'b1}: begin									
					pc_next = iw_current [13:0] + register_current;
					state_next = 1;
				end
			endcase
		end
	endcase
end
endmodule
