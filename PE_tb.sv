`timescale 1ns/1ns
`define cycle 10
module PE_tb;
  logic clk,rst;
  logic fifo_gnt,fifo_req,cr_gnt,cr_req;
  logic wrie;
  logic [35:0] packetin;
  logic [10:0] flip_var_address;
  logic fifo_empty;
  logic [11:0] mem_count_init;
  logic [35:0] out;
  PE p(
    .clk(clk),
    .rst(rst),
    .fifo_gnt(fifo_gnt),
    .write_var_table(write),//for var_table
    .flip_var_address(flip_var_address),
    .fifo_empty(fifo_empty),
    .mem_count_init(mem_count_init),
    .cr_gnt(cr_gnt),
    .packetin(packetin),
    .out(out),
    .cr_req(cr_req),
    .fifo_req(fifo_req),
    .sat()
  
  );     
  always #`cycle clk = ~clk;
  initial begin
    clk = 1'b0;
    rst = 1'b1;
	mem_count_init = 11'd20;
	#(`cycle + `cycle)
	rst = 1'b0;

  end  
  initial begin
    $fsdbDumpfile("PE.fsdb");
	$fsdbDumpvars(0,PE_tb);    
	#(`cycle*100)
    $finish;	
  
  end


endmodule