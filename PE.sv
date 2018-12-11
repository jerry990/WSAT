`include "unsatisfied_clause_buffer.sv"
`include "clause_evaluator2.sv"
`include "random_generator.sv"
`include "lfsr.sv"
`define dataWidth 36
module PE(
  input clk,
  input rst,
  input fifo_gnt,
  input write_var_table,//for var_table
  input [10:0] flip_var_address,
  input write_flip_value,
  input fifo_empty,
  input [10:0] mem_count_init,
  //input [10:0] random_num,
  //input boot,
  input cr_gnt,
  input [`dataWidth-1:0] packetin,
  output logic [`dataWidth-1:0] out,
  output logic cr_req,
  output logic fifo_req,
  output logic sat,
  output logic [3:0]  state_out,
  output logic [10:0] var_address1_out,
  output logic [10:0] var_address2_out,
  output logic [10:0] var_address3_out,
  output logic [11:0] address_out,
  output logic [10:0] mem_count_out,
  output logic [35:0] mem_in_out,
  output logic [35:0] mem_out_out,
  output logic write_buffer_out,
  output logic read_buffer_out,
  output logic pe_neg_bit1_out,
  output logic pe_neg_bit2_out,
  output logic pe_neg_bit3_out,
  output v1_out,
  output v2_out,
  output v3_out,
  output logic already_sat_out  
);              
  
  
  logic bottom;
  logic read_buffer,write_buffer;
  logic [10:0] address;
  wire [`dataWidth-1:0] mem_in;
  wire [`dataWidth-1:0] mem_out;
  logic [10:0] random_addr,address_reg;
  logic [10:0] mem_count;
  unsatisfied_clause_buffer ucb(
    .clk(clk),
    .rst(rst),
    .read(read_buffer),
    .write(write_buffer),
	.mem_count_init(mem_count_init),
    .address(address),
    .mem_in(mem_in),
    .mem_out(mem_out),
	.mem_count(mem_count),
	.bottom(bottom)
  );
  assign read_buffer_out = read_buffer;
  assign write_buffer_out = write_buffer;  
  logic [9:0] random_num;	
  lfsr l(
    .clk(clk),
    .rst(rst),
    .random_num(random_num)
);	
  always_comb begin
    if(bottom) begin
      random_addr = 11'b0;
    end
    else if(random_num > mem_count-1'b1)begin
      random_addr = {1'b0,random_num} & (mem_count-1'b1);
    end
    else begin
      random_addr = {1'b0,random_num};
    end
  end

  //logic already_sat_out;	
  logic already_sat,already_sat_reg;  
  logic neg_bit1,neg_bit2,neg_bit3;
  logic [10:0] var_address1,var_address2,var_address3;
  //logic flip_value;
 
  //logic v1_out,v2_out,v3_out;
  clause_evaluator2 evaluator2(
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
	.flip_value(write_flip_value),
	.v1_out(v1_out),
	.v2_out(v2_out),
	.v3_out(v3_out),
	.flip_var_address(flip_var_address),
    .sat(already_sat)   
);	
  assign already_sat_out     = already_sat;
  assign var_address1_out    = var_address1;
  assign var_address2_out    = var_address2;
  assign var_address3_out    = var_address3;
  assign address_out         = address;
  assign mem_count_out       = mem_count;
  assign mem_in_out          = mem_in;
  assign mem_out_out         = mem_out;
  assign pe_neg_bit1_out     = neg_bit1;
  assign pe_neg_bit2_out     = neg_bit2;
  assign pe_neg_bit3_out     = neg_bit3;
  
  //assign write_var_table_out = write_var_table;
  always_comb begin
    if(state == READ2 && READ2_cnt == 2'b01) begin
	  var_address1 = mem_out[34:24];
 	  var_address2 = mem_out[22:12];
	  var_address3 = mem_out[10:0];
      neg_bit1     = 1'b0;
      neg_bit2     = 1'b0;
      neg_bit3     = 1'b0;
	end
	else if(state == CHECK_UNSAT) begin
	  var_address1 = 11'b0;
 	  var_address2 = 11'b0;
	  var_address3 = 11'b0;
      neg_bit1     = mem_out[35];
      neg_bit2     = mem_out[23];
      neg_bit3     = mem_out[11];
	end
	else begin
	  var_address1 = 11'b0;
 	  var_address2 = 11'b0;
	  var_address3 = 11'b0;
      neg_bit1     = 1'b0;
      neg_bit2     = 1'b0;
      neg_bit3     = 1'b0;
    end
  end
  parameter IDLE               = 4'b0000,
            READ1              = 4'b0001,
			READ2              = 4'b0011,
            CHECK_UNSAT        = 4'b0010,
			REQ_FIFO           = 4'b1110,
			WAIT_GNT           = 4'b0110,
			Read_unsat_buffer  = 4'b0100,
			Write_unsat_buffer = 4'b1100,
			WAIT_CR            = 4'b1010,
			dummy              = 4'b1111;
			
  logic [3:0] state;
  assign state_out = state;
  assign sat = bottom & fifo_empty & !rst;
  
  logic [1:0] gnt_cnt;
  logic [1:0] READ2_cnt; 
  logic [1:0] Read_unsat_buffer_cnt;
  logic       WAIT_GNT_cnt;
  logic       WAIT_GNT_to_IDLE_cnt;
  
  always_comb begin
    case (state)
	  IDLE: begin
	    write_buffer = 1'b0;
		mem_in       = 36'b0;
	    if(!bottom) begin
		  address      = random_addr;
		  read_buffer  = 1'b1;
		end
		else begin
		  read_buffer  = 1'b0;
		  address      = 11'b0;
		end
	  end
	  READ1: begin
	    mem_in       = 36'b0;
	    read_buffer  = 1'b0;
		write_buffer = 1'b0;
	    address      = address_reg;
	  end
	  READ2: begin
	    mem_in       = 36'b0;
	    read_buffer  = 1'b0;
		write_buffer = 1'b0;
	    address      = address_reg;
	  end
	    
	  CHECK_UNSAT: begin
	    if(!already_sat ) begin
		  read_buffer = 1'b1;
		  address      = mem_count;
		end
		else if(already_sat & fifo_empty & !bottom)begin
		  read_buffer = 1'b1;
		  address      = mem_count;
		
		end
		else begin
		  read_buffer = 1'b0;
		  address     = 11'b0;
		end
	    write_buffer = 1'b0;
	    mem_in       = 36'b0;
	  end
	  WAIT_GNT: begin
	    address      = 11'b0;
		if(gnt_cnt == 2'b01) begin
	      write_buffer = 1'b1;
		end
		else begin
		  write_buffer = 1'b0;
		end
		read_buffer  = 1'b0;
		mem_in       = packetin;
	  end
	  Write_unsat_buffer: begin
	    address      = 11'b0;
	    write_buffer = 1'b1;
		read_buffer  = 1'b0;
		mem_in       = mem_out;
	  end
	  default: begin
	    address = 11'b0;
		read_buffer = 1'b0;
		mem_in     = 36'b0;
		write_buffer = 1'b0;
	  end
	endcase
  end
  
  always_ff @(posedge clk) begin
    if(rst) begin
      state <= IDLE;
	   //read_buffer  <= 1'b0;
	   //address      <= 11'b0;
	   fifo_req     <= 1'b0;
	   out          <= 36'h0;
	   //write_buffer <= 1'b0;
	   cr_req       <= 1'b0;
	   //mem_in       <= {`dataWidth{1'b0}};
	   gnt_cnt      <= 2'b00;
	   READ2_cnt    <= 2'b00;
	   Read_unsat_buffer_cnt <= 2'b00;
	   WAIT_GNT_cnt      <= 1'b0;
	   WAIT_GNT_to_IDLE_cnt <= 1'b0;
	end
	else begin
      case(state)
	    IDLE: begin
		  //write_buffer <= 1'b0;
		  out          <= 36'h0;
		  //mem_in       <= 36'h0;
		  if(!bottom) begin
            state       <= READ1;
			//read_buffer <= 1'b1;
			address_reg <= random_addr;
			//address     <= random_addr;
	      end
          else if(!fifo_empty) begin
            fifo_req    <= 1'b1;  
			state       <= WAIT_GNT;
			address_reg <= 11'b0;
	      end		  
          else begin
			state <= IDLE;
		  end	
        end
        READ1: begin
		  //read_buffer <= 1'b0;
		  //address     <= address;
		  state       <= READ2;
		end
		
		
		READ2: begin
		  if(READ2_cnt != 2'b10) begin
		    state     <= state;
			READ2_cnt <= READ2_cnt + 1'b1;
			//address   <= address;		
		  end
		  else if(READ2_cnt == 2'b10)begin
		    state     <= CHECK_UNSAT;
			READ2_cnt <= 2'b00;
		  end
          
		end
		CHECK_UNSAT: begin
		  out             <= mem_out;
		  already_sat_reg <= already_sat;
		  case({already_sat,fifo_empty,bottom})
		    3'b100: begin
			  state    <= WAIT_GNT;
			  fifo_req <= 1'b1;
			end
			3'b101: begin
			  state    <= WAIT_GNT;
			  fifo_req <= 1'b1;
			end
			3'b110: begin
			  state       <= Read_unsat_buffer;
		    //  read_buffer <= 1'b1;
			//  address     <= mem_count;
			end
			3'b111: begin
			  state <= IDLE;
			end
			3'b010: begin
			  if(address_reg == mem_count) begin
			    state  <= WAIT_CR;
				cr_req <= 1'b1;
			  end
			  else begin
			    state       <= Read_unsat_buffer;
			//   address     <= mem_count;
			 //   read_buffer <= 1'b1;
			  end
			end
			3'b011: begin
			  if(address_reg == mem_count) begin
			    state  <= WAIT_CR;
				cr_req <= 1'b1;
			  end
			  else begin
			    state       <= Read_unsat_buffer;
			//    address     <= mem_count;
			//    read_buffer <= 1'b1;
			  end
			end
			3'b000: begin
			  if(address_reg == mem_count) begin
			    state    <=  WAIT_GNT;
                fifo_req <= 1'b1;
			  end
			  else begin
			    state       <= Read_unsat_buffer;
			//    address     <= mem_count;
			//    read_buffer <= 1'b1;
			  end	
			end
			3'b001: begin
			  if(address_reg == mem_count) begin
			    state    <=  WAIT_GNT;
                fifo_req <= 1'b1;
			  end
			  else begin
			    state       <= Read_unsat_buffer;
			//    address     <= mem_count;
			//    read_buffer <= 1'b1;
			  end	
			end
		  endcase
		end
		WAIT_GNT: begin
		  
		  if(gnt_cnt == 2'b01) begin
		    if(!already_sat_reg) begin
			  state <= WAIT_CR;
			  cr_req<= 1'b1;
			end
			else begin
			  state <= dummy;
			  cr_req <= 1'b0;
			end
		    //write_buffer <= 1'b1;
		    //read_buffer  <= 1'b0;
			//address      <= address_reg;
			//mem_in       <= packetin;
			fifo_req     <= 1'b0;
			gnt_cnt      <= 2'b00;
	      end
		  else begin
		    gnt_cnt  <= gnt_cnt + 1'b1;
		    fifo_req <= 1'b0;
		    state    <= state;
		  end
		end
		dummy: begin
		  //write_buffer <= 1'b0;
		  state        <= IDLE; 
		end
		Read_unsat_buffer: begin
		  if(Read_unsat_buffer_cnt == 2'b10) begin
		    state <= Write_unsat_buffer;
		//	read_buffer  <= 1'b0;
		   // write_buffer <= 1'b0;
			Read_unsat_buffer_cnt <= 2'b00;
		  end
		  else begin
	        state        <= state;
        //    read_buffer  <= read_buffer;
           // write_buffer <= write_buffer;
            Read_unsat_buffer_cnt <= Read_unsat_buffer_cnt + 1'b1; 			
		  end
		end
		Write_unsat_buffer: begin
		  if(!already_sat_reg) begin
		    state  <= WAIT_CR;
            cr_req <= 1'b1;			
		  end
		  else begin
		    state <= IDLE;
		  end
		  //write_buffer <= 1'b1;
		  //address      <= address_reg;
		  //mem_in       <= mem_out;
		end
		WAIT_CR: begin
		//  write_buffer <= 1'b0;
		//  read_buffer  <= 1'b0;
		  if(cr_gnt) begin
		    cr_req     <= 1'b0;
			state      <= IDLE;
	      end
		  else begin
			state      <= WAIT_CR;
		  end
		end
	  endcase
	end
  end
endmodule
          
          