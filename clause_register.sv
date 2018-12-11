module clause_register(
  input clk,
  input rst,
  input [4:0]  count,
  input [11:0] clause_num,
  input [35:0] reg_in,
  input [4:1] ucb_req,
  output logic [4:1] ucb_gnt,
  output logic [11:0] AT_address,
  output logic AT_read,
  output logic [3:0] cnt,
  output logic [10:0] flip_index,
  output logic flip_value,
  output logic [1:0] temp_address,
  output logic sat,
  output logic cr_v1_out,
  output logic cr_v2_out,
  output logic cr_v3_out,
  output logic [11:0] cr_var_address1_out,
  output logic [11:0] cr_var_address2_out,
  output logic [11:0] cr_var_address3_out,
  output logic [4:0] count1_out,
  output logic [4:0] count2_out,
  output logic [4:0] count3_out,
  output logic already_sat_out,
  output logic neg_bit1_out,
  output logic neg_bit2_out,
  output logic neg_bit3_out,
  output logic [35:0] clause_out
 );

  
  logic        flip_value_cr;
  logic [3:0]  state;
  assign cnt = state;
  parameter idle          = 4'b0000,
            first         = 4'b0001,
            second        = 4'b0010,
			third         = 4'b0011,
		 	first_count   = 4'b0100,
			second_count  = 4'b0101,
			set_flip1     = 4'b0111,
			set_flip2     = 4'b1001,
			req_fifo_tree = 4'b1111,
			//dummy = 4'b1111,
			fifo_count    = 4'b1010,
            dummy2        = 4'b0110,
			check_unsat   = 4'b1011;
			//dummy2 = 4'b0110;
  
  logic [11:0] temp_flip;
  logic [1:0] dummy_cnt;
  logic write_var_table;
  logic [10:0] flip_var_address;
  logic [4:0] count1;
  logic [4:0] count2;
  logic [4:0] count3;
  logic enable_gnt;
  logic [35:0] clause;
  logic [20:0] flip_time;
  logic already_sat;
  logic rand_seed2;
  logic [1:0] rand_seed3;
  logic count_zero1,count_zero2,count_zero3;
  logic v1,v2,v3;
  
  always_ff@ (posedge clk) begin
    if(rst) begin
	  rand_seed2 <= 1'b0;
	end
	else 
	  rand_seed2 <= rand_seed2 + 1'b1;
  end
  
  always_ff@ (posedge clk) begin
    if(rst) begin
	  rand_seed3 <= 2'b01;
	end
	else if(rand_seed3 == 2'b11) begin
	  rand_seed3 <= 2'b01;
	end
	
	else begin
	  rand_seed3 <= rand_seed3 + 1'b1;
	end
  end
  logic neg_bit1,neg_bit2,neg_bit3;
  logic [10:0] var_address1,var_address2,var_address3;
  
  clause_evaluator2 eva2(
    .clk(clk),
    .rst(rst),
    .neg_bit1(neg_bit1),
    .neg_bit2(neg_bit2),
    .neg_bit3(neg_bit3),
    .write(write_var_table),
    //.var_table_in(var_table_in),
    .var_address1(var_address1),
    .var_address2(var_address2),
    .var_address3(var_address3),
    .flip_var_address(flip_var_address),
	.flip_value(flip_value_cr),
	.v1_out(cr_v1_out),
	.v2_out(cr_v2_out),
	.v3_out(cr_v3_out),
    .sat(already_sat)   
  );
  assign cr_var_address1_out = var_address1;
  assign cr_var_address2_out = var_address2;
  assign cr_var_address3_out = var_address3;
  
  always_comb begin
    if(state == set_flip1) begin
	  write_var_table = 1'b1;
	  flip_var_address = {1'b0,flip_index};
	  flip_value_cr = flip_value;
	end
	else begin
	  write_var_table = 1'b0;
	  flip_var_address = 12'b0;
	  flip_value_cr = 1'b0;
	end
  end
  
  assign clause_out = clause;
  
  always_comb begin
    if(ucb_gnt) begin
	  neg_bit1     = 1'b0;
	  neg_bit2     = 1'b0;
	  neg_bit3     = 1'b0;
	  var_address1 = reg_in[34:24];
	  var_address2 = reg_in[22:12];
	  var_address3 = reg_in[10:0];
	end
	else if(state == check_unsat) begin
	  neg_bit1 = clause[35];
	  neg_bit2 = clause[23];
	  neg_bit3 = clause[11];
	  var_address1 = 11'b0;
	  var_address2 = 11'b0;
	  var_address3 = 11'b0;
	end
	
	else begin
	  neg_bit1     = 1'b0;
	  neg_bit2     = 1'b0;
	  neg_bit3     = 1'b0;
	  var_address1 = 11'b0;
	  var_address2 = 11'b0;
	  var_address3 = 11'b0;
	
	end
	
  end
  
  assign neg_bit1_out    = neg_bit1;
  assign neg_bit2_out    = neg_bit2;
  assign neg_bit3_out    = neg_bit3;
  assign already_sat_out = already_sat;
  
  
  always_comb begin
    if(!enable_gnt) begin
	  ucb_gnt = 1'b0;
	end
	else begin
      if(ucb_req[1])	
	    ucb_gnt = 1'b1;
	  else 
	    ucb_gnt = 1'b0;
    end
  end
  
   
   
  logic [10:0] c1,c2,c3;
  logic [1:0] third_cnt;
  always_ff@(posedge clk) begin
    if(rst) begin
	  sat            <= 1'b0;
	  flip_time      <= 21'b0;
	  //read_req       <= 1'b0;
	  state          <= 4'b0000;
	  count1         <= 5'b0;
	  count2         <= 5'b0;
	  dummy_cnt      <= 2'b0;
	  third_cnt      <= 2'b00;
	  clause         <= 36'b0;
	end
	else begin
	  case(state) 
	    idle: begin
		  if(ucb_gnt) begin
		    clause <= reg_in;
			state  <= check_unsat;
		  end   
		  else begin
		    state <= state;
		  end
		end
		check_unsat: begin
		  if(dummy_cnt == 2'b01) begin
		    dummy_cnt <= 2'b00;
		    if(!already_sat)
	          state <= first;
			else begin
			  state     <= idle;
			end
			v1 <= cr_v1_out;
			v2 <= cr_v2_out;
			v3 <= cr_v3_out;
		  end
		  else begin
		    state     <= state;
            dummy_cnt <= dummy_cnt + 1'b1;
          end		  
	        
	    end
		
		
		
		first: begin
		  sat   <= 1'b0;
		  state <= second;  
	    end
		second: begin
		  sat   <= 1'b0;
		  state <= third;
		end
		third: begin
          sat        <= 1'b0;
		  if(third_cnt == 2'b11) begin
		    state     <= first_count;
			third_cnt <= 2'b00;
		  end
		  else begin
		    third_cnt <= third_cnt + 1'b1;
		  end
        end
		
		dummy2: begin
		  count3 <= count;
		  state  <= set_flip1;
		end
		first_count: begin
	      if(clause[10:0] == 11'b0) begin
	        count1 <= 5'd20;
	      end
	      else begin
	        count1 <= count; 
	      end
		  sat <= 1'b0;
	      state <= second_count;
		  
		end
		
		second_count: begin
		  count2 <= count;
	      
		  sat <= 1'b0;
		  state <= dummy2;
		
		end
		set_flip1: begin
		  state      <= req_fifo_tree;
		  flip_time  <= flip_time + 1'b1;
		end
		
		req_fifo_tree: begin
		  sat <= sat;
		  clause <= 36'b0;
		  state <= idle;
		end
      endcase
    end
  end
  
  always_comb begin
    if(state == set_flip1) begin
	  if(rand_seed2 == 1'b0) begin
	    case(rand_seed3)
		  2'b01: begin
		    if(clause[11:0] == 11'b0) begin
			  case(rand_seed2)
                1'b0: flip(clause[23:12],1'b0);
				default: flip(clause[35:24],1'b0);
			  endcase
			end
			else 
			  flip(clause[11:0],1'b0);
		  end
		  2'b10: flip(clause[23:12],1'b0);
		  default: flip(clause[35:24],1'b0);
		endcase
	  end
	  else if(count1 < count2 && count2 < count3) begin
        flip(clause[11:0],1'b0);
      end
      else if(count3 < count1 && count1 < count2) begin		
	    flip(clause[35:24],1'b0);
	  end
	  else if(count3 < count1 && count1 == count2)
        flip(clause[35:24],1'b0);	    
	  else if(count3 == count1 && count1 < count2) begin
	    if(rand_seed2 == 1'b0)
		  flip(clause[11:0],1'b0);
	    else 
		  flip(clause[35:24],1'b0);
	  end
      else if(count3 < count2 && count2 < count1) 
        flip(clause[35:24],1'b0);
	  else if(count3 < count2 && count2 == count1) 
	    flip(clause[35:24],1'b0);
	  else if(count3 == count2 && count2 < count1) begin
	    if(rand_seed2 == 1'b0) 
		  flip(clause[35:24],1'b0);
		else
		  flip(clause[23:12],1'b0);
	  end	  
      else if(count1 < count3 && count3 < count2)
        flip(clause[11:0],1'b0);
	  else if(count1 < count3 && count3 == count2)
        flip(clause[11:0],1'b0); 
	  else if(count1 == count3 && count3 < count2) begin
	    if(rand_seed2 == 1'b0) 
	      flip(clause[11:0],1'b0);
	    else 
		  flip(clause[35:24],1'b0);
	  end
	  else if(count1 < count2 && count2 < count3) 
        flip(clause[11:0],1'b0);	     
	  else if(count1 < count2 && count2 == count3) 
        flip(clause[11:0],1'b0);
	  else if(count1 == count2 && count2 < count3) begin
	    if(rand_seed2 == 1'b0)
          flip(clause[11:0],1'b0);		   
	    else 
		  flip(clause[23:12],1'b0);
	  end
	  else if(count2 < count3 && count3 < count1) 
        flip(clause[23:12],1'b0);
      else if(count2 < count3 && count3 == count1)
	    flip(clause[23:12],1'b0);
      else if(count2 == count3 && count3 < count1) begin
        if(rand_seed2 == 1'b0) 
		  flip(clause[23:12],1'b0);
	    else 
		  flip(clause[35:24],1'b0);
	  end
	  else if(count2 < count1 && count1 < count3)
	    flip(clause[23:12],1'b0);
	  else if(count2 < count1 && count1 == count3) 
	    flip(clause[23:12],1'b0);	  
	  else if(count2 == count1 && count1 < count3) begin
        if(rand_seed2 == 1'b0) 
		  flip(clause[23:12],1'b0);
	    else 
          flip(clause[11:0],1'b0);
	  end
	  else if(count2 == count1 && count1 == count3) begin
        if(rand_seed3 == 2'b01) 
		  flip(clause[11:0],1'b0);
        else if(rand_seed3 == 2'b10)
		  flip(clause[23:12],1'b0);
	    else
          flip(clause[35:24],1'b0);
	  end
	  else begin
	    temp_address = 2'b00;
	    flip_index   = 12'b0;
		flip_value   = 1'b0;
	  end
    end
    else begin
      temp_address = 2'b00;
	  flip_index   = 12'b0;
	  flip_value   = 1'b0;
    end	
  end
  
  always_comb begin
    if(state == idle) begin
	  enable_gnt = 1'b1;
	end
	else 
	  enable_gnt = 1'b0;
  end
  
  assign count1_out = count1;
  assign count2_out = count2;
  assign count3_out = count3;
  //address table read & address setting
  always_comb begin
    if(state == first) begin
	  //if(!already_sat && ucb_gnt) begin
        if(clause[10:0] == 11'b0) begin
	      AT_address = 11'b0;
		  AT_read    = 1'b0;
	    end
		else if(clause[11] == 1'b0) begin
	      AT_address = clause_num +clause[10:0];
		  AT_read    = 1'b1;
		end
		else if(clause[11] == 1'b1) begin
	      AT_address = clause[10:0];
		  AT_read    = 1'b1;
	    end
		else begin
		  AT_address = 12'b0;
		  AT_read    = 1'b0;
	    end
      //end
    end
	else if(state == second) begin
	  AT_read  = 1'b1;
	  if(clause[23] == 1'b0) 
	    AT_address = clause_num +clause[22:12];  
	  else  
	    AT_address =  clause[22:12];
	end
	else if(state == third) begin
	  AT_read = 1'b1;
	  if(clause[35] == 1'b0)
	    AT_address = clause_num + clause[34:24];
	  else  
	    AT_address = clause[34:24];
	end
	else begin
	  AT_address = 12'b0;
	  AT_read    = 1'b0;
	end
  end
  
  task flip(
    input [11:0] index,
    input zero
  );
    flip_index = index;
	if(zero) begin
	  temp_address = 2'b00;
	  flip_value   = 1'b0;
	end
	else if(index == clause[11:0]) begin
      temp_address = 2'b01;
	  flip_value   = !v1;
	end
	else if(index == clause[23:12]) begin
      temp_address = 2'b10;
	  flip_value   = !v2;
	end
	else if(index == clause[35:24]) begin
      temp_address = 2'b11;
      flip_value   = !v3;	  
	end
	//else begin
	 // temp_address = 2'b00;
	 // flip_value   = 1'b0;
	
	//end
  endtask
endmodule

  


