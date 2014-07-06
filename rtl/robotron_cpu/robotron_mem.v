//
// robotron_mem.v
//

//`define debug_read
//`define debug_write

module robotron_mem(
		    input 	  clk,
		    input 	  reset,
		    
		    input 	  MemOE,
		    input 	  MemWR,
		    input [23:1]  MemAdr,
		    input [15:0]  MemDB_in,
		    output [15:0] MemDB_out,

		    input 	  RamCS,
		    input 	  RamLB,
		    input 	  RamUB,

		    input 	  FlashCS
		    );

   reg [7:0] ramh[0:53247];
   reg [7:0] raml[0:53247];

   reg [7:0] rom1[0:4095];
   reg [7:0] rom2[0:4095];
   reg [7:0] rom3[0:4095];
   reg [7:0] rom4[0:4095];
   reg [7:0] rom5[0:4095];
   reg [7:0] rom6[0:4095];
   reg [7:0] rom7[0:4095];
   reg [7:0] rom8[0:4095];
   reg [7:0] rom9[0:4095];
   reg [7:0] roma[0:4095];
   reg [7:0] romb[0:4095];
   reg [7:0] romc[0:4095];
   
   reg [15:0] ram_out;
   wire [15:0] rom_out;
   reg [7:0] rom_data;
   
`ifdef debug
   integer    i;
   
   initial
     for (i = 0; i < 49152; i = i + 1)
       begin
	  ramh[i] = 0;
	  raml[i] = 0;
       end
`endif

`ifndef NO_ROM_INIT
`include "roms.v"
//`include "testroms.v"
`include "cmos.v"
`endif
   
   assign MemDB_out = ~FlashCS ? rom_out :
		      ~RamCS ? ram_out :
		      16'b0;

   assign rom_out = { 4'b0, rom_data[7:4], 4'b0, rom_data[3:0] };
	  
   always @(negedge clk)
     if (reset)
       begin
	  ram_out <= 0;
	  rom_data <= 0;
       end
     else
       begin
`ifdef debug_read
	  if (MemWR && ~FlashCS)
	  case (MemAdr[16:13])
	    4'h0: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom1 [MemAdr[12:1]]);
	    4'h1: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom2 [MemAdr[12:1]]);
	    4'h2: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom3 [MemAdr[12:1]]);
	    4'h3: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom4 [MemAdr[12:1]]);
	    4'h4: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom5 [MemAdr[12:1]]);
	    4'h5: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom6 [MemAdr[12:1]]);
	    4'h6: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom7 [MemAdr[12:1]]);
	    4'h7: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom8 [MemAdr[12:1]]);
	    4'h8: $display("robotron_mem: rom addr=%x => %x", MemAdr,rom9 [MemAdr[12:1]]);
	    4'hd: $display("robotron_mem: rom addr=%x => %x", MemAdr,roma [MemAdr[12:1]]);
	    4'he: $display("robotron_mem: rom addr=%x => %x", MemAdr,romb [MemAdr[12:1]]);
	    4'hf: $display("robotron_mem: rom addr=%x => %x", MemAdr,romc [MemAdr[12:1]]);
	    default: ;
	  endcase
`endif

	  // robotron
	  case (MemAdr[16:13])
	    4'h0: rom_data <= rom1 [MemAdr[12:1]];
	    4'h1: rom_data <= rom2 [MemAdr[12:1]];
	    4'h2: rom_data <= rom3 [MemAdr[12:1]];
	    4'h3: rom_data <= rom4 [MemAdr[12:1]];
	    4'h4: rom_data <= rom5 [MemAdr[12:1]];
	    4'h5: rom_data <= rom6 [MemAdr[12:1]];
	    4'h6: rom_data <= rom7 [MemAdr[12:1]];
	    4'h7: rom_data <= rom8 [MemAdr[12:1]];
	    4'h8: rom_data <= rom9 [MemAdr[12:1]];
	    4'hd: rom_data <= roma [MemAdr[12:1]];
	    4'he: rom_data <= romb [MemAdr[12:1]];
	    4'hf: rom_data <= romc [MemAdr[12:1]];
	    default: rom_data <= 0;
	  endcase

`ifdef debug_write
	  if (~MemWR && ~RamCS)
	    $display("robotron_mem: ram addr=%x <= %x (%b%b)", MemAdr, MemDB_in, RamUB, RamLB);
`endif
`ifdef debug_read
	  if (MemWR && ~RamCS)
	    $display("robotron_mem: ram addr=%x => %x", MemAdr, { ramh[MemAdr[16:1]], raml[MemAdr[16:1]] });
`endif

	  ram_out <= { ramh[MemAdr[16:1]], raml[MemAdr[16:1]] };

	  if (~MemWR && ~RamCS)
	    begin
	       if (~RamUB)
		 ramh[MemAdr[16:1]] <= MemDB_in[15:8];
	       if (~RamLB)
		 raml[MemAdr[16:1]] <= MemDB_in[7:0];
	    end
       end
   
endmodule // robotron_mem
