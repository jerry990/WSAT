module clause_evaluator(
  input clk,
  input rst,
  input logic neg_bit1,
  input logic neg_bit2,
  input logic neg_bit3,
  //input boot,
  //input read,
  //input [2047:0] var_table_in,
  input logic evaluator_write,
  input logic valid,
  input logic [10:0] var_address1,
  input logic [10:0] var_address2,
  input logic [10:0] var_address3,
  input logic [11:0] var_address1_temp,
  input logic [11:0] var_address2_temp,
  input logic [11:0] var_address3_temp,
  input logic flip_value,
  input logic [10:0] flip_var_address,
  output logic [11:0] index1,
  output logic [11:0] index2,
  output logic [11:0] index3,
  output logic v1,
  output logic v2,
  output logic brk
  //output logic [2047:0] var_table_out  
);
  
  //logic var_table1[2047:0];
  //logic var_table2[2047:0];
  logic sat1;
  logic sat2;
  //logic v1,v2;
  
  var_table clause_evaluator_var_table1(
    .address(var_address1),
    .clock(clk),
    .data(flip_value),
    .wren(evaluator_write),
    .q(v1)
	 );
	 
  var_table clause_evaluator_var_table2(
    .address(var_address2),
    .clock(clk),
    .data(flip_value),
    .wren(evaluator_write),
    .q(v2)
	 );
  
    
  always_comb begin
    
    if(valid) begin
	  //v1   = var_table1[var_address1];
	  //v2   = var_table1[var_address2];
	  brk = !((v1 ^ neg_bit1) | (v2 ^ neg_bit2));
	end
    else begin
	  brk = 1'b0;
	  //v1   = 1'b0;
	  //v2   = 1'b0;
	  sat1 = 1'b0;
	  sat2 = 1'b0;
	end
  end
  
  always_comb begin
  //  if(rst) begin
//	   index1 <= 12'b0;
 //     index2 <= 12'b0;
  //    index3 <= 12'b0;	  
//	end
  //  else begin 
	  if(valid & brk) begin
	    index1 = var_address1_temp;
	    index2 = var_address2_temp;
		index3 = var_address3_temp;
	  end
	  else begin
	    index1 = 12'b0;
		index2 = 12'b0;
	    index3 = 12'b0;
	  end
//	end
  end
  
  /*always_ff@(posedge clk) begin
    if(rst) begin
	  for(int i=0;i<2048;i++) begin
	    var_table1[i] <= var_table_in[i];
		var_table2[i] <= var_table_in[i];
		//var_table_out <= 2048'b0;
	  end
	end
	else if(boot) begin
	  for(int i=0;i<2048;i++) begin
	    var_table1[i] <= var_table_in[i];
	  end
	end
	//else if(read) begin//for test
	//  for(int i=0;i<2048;i++) begin
	//    var_table_out[i] <= var_table1[i];
	//  end
	//end
	else begin
	  if(evaluator_write) begin
	    var_table1[flip_var_address] <= ~var_table1[flip_var_address];
		var_table2[flip_var_address] <= ~var_table2[flip_var_address];
	  end
	  else begin
	    var_table1[flip_var_address] <= var_table1[flip_var_address];
		var_table2[flip_var_address] <= var_table2[flip_var_address];
	  end
	end
  end
  */
endmodule