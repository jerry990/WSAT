`include "table.sv"

module table_tb;


  logic clk;
  logic rst;
  logic AT_read;
  logic [11:0] AT_address;
  logic [19:0] Mask;
  logic boot;
  logic sat;
  logic reg_en;
  logic [35:0] temp_out [20:1];
  table_test t(
    .clk(clk),
    .rst(rst),
    .reg_en(reg_en),
    .boot(boot),
    .temp_out(temp_out[20:1]) 
  );
  always #1 clk = ~clk;
  initial begin
    clk = 1'b0;
	rst = 1'b1;
	  t.read = 1'b0;
	  
	#2
	rst = 1'b0;
	t.AT.address_mem[0] = 11'bz;
	$readmemh("./addr.dat",t.AT.address_mem,1);
	$readmemb("./mask.dat",t.AT.Mask_mem,1);
	$readmemh("./clause_table.dat",t.CT.mem,0);
	$readmemb("./true_value.dat",t.value_mem,1);
	$readmemh("./unsatisfied_clause.dat",t.ucb.mem,0);
    boot = 1'b1;
	//$display("%b",t.value_mem[3]);
	
	for(int i=0;i<2048;++i)begin
	  t.var_table_in[i] <= t.value_mem[i];
	end
  
	//t.temp[1].uut.temp[1] = 36'h20;
    #2
	//$display("%b",t.var_table_in[3]);
	boot = 1'b0;
	reg_en = 1'b1;
    //$display("%h",t.var_table_in[1]);
	//AT_read = 1'b1;
	//AT_address = 11'h20;
	//#2
	//AT_read = 1'b1;
	//AT_address = 11'h30;
	
	//for(int i=0 ; i<1000 ;++i) begin
	//  #2
	//  AT_address = i+10;
	  
	//end
	
    //$display("%h",t.temp[1].uut.temp[1]);
  end
  
  
  initial begin
    $fsdbDumpfile("table.fsdb");
	$fsdbDumpvars(0,table_tb);
	
    #100
	t.read = 1'b1;
	#20  
	//for(int i=1;i<601;++i) begin
	//  $display("%b",t.evaluator[1].ce.var_table_out[i]);
	  //t.value_mem[i] <= t.evaluator.ce[i].var_table1[1];
	//end
	$finish;
  end



endmodule