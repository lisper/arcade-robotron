
module m6810(input clk,
             input 	  rst,
             input [6:0]  address,
             input 	  cs,
             input 	  rw,
             input [7:0]  data_in,
             output [7:0] data_out);

   reg [7:0] ram [0:127];
   reg [6:0] address_reg;
   wire      we;
   
   always @(posedge clk)
     begin
	if (we && cs)
	  begin
	     ram[address] <= data_in;
`ifdef debug_ram
	     $display("m6810: ram[%x] <= %x", address, data_in);
`endif
	  end
			
	address_reg <= address;
     end
	
   assign we = ~rw;
   assign data_out = ram[address];

`ifdef debug_ram
   always @(cs or we or address or data_out)
     if (cs && ~we)
       $display("m6810: ram[%x] => %x", address, data_out);
`endif
   
endmodule // m6810


