`include "PE.sv"
`include "fifo.sv"
`include "table.sv"
module Single_thread(
  input OSC_50_BANK2,
  input BUTTON0,
  //input boot,
  //input [11:0] clause_num,
  //input [10:0] mem_count_init,
  output logic LED0
/*  output logic [3:0] state_out,
  output logic [35:0] out_out,
 // output logic [23:0] temp_out_1,
 // output logic [23:0] temp_out_2,
  output logic [10:0] var_address1_out,
  output logic [10:0] var_address2_out,
  output logic [10:0] var_address3_out,
  output logic [10:0] address_out,
  output logic [10:0] mem_count_out,
  output logic [35:0] mem_in_out,
  output logic [35:0] mem_out_out,
  output logic [10:0] flip_address_out,
  output logic write_buffer_out,
  output logic read_buffer_out,
  output logic v1_out,
  output logic v2_out,
  output logic v3_out,
  output logic [3:0] reg_state_out,
  output logic [4:0] count_out,
  output logic [10:0] AT_address_out,
  output logic [10:0] CT_address_out,
  output logic [35:0] cr_in_out,
  output logic ucb_req_out,
  output logic ucb_gnt_out,
  output logic CT_read_out,
  output logic [23:0] out1_out,  
  output logic [23:0] out2_out ,
  output logic [35:0] last_packetin_out, 
  
  output logic [35:0] last_packet_out,
  output logic clk_out,
  output logic [20:1] Mask_out,
  output logic [20:1] v1_1_out,
  output logic [20:1] v2_1_out,
  output logic [20:1] brk_out,
  output logic cr_v1_out,
  output logic cr_v2_out,
  output logic cr_v3_out,
  output logic [11:0] cr_var_address1_out,
  output logic [11:0] cr_var_address2_out,
  output logic [11:0] cr_var_address3_out,  
  output logic [35:0] temp_in1_out,
  output logic [35:0] temp_in2_out,
  output logic [35:0] temp_in3_out,
  output logic [35:0] temp_in4_out,
  output logic [35:0] temp_in5_out,
  output logic [11:0] AT_address_reg_out
*/  );
  logic clk;
  logic rst;
  assign rst = BUTTON0;
  logic ucb_cr_req;
  logic ucb_cr_gnt;
  logic [35:0] cr_in;
  logic [35:0] temp_out [20:1];
  logic write_var_table;
  logic [10:0] flip_var_address;
  logic not_empty;
  logic write_req [20:1];
  logic write_gnt [20:1];
  logic fifo_req [20:1];
  logic fifo_gnt [20:1];
  //logic empty [20:1];
  //logic [35:0] PacketOut[20:1];
  logic last_write_req,last_write_gnt;
  logic [35:0] last_packetin,last_packet;
  logic last_read_req,last_read_gnt;
  logic last_empty;
  logic [35:0] fifo_packet [20:1];
  logic fifo_empty [20:1];
  logic PE_sat;
 // logic [3:0] state_out;
  table_test tt(
    .clk(clk),
    .rst(rst),
    .boot(boot),
	.clause_num(12'd600),
    .ucb_req(ucb_cr_req),
    .reg_in(cr_in),
    .ucb_gnt(ucb_cr_gnt),
	.write_flip(write_var_table),
	.write_flip_index(flip_var_address),
	.write_req({write_req[1],write_req[2],write_req[3],write_req[4],write_req[5],
	            write_req[6],write_req[7],write_req[8],write_req[9],write_req[10],
				write_req[11],write_req[12],write_req[13],write_req[14],write_req[15],
				write_req[16],write_req[17],write_req[18],write_req[19],write_req[20]}),
    .temp_out_noc({temp_out[1],temp_out[2],temp_out[3],temp_out[4],temp_out[5],
	               temp_out[6],temp_out[7],temp_out[8],temp_out[9],temp_out[10],
				   temp_out[11],temp_out[12],temp_out[13],temp_out[14],temp_out[15],
				   temp_out[16],temp_out[17],temp_out[18],temp_out[19],temp_out[20]}), 
    .reg_state_out(reg_state_out),
	.count_out(count_out),
	.AT_address_out(AT_address_out),
	.CT_address_out(CT_address_out),
	.CT_read_out(CT_read_out),
	.out1_out(out1_out),
	.out2_out(out2_out),
	.Mask_out(Mask_out),
	.v1_out(v1_1_out),
	.v2_out(v2_1_out),
	.brk_out(brk_out),
	.cr_v1_out(cr_v1_out),
	.cr_v2_out(cr_v2_out),
	.cr_v3_out(cr_v3_out),
	.cr_var_address1_out(cr_var_address1_out),
	.cr_var_address2_out(cr_var_address2_out),
	.cr_var_address3_out(cr_var_address3_out),
    .temp_in1_out(temp_in1_out),
    .temp_in2_out(temp_in2_out),
    .temp_in3_out(temp_in3_out),
    .temp_in4_out(temp_in4_out),
    .temp_in5_out(temp_in5_out),
    .AT_address_reg_out(AT_address_reg_out)	
  );
  assign cr_in_out = cr_in;
  assign ucb_req_out = ucb_cr_req;
  assign ucb_gnt_out = ucb_cr_gnt;
  //assign temp_out_1 = temp_out[1];
  //assign temp_out_2 = temp_out[2];
  assign sat = PE_sat & !not_empty ;
  assign LED0 = sat;
  PE pe(
    .clk(clk),
    .rst(rst),
    .fifo_gnt(last_read_gnt),
    .write_var_table(write_var_table),//for var_table
    .flip_var_address(flip_var_address),
    .fifo_empty(last_empty),
	.mem_count_init(12'd336),
    //.boot(boot),
    .cr_gnt(ucb_cr_gnt),
    .packetin(last_packet),
    //.PE_mem_in(PE_mem_in),//for boot
    //.PE_address_in(),
    //.var_table_in(),
    .state_out(state_out),	
    .out(cr_in),
    .cr_req(ucb_cr_req),
	.out_out(out_out),
    .fifo_req(last_read_req),
    .sat(PE_sat),
	.var_address1_out(var_address1_out),
	.var_address2_out(var_address2_out),
	.var_address3_out(var_address3_out),
	.address_out(address_out),
	.mem_count_out(mem_count_out),
	.mem_in_out(mem_in_out),
	.mem_out_out(mem_out_out),
	.write_buffer_out(write_buffer_out),
	.read_buffer_out(read_buffer_out),
	.v1_out(v1_out),
	.v2_out(v2_out),
	.v3_out(v3_out)
  );
  
  
  assign flip_address_out = flip_var_address;
  
  genvar i;
  generate 
    for(i=1;i<21;i=i+1) begin:para_fifo
      fifo f( 
        .clk(clk), 
        .rst(rst), 
        .write_req(write_req[i]), 
        .write_gnt(write_gnt[i]), 
        .full(), 
        .PacketIn(temp_out[i]),
        .read_req(fifo_req[i]), 
        .read_gnt(fifo_gnt[i]), 
        .empty(fifo_empty[i]), 
        .PacketOut(fifo_packet[i]) 
    );
	end
  endgenerate
  
  
  fifo fifo_last(
    .clk(clk), 
    .rst(rst), 
    .write_req(last_write_req), 
    .write_gnt(last_write_gnt), 
    .full(), 
    .PacketIn(last_packetin),
    .read_req(last_read_req), 
    .read_gnt(last_read_gnt), 
    .empty(last_empty), 
    .PacketOut(last_packet)
  );
  
  assign last_packetin_out = last_packetin;
  assign last_packet_out = last_packet;
  
  logic [4:0] cnt_reg;
  logic [1:0] state;
  parameter idle = 2'b01,
            read_fifo = 2'b11,
            write_fifo = 2'b10;   
  assign not_empty = !fifo_empty[1] | !fifo_empty[2] | !fifo_empty[3] | !fifo_empty[4] | !fifo_empty[5]|
		             !fifo_empty[6] | !fifo_empty[7] | !fifo_empty[8] | !fifo_empty[9] | !fifo_empty[10]|
			         !fifo_empty[11] | !fifo_empty[12] | !fifo_empty[13] | !fifo_empty[14] | !fifo_empty[15]|
			         !fifo_empty[16] | !fifo_empty[17] | !fifo_empty[18] | !fifo_empty[19] | !fifo_empty[20];
  
  always_ff@(posedge clk) begin
    if(rst) begin
	  state <= idle;
	  cnt_reg <= 5'b0;
	end
    else begin
	  case(state) 
	    idle: begin
		  if(not_empty) begin
		    last_write_req <= 1'b0;
		    last_packetin <= 36'b0;
		    select_fifo();
		    state <= read_fifo;
		  end
		  else begin
		    state <= idle;
		  end
		end
		read_fifo: begin
		  fifo_req[cnt_reg] <= 1'b0;
		  state <= write_fifo;
		end
		write_fifo: begin
		  last_write_req <= 1'b1;
		  last_packetin <= fifo_packet[cnt_reg];
		  state <= idle;
		end
		
		
	  endcase
	
	end
  end
  
  pll pll_1(
	.inclk0(OSC_50_BANK2),
	.c0(clk)
	);
  //assign clk = clk_in;


  task output_req;
    input [4:0] index;
	for(int i=1;i<21;++i) begin
	  if(i==index) begin
	    fifo_req[i] = 1'b1;
      end
	  else begin
	    fifo_req[i] = 1'b0;
	  end
	end
  endtask
  
  task select_fifo;
    if(!fifo_empty[1]) begin
	    output_req(5'b1);
	    cnt_reg <= 5'b1;
	  end
	  else if(!fifo_empty[2]) begin
	    output_req(5'h2);
		cnt_reg <= 5'd2;
	  end
	  else if(!fifo_empty[3]) begin
	    output_req(5'h3);
	    cnt_reg <= 5'd3;
	  end
	  else if(!fifo_empty[4]) begin
	    output_req(5'h4);
	    cnt_reg <= 5'd4;
	  end
	  else if(!fifo_empty[5]) begin
	    output_req(5'h5);
	    cnt_reg <= 5'd5;
	  end
	  else if(!fifo_empty[6]) begin
	    output_req(5'h6);
	    cnt_reg <= 5'd6;
	  end
	  else if(!fifo_empty[7]) begin
	    output_req(5'h7);
	    cnt_reg <= 5'd7;
	  end
	  else if(!fifo_empty[8]) begin
	    output_req(5'h8);
	    cnt_reg <= 5'd8;
	  end
	  else if(!fifo_empty[9]) begin
	    output_req(5'h9);
	    cnt_reg <= 5'd9;
	  end
	  else if(!fifo_empty[10]) begin
	    output_req(5'ha);
	    cnt_reg <= 5'd10;
	  end
	  else if(!fifo_empty[11]) begin
	    output_req(5'hb);
	    cnt_reg <= 5'd11;
	  end
	  else if(!fifo_empty[12]) begin
	    output_req(5'hc);
	    cnt_reg <= 5'd12;
	  end
	  else if(!fifo_empty[13]) begin
	    output_req(5'hd);
	    cnt_reg <= 5'd13;
	  end
	  else if(!fifo_empty[14]) begin
	   output_req(5'he);
	    cnt_reg <= 5'd14;
	  end
	  else if(!fifo_empty[15]) begin
	    output_req(5'hf);
	    cnt_reg <= 5'd15;
	  end
	  else if(!fifo_empty[16]) begin
	    output_req(5'h10);
	    cnt_reg <= 5'd16;
	  end
	   else if(!fifo_empty[17]) begin
	    output_req(5'h11);
	    cnt_reg <= 5'd17;
	  end
	  else if(!fifo_empty[18]) begin
	    output_req(5'h12);
	    cnt_reg <= 5'd18;
	  end
	  else if(!fifo_empty[19]) begin
	    output_req(5'h13);
	    cnt_reg <= 5'd19;
	  end
	  else if(!fifo_empty[20]) begin
	    output_req(5'h14);
	    cnt_reg <= 5'd20;
	  end
	  else begin
	    output_req_zero();
	    cnt_reg <= 5'd0;
	  end
  
  endtask
  
  
  
  task output_req_zero;
    for(int i=1;i<21;++i) begin
	   fifo_req[i] = 1'b0;
	end
  endtask
  
endmodule