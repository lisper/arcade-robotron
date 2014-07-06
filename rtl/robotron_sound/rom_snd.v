//
//
//

module rom_snd(input  clk,
	       input 	    rst,
	       input 	    cs,
	       input [11:0] addr,
	       output [7:0] data
	       );

   wire cs0;
   wire cs1;
   wire [7:0] data0;
   wire [7:0] data1;

   ROM_SND_F000 addr_f000(
			  .clk (clk),
			  .rst (rst),
			  .cs  (cs0),
			  .addr(addr[10:0]),
			  .data(data0)
			  );
   
   ROM_SND_F800 addr_f800(
			  .clk (clk),
			  .rst (rst),
			  .cs  (cs1),
			  .addr(addr[10:0]),
			  .data(data1)
			  );

   assign data = addr[11] ? data1 : data0;
   assign cs0 = addr[11] ? 1'b0 : cs;
   assign cs1 = addr[11] ? cs   : 1'b0;
   
endmodule // rom_snd

