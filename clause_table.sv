module clause_table(
  input clk,
  input read,
  input write,
  input [10:0] address,
  input [479:0] in,
  output logic [23:0] out1,
  output logic [23:0] out2,
  output logic [23:0] out3,  
  output logic [23:0] out4,
  output logic [23:0] out5,
  output logic [23:0] out6,
  output logic [23:0] out7,
  output logic [23:0] out8,
  output logic [23:0] out9,  
  output logic [23:0] out10,
  output logic [23:0] out11,
  output logic [23:0] out12,
  output logic [23:0] out13,
  output logic [23:0] out14,
  output logic [23:0] out15,  
  output logic [23:0] out16,
  output logic [23:0] out17,
  output logic [23:0] out18,
  output logic [23:0] out19,
  output logic [23:0] out20//first
);

  //logic [479:0] mem [2047:0];
  
  clause_mem mem(
    .address_a(address),
	 .clock(clk),
	 .data_a(in),
	 .rden_a(read),
	 .wren_b(write),
	 .q_a({out1,out2,out3,out4,out5,out6,out7,out8,out9,out10,out11,out12,out13,out14,out15,out16,out17,out18,out19,out20})
  );
endmodule