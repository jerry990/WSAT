`include "break_value_counter.sv"
module break_value_counter_tb;
  logic clk;
  logic rst;
  logic en;
  logic [19:0] brk;
  logic [4:0] count;
  always #1 clk = ~clk;
  break_value_counter bvc(
    .clk(clk),
    .rst(rst),
//	.break_en(en),
    .brk(brk),
	.count(count)
 //   .select()   
  );

  initial begin
    clk = 1'b0;
    rst = 1'b1;
    #2
    rst = 1'b0;
    //en  = 1'b1;
    brk = 20'b10;
    #2
    brk = 20'b111;
    #2 
    brk = 20'b1111;
	#2
	brk = 20'b0101010101010110;
    //#4
   // en = 1'b0;	
  end

  initial begin
    $fsdbDumpfile("break_value_counter.fsdb");
    $fsdbDumpvars(0,break_value_counter_tb);
    #100
    $finish;
  end

endmodule