module lfsr(
  input clk,
  input rst,
  output logic [10:1] random_num

);
 always_ff @(posedge clk) begin
    if(rst)
		  random_num <= 10'b1;
		  
    else if(random_num == 10'b0)
	      random_num <= 10'b10;
    else 
		  random_num <= {random_num[9:6],
						 random_num[10]^random_num[5],
						 random_num[10]^random_num[4],
						 random_num[10]^random_num[3],
						 random_num[2],
						 random_num[1],
						 random_num[10]};
	end


endmodule
