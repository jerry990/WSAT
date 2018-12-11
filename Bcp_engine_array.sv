module Bcp_engine_array(




);


  genvar i;
  
  generate 
    for(i=1 ; i < 21 ; i=i+1) begin:bcp_processor
      bcp_processor bcp(
        .var_address1(),
        .var_address2(),
        .bcp(),
        .bcp_var(),
        .bcp_value()
    );
	
	end
  endgenerate
endmodule