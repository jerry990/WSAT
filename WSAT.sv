`include "./NOC_size9/NoC.sv"
`include "./table/table.sv"
`include "./table/address_translation_table.sv"
`include "./table/clause_table.sv"
`include "./table/temp_buffer.sv"
`include "./table/break_value_counter.sv"
`include "./table/clause_evaluator.sv"
`include "./table/unsatisfied_clause_buffer.sv"
`include "./table/clause_register.sv"
module WSAT(
  input clk,
  input rst,
  input boot,
  output logic [4:1] sat  
);

  logic [4:1] cr_gnt;
  logic [4:1] cr_req;
  logic [35:0] unsat_out [4:1];
  logic [10:0] PE_address_in [4:1];
  logic [2047:0] var_table_in [4:1];
  logic [35:0] PE_mem_in [4:1];
  logic [35:0] temp_out [20:1];
  logic [4:1] ucb_req,ucb_gnt;
  
  table_test tt(
    .clk(clk),
    .rst(rst),
    .boot(boot),
	.ucb_req({ucb_req[4],ucb_req[3],ucb_req[2],ucb_req[1]}),
	.reg_in(),
	.ucb_gnt({ucb_gnt[4],ucb_gnt[3],ucb_gnt[2],ucb_gnt[1]}),
    .temp_out_noc({
	  temp_out[20],temp_out[19],temp_out[18],temp_out[17],
	  temp_out[16],temp_out[15],temp_out[14],temp_out[13],
	  temp_out[12],temp_out[11],temp_out[10],temp_out[9],
      temp_out[8],temp_out[7],temp_out[6],temp_out[5],
	  temp_out[4],temp_out[3],temp_out[2],temp_out[1]})
  );
  
/*  NoC noc(
    .clk(clk),
    .rst(rst),
    .boot(boot),
    .var_table_in({var_table_in[4],var_table_in[3],var_table_in[2],var_table_in[1]}),
    .PE_mem_in ({PE_mem_in[4],PE_mem_in[3],PE_mem_in[2],PE_mem_in[1]}),
    .PE_address_in ({PE_address_in[4],PE_address_in[3],PE_address_in[2],PE_address_in[1]}),
    .cr_gnt(cr_gnt[4:1]),
    .cr_req(cr_req[4:1]),
    .unsat_out ({unsat_out[4],unsat_out[3],unsat_out[2],unsat_out[1]}),
    .sat(sat[4:1]),
  );

  */
endmodule