module random_generator(
  input clk,
  input rst,
  output logic [1:0] random_num
);

logic [1:0] random_num_temp/* synthesis keep */ ;
assign random_num = random_num_temp;

always_ff@(posedge clk) begin
  if(rst) begin
    random_num_temp <= 2'b0;
  end
  else begin
    case(random_num_temp)
	   2'b00: begin
		  random_num_temp <= 2'b01;
		end
		2'b01: begin
		  random_num_temp <= 2'b11;
		end
		2'b10: begin
		  random_num_temp <= 2'b00;
		end
		2'b11:begin
		  random_num_temp <= 2'b10;
		end
	 endcase
  end
end
endmodule