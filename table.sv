`include "clause_register.sv"
`include "address_translation_table.sv"
`include "clause_table.sv"
`include "break_value_counter.sv"
`include "clause_evaluator.sv"
`include "temp_buffer.sv"
`include "fifo_clause_reg.sv"
module table_test(
  input clk,
  input rst,
  //input logic boot,
  input logic [11:0] clause_num,
  input [4:1] ucb_req,
  input [35:0] reg_in,
  output logic [4:1] ucb_gnt,
  output logic write_flip,//for eva2
  output logic [11:0] write_flip_index,//for eva2
  output logic write_flip_value,//for eva2
  output logic [1:20] write_req,
  output logic [719:0] temp_out_noc,
  output logic [3:0] reg_state_out,
  output logic [4:0] count_out,
  output logic [10:0] AT_address_out,
  output logic [10:0] CT_address_out,
  output logic CT_read_out,
  output logic [23:0] out1_out,
  output logic [23:0] out2_out,
  output logic [23:0] out3_out,
  output logic [23:0] out4_out,
  output logic [23:0] out5_out,
  output logic [23:0] out6_out,
  output logic [23:0] out7_out,
  output logic [23:0] out8_out,
  output logic [23:0] out9_out,
  output logic [23:0] out10_out,
  output logic [23:0] out11_out,
  output logic [23:0] out12_out,
  output logic [23:0] out13_out,
  output logic [23:0] out14_out,
  output logic [23:0] out15_out,
  output logic [23:0] out16_out,
  output logic [23:0] out17_out,
  output logic [23:0] out18_out,
  output logic [23:0] out19_out,
  output logic [23:0] out20_out,  
  
  output logic [20:1] Mask_out,
  output logic [20:1] v1_out,

  output logic [20:1] v2_out,
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
  output logic [35:0] temp_in6_out,
  output logic [35:0] temp_in7_out,
  output logic [35:0] temp_in8_out,
  output logic [35:0] temp_in9_out,
  output logic [35:0] temp_in10_out,
  output logic [35:0] temp_in11_out,
  output logic [35:0] temp_in12_out,
  output logic [35:0] temp_in13_out,
  output logic [35:0] temp_in14_out,
  output logic [35:0] temp_in15_out,
  output logic [35:0] temp_in16_out,
  output logic [35:0] temp_in17_out,
  output logic [35:0] temp_in18_out,
  output logic [35:0] temp_in19_out,
  output logic [35:0] temp_in20_out,
  output logic [11:0] AT_address_reg_out,
  output logic [1:0] temp_address_out,
  output logic temp_write_out,
  output logic [4:0] count1_out,
  output logic [4:0] count2_out,
  output logic [4:0] count3_out,
  output logic already_sat_out,
  output logic neg_bit1_out,
  output logic neg_bit2_out,
  output logic neg_bit3_out,
  output logic [35:0] clause_out  
);
  logic value_mem [2047:0];
  //logic [2047:0] var_table_in;
  logic [10:0] CT_address;
  logic CT_read;
  
  logic Mask[20:1];
  logic Mask_1[20:1];
  logic Mask_2[20:1];
  logic Mask_3[20:1];
  logic Mask_4[20:1];
  
  logic [20:1] Mask1,Mask2,Mask3;
  logic [3:0] cnt;
  logic [35:0] clause_reg;
  logic AT_read;
  logic [35:0] unsatisfied_clause_in;
  logic [10:0] unsatisfied_clause_buffer_address;
  logic [35:0] unsatisfied_clause_out;
  logic empty;
  logic unsatisfied_clause_buffer_read;
  logic unsatisfied_clause_buffer_write;
  logic [11:0] AT_address,AT_address_reg1,AT_address_reg2;
  logic temp_write;// [20:1];
  //logic temp_read [20:1];
  logic [10:0] flip_var_address;
  logic evaluator_write;
  //logic [1:0] temp_read_address [20:1];
  logic [1:0] temp_address;//[20:1];
  logic [1:0] cr_temp_address,cr_temp_address_reg;
  logic [35:0] temp_out [20:1];
  logic [1:0] which_flip;
  logic [20:1] brk;
  logic flip_value;
  assign temp_out_noc[35:0] = temp_out[20];
  assign temp_out_noc[71:36] = temp_out[19];
  assign temp_out_noc[107:72] = temp_out[18];
  assign temp_out_noc[143:108] = temp_out[17];
  assign temp_out_noc[179:144] = temp_out[16];
  assign temp_out_noc[215:180] = temp_out[15];
  assign temp_out_noc[251:216] = temp_out[14];
  assign temp_out_noc[287:252] = temp_out[13];
  assign temp_out_noc[323:288] = temp_out[12];
  assign temp_out_noc[359:324] = temp_out[11];
  assign temp_out_noc[395:360] = temp_out[10];
  assign temp_out_noc[431:396] = temp_out[9];
  assign temp_out_noc[467:432] = temp_out[8];
  assign temp_out_noc[503:468] = temp_out[7];
  assign temp_out_noc[539:504] = temp_out[6];
  assign temp_out_noc[575:540] = temp_out[5];
  assign temp_out_noc[611:576] = temp_out[4];
  assign temp_out_noc[647:612] = temp_out[3];
  assign temp_out_noc[683:648] = temp_out[2];
  assign temp_out_noc[719:684] = temp_out[1];
  
  assign CT_read_out = CT_read;
  always_ff@(posedge clk) begin
    if(rst) begin
	  cr_temp_address_reg <= 2'b00;
	end
	else begin
	  cr_temp_address_reg <= cr_temp_address;
	end
  
  end
  
  always_ff@(posedge clk) begin
    if(rst) begin
	  for(int i=1;i<21;i=i+1)begin
	    Mask1[i] <= 1'b0;
		Mask2[i] <= 1'b0;
		Mask3[i] <= 1'b0;
	  end
	end
    else if(cnt == 4'b0100) begin 
	  for(int i=1;i<21;i=i+1)begin
	    Mask1[i] <= brk[i];
	  end
	end
	else if(cnt == 4'b0101) begin 
	  for(int i=1;i<21;i=i+1)begin
	    Mask2[i] <= brk[i];
	  end
	end
	else if(cnt == 4'b0110) begin 
	  for(int i=1;i<21;i=i+1)begin
	    Mask3[i] <= brk[i];
	  end
	end
	else if(cnt == 4'b1111) begin
	  case(cr_temp_address_reg)
        2'b01: begin	
	      for(int i=1;i<21;i=i+1)begin
	        write_req[i] <= Mask1[i];
	      end
        end		  
		2'b10: begin	
	      for(int i=1;i<21;i=i+1)begin
	        write_req[i] <= Mask2[i];
	      end
		end
        2'b11: begin	
	      for(int i=1;i<21;i=i+1)begin
	        write_req[i] <= Mask3[i];
	      end
		end
        default: begin
          for(int i=1;i<21;i=i+1)begin
	        write_req[i] <= 1'b0;
	      end		
		end
      endcase
	end
    else begin
      for(int i=1;i<21;i=i+1) begin
	    write_req[i] <= 1'b0;
	  end
   	
	end
	
  end
/*  logic [10:0] addr;
  always_ff@(posedge clk) begin
    if(rst) begin
	  addr <= 11'b0;
	end
	else if(cnt==3'b111) begin
	  addr <= addr + 11'b1;
	end
  end
  */
  logic [11:0] flip_index;
  
  always_comb begin
    if(cnt == 4'b0100) begin
	  evaluator_write = 1'b0;
	  flip_var_address = 11'b0;
	  //for(int i=1 ; i<21;++i) begin
	    temp_address = 2'b01;
	    temp_write = 1'b1;
		//temp_read[i] = 1'b0;
		//temp_read_address[i] = 2'b00;
	  //end
	end
	else if(cnt == 4'b0101) begin
	  evaluator_write = 1'b0;
	  flip_var_address = 11'b0;
	  //for(int i=1 ; i<21;++i) begin
	    temp_address = 2'b10;
		temp_write = 1'b1;
		//temp_read[i] = 1'b0;
		//temp_read_address[i] = 2'b00;
	  //end
	end
    else if(cnt == 4'b0110) begin
	  evaluator_write = 1'b0;
	  flip_var_address = 11'b0;
	  //for(int i=1 ; i<21;++i) begin
	    temp_address = 2'b11;
		temp_write = 1'b1;
		//temp_read[i] = 1'b0;
		//temp_read_address[i] = 2'b00;
	  //end
	end
    else if(cnt == 4'b0111) begin
	  evaluator_write = 1'b1;
	  flip_var_address = flip_index[10:0];
	  //for(int i=1 ; i<21;++i) begin
	    //temp_read[i] = 1'b1;
		temp_write  = 1'b0;
	//  end
	//  for(int i=1 ; i<21;++i) begin
	    temp_address = cr_temp_address;
		//temp_write_address[i] = 2'bz;
	//  end
	
	end
	else begin
	  
	  //for(int i=1 ; i<21;++i) begin
	    //temp_read[i] = 1'b0;
		temp_address = 2'b00;
		//temp_write_address[i] = 2'bz;
	    temp_write = 1'b1;
	  //end
	 
	  evaluator_write = 1'b0;
	  flip_var_address = 11'b0;
	end
  end
  
 /* always_comb begin
    if(cnt==3'b000)
      unsatisfied_clause_buffer_read = 1'b1;
	else
	  unsatisfied_clause_buffer_read = 1'b0;
	unsatisfied_clause_buffer_address = addr;  
  end */
  logic [4:0] count;
  assign write_flip_index = (cnt == 4'b0111)? flip_index:12'b0;
  assign write_flip = (cnt == 4'b0111)? 1'b1:1'b0;
  //debug
  //always_comb begin
  //  if(cnt == 3'b111) begin
	//  $display("%d",flip_index[10:0]);
	//end
  //end
  //
  assign CT_read_out = CT_read;
  clause_register cr( 
    .clk(clk),
    .rst(rst),
    .count(count),
	.clause_num(clause_num),
    .reg_in(reg_in),
	.ucb_req(ucb_req),
	.ucb_gnt(ucb_gnt),
    .AT_address(AT_address),
	.AT_read(AT_read),
	.cnt(cnt),
	.flip_index(flip_index),
	.flip_value(flip_value),
	.temp_address(cr_temp_address),
	.cr_v1_out(cr_v1_out),
	.cr_v2_out(cr_v2_out),
	.cr_v3_out(cr_v3_out),
	.cr_var_address1_out(cr_var_address1_out),
	.cr_var_address2_out(cr_var_address2_out),
	.cr_var_address3_out(cr_var_address3_out),
	.count1_out(count1_out),
	.count2_out(count2_out),
	.count3_out(count3_out),
	.already_sat_out(already_sat_out),
	.neg_bit1_out(neg_bit1_out),
	.neg_bit2_out(neg_bit2_out),
	.neg_bit3_out(neg_bit3_out),
    .clause_out(clause_out)
  );
  assign reg_state_out = cnt;
  assign write_flip_value = flip_value;
  address_translation_table AT(
    .clk(clk),
    .rst(rst),
    .read(AT_read),
    .address(AT_address),
    .CT_address(CT_address),
	.CT_read(CT_read),
    .Mask({Mask[1],Mask[2],Mask[3],Mask[4],
	       Mask[5],Mask[6],Mask[7],Mask[8],
		   Mask[9],Mask[10],Mask[11],Mask[12],
		   Mask[13],Mask[14],Mask[15],Mask[16],
		   Mask[17],Mask[18],Mask[19],Mask[20]})
  );
  assign AT_address_out = AT_address;
  assign CT_address_out = CT_address;
  
  
  
  
  logic [23:0] out [20:1];
  logic [479:0] CT_in;
  clause_table CT(
    .clk(clk),
    //.rst(rst),
    .read(CT_read),
    .write(1'b0),
    .address(CT_address),
    .in(CT_in),
    .out1(out[1]),
    .out2(out[2]),
    .out3(out[3]),  
    .out4(out[4]),
    .out5(out[5]),
    .out6(out[6]),
    .out7(out[7]),
    .out8(out[8]),
    .out9(out[9]),  
    .out10(out[10]),
    .out11(out[11]),
    .out12(out[12]),
    .out13(out[13]),
    .out14(out[14]),
    .out15(out[15]),  
    .out16(out[16]),
    .out17(out[17]),
    .out18(out[18]),
    .out19(out[19]),
    .out20(out[20])
  );

  assign out1_out = out[1];
  assign out2_out = out[2];
  assign out3_out = out[3];
  assign out4_out = out[4];
  assign out5_out = out[5];
  assign out6_out = out[6];
  assign out7_out = out[7];
  assign out8_out = out[8];
  assign out9_out = out[9];
  assign out10_out = out[10];
  assign out11_out = out[11];
  assign out12_out = out[12];
  assign out13_out = out[13];
  assign out14_out = out[14];
  assign out15_out = out[15];
  assign out16_out = out[16];
  assign out17_out = out[17];
  assign out18_out = out[18];
  assign out19_out = out[19];
  assign out20_out = out[20];
  
  
  break_value_counter bvc(
    .brk(brk),
    .count(count)   
  );
  
  assign count_out = count;
  
  logic [35:0] temp_in [20:1];
  
 
  genvar i;
  generate
    for (i=1; i<21; i=i+1) begin :temp 
      temp_buffer uut(
        .clk(clk),
        //.rst(rst),
        .temp_write(temp_write),
        //.temp_read(temp_read[i]),
        .temp_in(temp_in[i]),
        //.temp_read_address(temp_read_address[i]),
        .temp_address(temp_address),
		.temp_out(temp_out[i])
      );
  end 
  endgenerate
  logic [11:0] AT_address_reg3;
  logic [11:0] AT_address_reg4;
  logic [11:0] AT_address_reg5;
  logic [11:0] AT_address_reg6;
  always_ff@(posedge clk) begin
    if(rst) begin
	  for(int i=1;i<21;i=i+1)begin
	    Mask_1[i] <= 1'b0;
		Mask_2[i] <= 1'b0;
		Mask_3[i] <= 1'b0;
		Mask_4[i] <= 1'b0;
	  end
	  AT_address_reg1 <= 12'b0;
	  AT_address_reg2 <= 12'b0;
	  AT_address_reg3 <= 12'b0;
	  AT_address_reg4 <= 12'b0;
	  //AT_address_reg5 <= 12'b0;
	 // AT_address_reg6 <= 12'b0;
	end
	else begin
	  for(int i=1;i<21;i=i+1)begin
	    Mask_1[i] <= Mask[i];
		Mask_2[i] <= Mask_1[i];
		Mask_3[i] <= Mask_2[i];
		Mask_4[i] <= Mask_3[i];
	  end
	  AT_address_reg1 <= AT_address;
	  if(AT_address_reg1 > clause_num) begin
	    AT_address_reg2 <= AT_address_reg1 - clause_num;//for output
		AT_address_reg2[11] <= 1'b1;
	  end
	  else begin
	    AT_address_reg2 <= AT_address_reg1 ;
		AT_address_reg2[11] <= 1'b0;
	  end
	  AT_address_reg3 <= AT_address_reg2;
	  AT_address_reg4 <= AT_address_reg3 ;
	  //AT_address_reg5 <= AT_address_reg4 ;
	  //AT_address_reg6 <= AT_address_reg5 ;
    end
  end
  
  always_comb begin
      for(int i=1;i<21;i=i+1)begin
	    Mask_out[i] = Mask_4[i];
	  end
  end
  
  //always_comb begin
  //   for(int i=0;i<2048;++i) begin
	//    var_table_in[i] = value_mem[i]; 
	//  end
	
 // end
  logic [35:0] temp_in_1 [1:20];
  
  logic [35:0] temp_in_2 [1:20];
  always_ff@(posedge clk) begin
    if(rst) begin
	  for(int k=1;k<21;k=k+1) begin
	    temp_in_1[k] <= 36'b0;
        temp_in_2[k] <= 36'd0;		
	  end
	end
	else begin
	  for(int k=1;k<21;k=k+1) begin
	    temp_in_1[k] <= {AT_address_reg4,out[k]};
        temp_in_2[k] <= temp_in_1[k];		
	  end
	end
  end 
  logic read;
  //logic [2047:0]var_table_out[20:1];
  genvar j;
  generate
    for (j=1; j<21; j=j+1) begin :evaluator 
      clause_evaluator ce(
        .clk(clk),
        .rst(rst),
        .neg_bit1(out[j][11]),
		.neg_bit2(out[j][23]),
		.neg_bit3(AT_address_reg2[11]),
		//.read(read),
       // .var_table_in(var_table_in),
		//.boot(boot),
		.evaluator_write(evaluator_write),
        .valid(Mask_4[j]),
        .var_address1(out[j][10:0]),
        .var_address2(out[j][22:12]),
		.var_address3(AT_address_reg2[10:0]),
		.var_address1_temp(temp_in_2[j][11:0]),
        .var_address2_temp(temp_in_2[j][23:12]),
		.var_address3_temp(temp_in_2[j][35:24]),
		.flip_value(flip_value),
        .flip_var_address(flip_var_address),
		.index1(temp_in[j][11:0]),
		.index2(temp_in[j][23:12]),
		.index3(temp_in[j][35:24]),
		.v1(v1_out[j]),
		.v2(v2_out[j]),
		.brk(brk[j])
        //.var_table_out(var_table_out[j])		
      );
    end 
  endgenerate
   
  
  
  
  
 
  always_comb begin
    for(int i=1;i < 21 ;i+=1) begin
	  brk_out[i] = brk[i];
	end
  end
  assign temp_in1_out = temp_in[1];
  assign temp_in2_out = temp_in[2];
  assign temp_in3_out = temp_in[3];
  assign temp_in4_out = temp_in[4];
  assign temp_in5_out = temp_in[5];
  assign temp_in6_out = temp_in[6];
  assign temp_in7_out = temp_in[7];
  assign temp_in8_out = temp_in[8];
  assign temp_in9_out = temp_in[9];
  assign temp_in10_out = temp_in[10];
  assign temp_in11_out = temp_in[11];
  assign temp_in12_out = temp_in[12];
  assign temp_in13_out = temp_in[13];
  assign temp_in14_out = temp_in[14];
  assign temp_in15_out = temp_in[15];
  assign temp_in16_out = temp_in[16];
  assign temp_in17_out = temp_in[17];
  assign temp_in18_out = temp_in[18];
  assign temp_in19_out = temp_in[19];
  assign temp_in20_out = temp_in[20];
  
  assign AT_address_reg_out = AT_address_reg4;
  assign temp_address_out = temp_address;
  assign temp_write_out = temp_write;
   


endmodule
