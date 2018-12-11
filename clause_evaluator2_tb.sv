//`include "clause_evaluator.sv"
//`include "break_value_counter.sv"
//`timescale 1ns/1ns
module clause_evaluator2_tb;
  logic neg_bit1,neg_bit2,neg_bit3;

  logic clk;
  logic rst;
  logic write;
  logic [10:0] var_address1,var_address2,var_address3,flip_var_address;
  logic flip_value;   
  logic sat;
  logic out1,out2,out3;
  
  clause_evaluator2 c2(
    .clk(clk),
	.rst(rst),
    .neg_bit1(neg_bit1),
    .neg_bit2(neg_bit2),
	.neg_bit3(neg_bit3),
    .write(write),
    .var_address1(var_address1),
    .var_address2(var_address2),
	.var_address3(var_address3),
	.v1_out(out1),
    .v2_out(out2),
    .v3_out(out3),
    .flip_value(flip_value),
    .flip_var_address(flip_var_address),
	.sat(sat)
 );
  always #1 clk = ~clk;
  initial begin
    clk = 1'b0;
	rst = 1'b1;
	#2
	rst = 1'b0;
	write = 1'b0;
	var_address1 = 3'b001;
	var_address2 = 3'b010;
	var_address3 = 3'b011;
	neg_bit1 = 1'b1;
    neg_bit2 = 1'b1;
	neg_bit3 = 1'b0;
    #10
	write = 1'b1;
	
	//$readmemb("./true_value.dat",c1.var_table1,1);
	//$readmemb("./true_value.dat",c1.var_table2,1);
    //#2
	//for(int i=0;i<2048;++i) begin
	  //$display("%b",c1.var_table1[i]);
	//end
  end
  
  
  initial begin
    $fsdbDumpfile("clause_evaluator2.fsdb");
	$fsdbDumpvars(0,clause_evaluator2_tb);
    #1000
	$finish;
  end



endmodule