module bcp_processor(
  input [11:0] var_address1,
  input [11:0] var_address2,
  output logic bcp,
  output logic [11:0] bcp_var,
  output logic bcp_value
 );
  logic [`var_num:1] value_table;
  logic [`var_num:1] assign_table;
  
  always_comb begin
    case({assign_table[var_address1],assign_table[var_address2]})
		2'b00: begin
	      bcp = 1'b0;
		  bcp_var = ;
		  bcp_value = ;
	    end
	    default: begin
	      value = 1'bz;
		  offset = 2'bzz;
		  imply = 1'b0;
	    end
	endcase
  end
endmodule		
		
