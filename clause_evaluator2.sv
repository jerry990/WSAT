module clause_evaluator2(
  input clk,
  input rst,
  input logic neg_bit1,
  input logic neg_bit2,
  input logic neg_bit3,
  input logic write,
  input logic [10:0] var_address1,
  input logic [10:0] var_address2,
  input logic [10:0] var_address3,
  input logic [10:0] flip_var_address,
  input logic flip_value,
  output logic v1_out,
  output logic v2_out,
  output logic v3_out,
  output logic sat   
);

  assign v1_out = v1;
  assign v2_out = v2;
  assign v3_out = v3;
  
  logic sat1,sat2,sat3;
  logic v1,v2,v3;
  logic [10:0] in1,in2,in3;
  
  var_table PE_clause_evaluator2_var_table1(
    .address(in1),
    .clock(clk),
    .data(flip_value),
    .wren(write),
    .q(v1)
	 );
	 
  var_table PE_clause_evaluator2_var_table2(
    .address(in2),
    .clock(clk),
    .data(flip_value),
    .wren(write),
    .q(v2)
	 );
  
  var_table PE_clause_evaluator2_var_table3(
    .address(in3),
    .clock(clk),
    .data(flip_value),
    .wren(write),
    .q(v3)
	 );  
  
  
  always_comb begin 	
    sat = (v1 ^ neg_bit1)|(v2 ^ neg_bit2)|(v3 ^ neg_bit3);
  end
  
  always_comb begin
    if(write) begin
	   in1 <= flip_var_address;
	   in2 <= flip_var_address;
	   in3 <= flip_var_address;
	 end
	 else begin
	   in1 <= var_address1;
	   in2 <= var_address2;
	   in3 <= var_address3;
	 
	 end
  
  end
  
  
endmodule