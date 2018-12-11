//`include "define.svh"
module Decision_engine(
  input clk,
  input rst,
  output logic [11:0] AT_address,
  output dp_sat,
  output dp_unsat
);

  
  
  logic [4:0] value_counter;
  logic [1:0] state;
  
  assign dp_sat = (value_counter == `var_num+1'b1) ? 1'b1:1'b0; 
  assign dp_unsat = (value_counter == 5'b0) ? 1'b1:1'b0;
  
  parameter idle = 2'b00,
            decision = 2'b01;
  
  always_ff@(posedge clk) begin
    if(rst) begin
	  value_reg  <= 20'b0;
	  assign_reg <= 20'b0;
	  value_counter <= 5'b0;
	end
    else begin
	  case(state) 
	    idle: begin
		  if(value_counter != `var_num) begin
		    value_counter <= value_counter + 1'b1;    
		    state <= decision;
		  end
		  else if(value_counter == `var_num+1'b1) begin
		    state <= idle;
			
		  end
		end
		decision: begin
		  value_reg[value_counter] <= 1'b0;
	      assign_counter[value_counter] <= 1'b1;
		  state <= idle;
		end
	  endcase
      

    end	
  end
  
endmodule
