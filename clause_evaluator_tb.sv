`include "clause_evaluator.sv"
//`include "break_value_counter.sv"
module clause_evaluator_tb;


  logic clk;
  logic rst;
  logic AT_read;
  logic [11:0] AT_address;
  logic [19:0] Mask;
  
  clause_evaluator c1(
    .neg_bit1(),
    .neg_bit2(),
    .read1(),
    .read2(),
    .write(),
    .valid(),
    .var_address1(),
    .var_address2(),
    .flip_value(),
    .flip_var_address(),
	.brk()
 );
  always #1 clk = ~clk;
  initial begin
    clk = 1'b0;
	rst = 1'b1;
	#2
	rst = 1'b0;
	$readmemb("./true_value.dat",c1.var_table1,1);
	$readmemb("./true_value.dat",c1.var_table2,1);
    #2
	//for(int i=0;i<2048;++i) begin
	  //$display("%b",c1.var_table1[i]);
	//end
  end
  
  
  initial begin
    $fsdbDumpfile("clause_evaluator.fsdb");
	$fsdbDumpvars(0,clause_evaluator_tb);
    #1000
	$finish;
  end



endmodule