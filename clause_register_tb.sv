`include "clause_register.sv"
module clause_register_tb;

  logic clk;
  logic rst;
  logic reg_en;
  logic [4:0] count;
  logic [35:0] reg_in;
  logic [4:1] ucb_req,ucb_gnt;
  logic [11:0] AT_address;
  logic AT_read;
  logic [2:0] cnt;
  logic [11:0] index;
  logic [1:0] addr;
  always #1 clk = ~clk;
  
  clause_register cr(
    .clk(clk),
    .rst(rst),
    .reg_en(reg_en),
    .count(count),
    .reg_in(reg_in),
    .ucb_req(ucb_req),
    .ucb_gnt(ucb_gnt),
    .AT_address(AT_address),
    .AT_read(AT_read),
    .cnt(cnt),
    .flip_index(index),
    .temp_address(addr)
);

  initial begin
    $fsdbDumpfile("clause_register.fsdb");
	$fsdbDumpvars(0,clause_register_tb);
    #1000
	$finish;
  end

  initial begin
    clk = 1'b1;
	rst = 1'b1;
	#2
	rst = 1'b0;
	ucb_req = 4'b1000;
	#2
	ucb_req = 4'b0100;
	//#2
	//ucb_req = 4'b1010;
  end

endmodule