module temp_buffer(
  input clk,
 // input rst,
  input temp_write,
//  input temp_read,
  input [35:0] temp_in,
//  input logic [1:0] temp_read_address,
  input logic [1:0] temp_address,
  output logic [35:0] temp_out
);

  //logic [35:0] temp [3:0];
  
  
  temp_mem mem(
    .address(temp_address),
	.clock(clk),
	.data(temp_in),
	.wren(temp_write),
	.q(temp_out)
  );
  
  
  /*always_ff@(posedge clk) begin
    if(rst) begin
	//  for(int i=0;i<4;++i) begin
	  temp[0] <= 36'b0;
	  temp[1] <= 36'b0;
	  temp[2] <= 36'b0;
	  temp[3] <= 36'b0;
	  temp_out <= 36'b0;
	  
	end
	else begin
	  
	    
	//  $display("%h",temp[2'b10]);
	  if(temp_write) begin
	    temp[temp_write_address] <= temp_in;
	  end
	  //else begin
	  //  temp[temp_write_address] <= temp[temp_write_address];
	  //end
	  
	  if(temp_read) begin
	    temp_out <= temp[temp_read_address];
	  end
	  else begin
	    temp_out <= 36'b0;
	  end
    end
  end
*/
endmodule