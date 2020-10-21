`timescale 1ns / 1ns

module tb;
parameter SIZE = 14, DEPTH = 1024;

reg clk;
initial begin
  clk = 1;
  forever
	  #5 clk = ~clk;
end

reg rst;
initial begin
  rst = 1;
  repeat (10) @(posedge clk);
  rst <= #1 0;
  repeat (600) @(posedge clk);
  $display("Content of address 600 is %d.", inst_blram.memory[600]);
  $finish;
end

wire wrEn;
wire [SIZE-1:0] addr_toRAM;
wire [31:0] data_toRAM, data_fromRAM;

VerySimpleCPU inst_VerySimpleCPU(
  .clk(clk),
  .rst(rst),
  .wrEn(wrEn),
  .data_fromRAM(data_fromRAM),
  .addr_toRAM(addr_toRAM),
  .data_toRAM(data_toRAM)
);

blram #(SIZE, DEPTH) inst_blram(
  .clk(clk),
  .rst(rst),
  .i_we(wrEn),
  .i_addr(addr_toRAM),
  .i_ram_data_in(data_toRAM),
  .o_ram_data_out(data_fromRAM)
);

endmodule

module blram(clk, rst, i_we, i_addr, i_ram_data_in, o_ram_data_out);

parameter SIZE = 10, DEPTH = 1024;

input clk;
input rst;
input i_we;
input [SIZE-1:0] i_addr;
input [31:0] i_ram_data_in;
output reg [31:0] o_ram_data_out;

reg [31:0] memory[0:DEPTH-1];

always @(posedge clk) begin
  o_ram_data_out <= #1 memory[i_addr[SIZE-1:0]];
  if (i_we)
		memory[i_addr[SIZE-1:0]] <= #1 i_ram_data_in;
end 

initial begin
memory[0] = 32'h808201f4;
memory[1] = 32'h809601f4;
memory[2] = 32'ha0824212;
memory[3] = 32'h80820258;
memory[4] = 32'h60820209;
memory[5] = 32'hc08e8208;
memory[6] = 32'h80960209;
memory[7] = 32'h10848001;
memory[8] = 32'h10870001;
memory[9] = 32'h808c021c;
memory[10] = 32'h708c000a;
memory[11] = 32'hc0910230;
memory[12] = 32'hd080c000;
memory[13] = 32'h80960208;
memory[14] = 32'hd003c00e;
memory[15] = 32'h0;
memory[500] = 32'h33;
memory[501] = 32'h6;
memory[502] = 32'ha;
memory[503] = 32'h15;
memory[504] = 32'h3;
memory[505] = 32'h32;
memory[506] = 32'h9;
memory[507] = 32'hc;
memory[508] = 32'h2;
memory[509] = 32'h20;
memory[515] = 32'h2;
memory[520] = 32'h0;
memory[521] = 32'h0;
memory[530] = 32'h1f5;
memory[540] = 32'h0;
memory[560] = 32'h0;
memory[570] = 32'h7;
memory[580] = 32'hd;
memory[600] = 32'h0;
end

endmodule
