/*`define dataWidth 36
module fifo_clause_reg( 
  input clk, 
  input rst, 
  input write_req, 
  output logic write_gnt, 
  output logic full, 
  input logic [`dataWidth-1:0] PacketIn,
  input read_req, 
  output logic read_gnt, 
  output logic empty, 
  output logic [`dataWidth-1:0] PacketOut 
);
	
  parameter addressWidth = 5;
  
  logic [addressWidth-1:0] readAddr,writeAddr;
  logic EnableGnt;
  logic [addressWidth:0] read_ptr,write_ptr;
  logic [`dataWidth-1:0] ram [31:0];	
  logic read_buf,write_buf;
  
  assign readAddr = read_ptr [addressWidth-1:0];
  assign writeAddr = write_ptr [addressWidth-1:0];
  assign read_buf = read_req && !empty ;// read signal ... 
  assign write_buf = write_req && !full && !rst;// write signal ... 
  assign full = ( (writeAddr == readAddr) &&(write_ptr[addressWidth] ^ read_ptr[addressWidth]) );	
  assign empty = ( read_ptr == write_ptr ) ; 
  
  
  
  always_ff@(posedge clk) begin
    if(rst)//reset all registers
      begin 
        read_gnt  <= 1'b0; write_gnt <= 1'b0; EnableGnt <= 1'b1;  //DataBuffer = 0;
        write_ptr <= {(addressWidth+1){1'b0}}; //readEnable	 <= 0; writeEnable <= 0; 
		read_ptr <= {(addressWidth+1){1'b0}};  
		PacketOut <= 36'hz;
      end
    else 
      begin 
        if (write_buf)// Buffer not Full
          begin
		    write_gnt 	<= 1'b1;	
			write_ptr <= write_ptr + 11'b1;
		    ram[writeAddr] <= PacketIn;
		  end
		else begin	
		  write_gnt <= 1'b0; //writeEnable <= 0; 
	    end								
// ----------------------------- read process -------------------------- //
			if (read_buf )
				begin						
					 read_gnt <= 1'b1; //readEnable  <= 1;
					 read_ptr <= read_ptr + 11'b1;
			         PacketOut <= ram[readAddr];
				
				end
			else 
			begin	
			  read_gnt	<= 1'b0;  //readEnable  <= 0;
			//  PacketOut <= 36'bz;
            end		
      end 
  end   
endmodule*/