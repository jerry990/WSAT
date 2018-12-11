module unsatisfied_clause_buffer(
  input clk,
  input rst,
  input read,
  input write,
  input [10:0] mem_count_init,
  input [10:0] address,
  inout [35:0] mem_in,
  inout [35:0] mem_out,
  output logic [11:0] mem_count,
  output logic bottom
 );
 
  logic wren;
  logic empty;
  assign bottom = empty;
  assign wren = (write)? 1'b1:1'b0;
  //logic [35:0] mem [2047:0];
  always_comb begin
    if(mem_count == 11'b0) begin
	  empty = 1'b1;
	end
	else
	  empty = 1'b0;
  end
  
  PE_mem mem(
    .address(address),
    .clock(clk),
    .data(mem_in),
    .wren(wren),
    .q(mem_out)
	 );

  
  
 
  //assign empty = (mem_count == 11'b0) ? 1'b1:1'b0;
  always_ff@(posedge clk) begin
    if(rst) begin
	  mem_count <= mem_count_init;
	end
	else begin
	  if(write) begin
	   // mem[address] <= mem_in;
		mem_count <= mem_count + 1'b1;
	  end
	  //else if(last_buffer) begin
	  //  mem_count <= mem_count - 1'b1;
	  //  mem[address] <= mem_in;
	  //end
	  else if(read) begin
	    //if(bottom) begin
		//  mem_out <= mem[0];
		//  mem_count <= mem_count;
		//end
		//else begin
	 	//  mem_out <= mem[address];
		  mem_count <= mem_count - 1'b1;
		//end
	  end
	  else begin
	    mem_count <= mem_count;
		 //mem_out <= 36'hz;
		//mem[address] <= mem[address];
	  end
	end
  end
endmodule