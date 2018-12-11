module address_translation_table(
  input clk,
  input rst,
  input read,
  input write,
  input [11:0] address,
  input [10:0] CT_address_in,
  input [19:0] Mask_in,
  output logic [10:0] CT_address,
  output logic CT_read,
  output logic [19:0] Mask
);
  //logic [10:0] address_mem [4095:0];
  //logic [19:0] Mask_mem [4095:0];
  assign CT_read = 1'b1;
  addr addr_mem(
    .address(address),
	.clock(clk),
	.data(),
	.wren(!read),
	.q(CT_address)
	);
	
  mask mask_mem(
	.address(address),
	.clock(clk),
	.data(),
	.wren(!read),
	.q(Mask)
	);
  
  
  
  /*always_ff@(posedge clk) begin
    if(rst) begin
      for(int i=0 ; i < 4096 ; i++) begin
        address_mem[i] <= 11'b0;
	    Mask_mem[i] <= 20'b0;
		CT_read <= 1'b0;
      end
	  Mask <= 20'b0;
	  
    end
    else begin
	  if(write) begin
	    address_mem[address] <= CT_address_in;
		Mask_mem[address]    <= Mask_in;
      end
	  else if(read) begin
	    CT_read <= 1'b1;
	    CT_address <= address_mem[address];
		Mask <= Mask_mem[address];
      end
	  else begin
	    CT_read <= 1'b0;
		CT_address <= 11'bz;
		Mask <= 20'b0;
	  end
    end	
  end*/
endmodule