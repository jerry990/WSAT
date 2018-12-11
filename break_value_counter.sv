module break_value_counter(
  input [19:0] brk,
	input clk,
	input rst,
  output logic [4:0] count   
);
  logic c;
  always_comb begin
     count = brk[0] + brk[1] + brk[2] + brk[3] + brk[4]+
		    brk[5] + brk[6] + brk[7] + brk[8] + brk[9]+
		    brk[10] + brk[11] + brk[12] + brk[13] + brk[14]+
			brk[15] + brk[16] + brk[17] + brk[18] + brk[19];
  end

	always_ff@(posedge clk) begin
    if(rst) begin
     #2 c <= count;

		end
    else begin
     c <=c;
		end
	end
endmodule
