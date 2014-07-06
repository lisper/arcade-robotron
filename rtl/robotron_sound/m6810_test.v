//
//
//

`timescale 1ns/1ns

module m6810_test();
   
   // Inputs
   reg clk;
   reg rst;
   reg [6:0] address;
   reg cs;
   reg rw;
   reg [7:0] data_in;

   // Outputs
   wire [7:0]  data_out;

   // Clock period definitions
   parameter clk_period = (279.365 /*ns*/ * 4);
	
   wire phase_1;
   wire phase_2;
   wire E;

   // Clock
   always
     begin
	clk <= 1'b0;
	#(clk_period/2);
	clk <= 1'b1;
	#(clk_period/2);
     end

   assign phase_1 = clk;
   assign phase_2 = ~phase_1;
   assign E = phase_2;
	
   // Instantiate the Unit Under Test (UUT)
   m6810 uut(
             .clk(clk),
             .rst(rst),
             .address(address),
             .cs(cs),
             .rw(rw),
             .data_in(data_in),
             .data_out(data_out)
             );
 
   // Stimulus process
   initial
     begin
	// RESET
	$display("reset...");
	rw <= 1'b1;
	rst <= 1'b1;
	#(clk_period*10);
	rst <= 1'b0;

	// WRITE
	$display("write...");
	@(negedge E);
	#((clk_period / 2) - 160/*ns*/);
	address <= 7'h36;
	cs <= 1'b1;
	rw <= 1'b0;
		
	@(posedge E);
	#225/*ns*/;
	data_in <= 8'h5a;
		
	@(negedge E);
	#20/*ns*/;
	cs <= 1'b0;
	address <= 7'bZZZZZZZ;
	rw <= 1'b1;
	#10/*ns*/;
	data_in <= 8'bzzzzzzzz;		
		
	// READ
	$display("read...");
	@(negedge E);
	#((clk_period / 2) - 160/*ns*/);
	address <= 7'h26;
	cs <= 1'b1;
	rw <= 1'b1;

	@(posedge E);
	#((clk_period / 2) - 100/*ns*/);
	// sample data_out
	@(negedge E);
	#10/*ns*/;
	// sample data_out
	$display("read %x -> %x", address, data_out);
	
	#10/*ns*/;
	cs <= 1'b0;
	address <= 7'bzzzzzzz;
	rw <= 1'b0;
		
	// READ
	@(negedge E);
	#((clk_period / 2) - 160/*ns*/);
	address <= 7'h36;
	cs <= 1'b1;
	rw <= 1'b1;

	@(posedge E);
	#((clk_period / 2) - 100/*ns*/);
	// sample data_out
	@(negedge E);
	#10/*ns*/;
	// sample data_out
	$display("read %x -> %x", address, data_out);
	#10/*ns*/;
	cs <= 1'b0;
	address <= 7'bzzzzzzz;
	rw <= 1'b0;

	$display("done...");
	$finish;
     end

endmodule

