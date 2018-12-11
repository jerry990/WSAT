`include "Decision_engine.sv"

module DPll_sat(
  input clk,
  input rst,
  

  output dp_sat,
  output dp_unsat,   
  output logic [11:0] AT_address


);


  Decision_engine de(
    .clk(clk),
    .rst(rst),
    .AT_address(),
    .dp_sat(dp_sat),
    .dp_unsat(dp_unsat)
  );





endmodule