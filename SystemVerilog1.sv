module clause_evaluator_array(


);

  genvar i;
  generate
    clause_evaluator(
      .clk(clk),
      .rst(rst),
  input logic neg_bit1,
  input logic neg_bit2,
  input logic neg_bit3,
  //input boot,
  input read,
  //input [2047:0] var_table_in,
  input logic evaluator_write,
  input logic valid,
  input logic [10:0] var_address1,
  input logic [10:0] var_address2,
  input logic [10:0] var_address3,
  input logic flip_value,
  input logic [10:0] flip_var_address,
  output logic [11:0] index1,
  output logic [11:0] index2,
  output logic [11:0] index3,
  output logic brk
  //output logic [2047:0] var_table_out  
);



endmodule