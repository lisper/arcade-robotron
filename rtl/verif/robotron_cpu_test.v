//-----------------------------------------------------------------------
//--
//-- Copyright 2012 ShareBrained Technology, Inc.
//--
//-- This file is part of robotron-fpga.
//--
//-- robotron-fpga is free software: you can redistribute
//-- it and/or modify it under the terms of the GNU General
//-- Public License as published by the Free Software
//-- Foundation, either version 3 of the License, or (at your
//-- option) any later version.
//--
//-- robotron-fpga is distributed in the hope that it will
//-- be useful, but WITHOUT ANY WARRANTY; without even the
//-- implied warranty of MERCHANTABILITY or FITNESS FOR A
//-- PARTICULAR PURPOSE. See the GNU General Public License
//-- for more details.
//--
//-- You should have received a copy of the GNU General
//-- Public License along with robotron-fpga. If not, see
//-- <http://www.gnu.org/licenses/>.
//--
//-----------------------------------------------------------------------

module robotron_cpu_tb;
   
   parameter CLK_frequency  = 48.0e6;
   parameter CLK_period_f   = 1.0 /*sec*/ / CLK_frequency;
   parameter CLK_period     = CLK_period_f * 1000000000;
    
   reg CLK;
    
   wire [15:0] A;
   wire [7:0]  D_IN;
   wire [7:0]  D_OUT;
   
   wire RESET_N;
   wire NMI_N;
   wire FIRQ_N;
   wire IRQ_N;
   wire HALT_N;

   reg LIC;
   wire AVMA;
   wire	R_W_N;
   wire TSC;
   wire	BA;
   wire	BS;
   reg BUSY;
   wire E;
   wire Q;

   wire MemOE;
   wire MemWR;

   wire RamAdv;
   wire RamCS;
   wire RamClk;
   wire RamCRE;
   wire RamLB;
   wire RamUB;
   wire RamWait;

   wire FlashRp;
   wire FlashCS;
   wire FlashStSts;

   wire [23:1] MemAdr;
   wire [15:0]  MemDB_in;
   wire [15:0] 	MemDB_out;

   wire [6:0]  SEG;
   wire DP;
   wire [3:0] AN;

   wire [7:0] LED;
   reg [7:0]  SW;
   reg [3:0]  BTN;

   wire [2:0] vgaRed;
   wire [2:0] vgaGreen;
   wire [2:0] vgaBlue;
   wire       Hsync;
   wire       Vsync;
    
   //-------------------------------------------------------------------
    
   reg [15:0] bus_address;
   reg        bus_read;
   reg [7:0] bus_data;
   reg      bus_available;
   reg     bus_status;
    
   robotron_cpu uut(
		    .CLK(CLK),
		    .A(A),
		    .D_IN(D_IN),
		    .D_OUT(D_OUT),
		    .RESET_N(RESET_N),
		    .NMI_N(NMI_N),
		    .FIRQ_N(FIRQ_N),
		    .IRQ_N(IRQ_N),
		    .LIC(LIC),
		    .AVMA(AVMA),
		    .R_W_N(R_W_N),
		    .TSC(TSC),
		    .HALT_N(HALT_N),
		    .BA(BA),
		    .BS(BS),
		    .BUSY(BUSY),
		    .E(E),
		    .Q(Q),
		    .MemOE(MemOE),
		    .MemWR(MemWR),
		    .RamAdv(RamAdv),
		    .RamCS(RamCS),
		    .RamClk(RamClk),
		    .RamCRE(RamCRE),
		    .RamLB(RamLB),
		    .RamUB(RamUB),
		    .RamWait(RamWait),
		    .FlashRp(FlashRp),
		    .FlashCS(FlashCS),
		    .FlashStSts(FlashStSts),
		    .MemAdr(MemAdr),
		    .MemDB_in(MemDB_in),
		    .MemDB_out(MemDB_out),
		    .SEG(SEG),
		    .DP(DP),
		    .AN(AN),
		    .LED(LED),
		    .SW(SW),
		    .BTN(BTN),
		    .vgaRed(vgaRed),
		    .vgaGreen(vgaGreen),
		    .vgaBlue(vgaBlue),
		    .Hsync(Hsync),
		    .Vsync(Vsync)
		    );

   //
   wire cpu_clk;
   wire cpu_reset;
   wire cpu_vma;
   wire [15:0] cpu_addr;
   wire cpu_rw;
   wire [7:0] cpu_data_in;
   wire [7:0] cpu_data_out;
   wire       cpu_irq;
   wire       cpu_firq;
   wire       cpu_nmi;
   wire       cpu_halt;
   wire       cpu_hold;

   assign cpu_clk = E/*CLK*/;
   assign cpu_reset = ~RESET_N;

   assign D_IN = cpu_data_out;
   assign cpu_data_in = D_OUT;
   assign A = cpu_addr;

   assign cpu_vma = AVMA;
   assign R_W_N = cpu_rw;
   assign cpu_irq = ~IRQ_N;
   assign cpu_firq = ~FIRQ_N;
   assign cpu_nmi = ~NMI_N;
   assign cpu_halt = ~HALT_N;
   assign cpu_hold = 1'b0;
   
   cpu09 cpu(
	     .clk(cpu_clk),
	     .rst(cpu_reset),
	     .vma(cpu_vma),
	     .addr(cpu_addr),
	     .rw(cpu_rw),
	     .data_out(cpu_data_out),
	     .data_in(cpu_data_in),
	     .irq(cpu_irq),
	     .firq(cpu_firq),
	     .nmi(cpu_nmi),
	     .halt(cpu_halt),
	     .hold(cpu_hold),
//	     .ba_out(BA),
//	     .bs_out(BS)
	     .halted(cpu_halted)
	     );

   assign BA = cpu_halted ? 1'b1 : 1'b0;
   assign BS = cpu_halted ? 1'b1 : 1'b0;

   //
   robotron_mem mem(
		    .clk(CLK),
		    .reset(cpu_reset),
		    .MemOE(MemOE),
		    .MemWR(MemWR),
		    .RamCS(RamCS),
		    .RamLB(RamLB),
		    .RamUB(RamUB),
		    .FlashCS(FlashCS),
		    .MemAdr(MemAdr),
		    .MemDB_in(MemDB_out),
		    .MemDB_out(MemDB_in)
		    );
   
   //
   initial
     begin
	//$timeformat(-9, 0, "ns", 7);
	$dumpfile("robotron_cpu_tb.vcd");
	$dumpvars(0, robotron_cpu_tb);
     end

   always
     begin
        CLK = 1'b0;
        #(CLK_period/2);
        CLK = 1'b1;
        #(CLK_period/2);
     end

   initial
     begin
	$display("CLK_frequency=%10.0f CLK_period=%f CLK_period/2=%f", CLK_frequency, CLK_period, CLK_period/2);
	
	CLK = 0;
`ifdef no_cpu
//	RESET_N = 0;
//	MemDB = 0;
	LIC = 0;
//	AVMA = 0;
//	R_W_N = 0;
//	BA = 0;
//	BS = 0;
	BUSY = 0;
	SW = 0;
	BTN = 0;
	
       //
       @(negedge E);
        
        // E=0 + 0 ns
       #20/*ns*/;

               R_W_N = 'bx;
               A = 'bx;
               BA = 'bx;
               BS = 'bx;
        
        // E=0 + 20 ns
       #10/* ns*/;
//       D = 'bz;

        // E=0 + 30 ns
       #170/* ns;*/

         if (~bus_available)
	   begin
            R_W_N = bus_read;
            A = bus_address;
	   end
         else
	   begin
              R_W_N = 'bz;
              A = 'bz;
	   end

        BA = bus_available;
        BS = bus_status;
        
        // E=0 + 200 ns
       @(posedge Q);
        
        // Q=1
       #200/* ns*/;
        
        // Q=1 + 200 ns
       if (~bus_available)
	 begin
//            if (~bus_read)
//              D = bus_data;
         end
`endif
    end

initial
    begin		
        BTN[0] = 1'b1;
       #100;
        BTN[0] = 1'b0;
        
        @(posedge RESET_N);

`ifdef no_cpu
        @(negedge E);
        bus_available = 1'b0;
        bus_status = 1'b0;
        
        bus_address = 16'hFFFE;
        bus_read = 1'b1;
       bus_data = 'bz;
        
        @(negedge E);
        bus_address = 16'h9000;
        bus_read = 1'b1;
        bus_data = 'bz;
        
        @(negedge E);
        bus_address = 16'h0000;
        bus_read = 1'b0;
        bus_data = 8'h69;
        
        // Turn on ROM PIA CA2
        @(negedge E);
        bus_address = 16'hC80D;
        bus_read = 1'b0;
        bus_data = 8'h3C;

        // IDLE
        @(negedge E);
       bus_address = 'bz;
        bus_read = 1'b1;
        bus_data = 'bz;
        
        // Turn off ROM PIA CA2
        @(negedge E);
        bus_address = 16'hC80D;
        bus_read = 1'b0;
        bus_data = 8'h34;

        // Write BLT
        @(negedge E);
        bus_address = 16'hCA02;
        bus_read = 1'b0;
        bus_data = 8'hD0;

        @(negedge E);
        bus_address = 16'hCA03;
        bus_read = 1'b0;
        bus_data = 8'h00;

        @(negedge E);
        bus_address = 16'hCA04;
        bus_read = 1'b0;
        bus_data = 8'h33;

        @(negedge E);
        bus_address = 16'hCA05;
        bus_read = 1'b0;
        bus_data = 8'h44;

        @(negedge E);
        bus_address = 16'hCA06;
        bus_read = 1'b0;
        bus_data = 8'h00;

        @(negedge E);
        bus_address = 16'hCA07;
        bus_read = 1'b0;
        bus_data = 8'h00;

        @(negedge E);
        bus_address = 16'hCA00;
        bus_read = 1'b0;
        bus_data = 8'h01;

        // IDLE
        @(negedge E);
       bus_address = 'bz;
        bus_read = 1'b1;
       bus_data = 'bz;
       
        // HALT should assert from BLT.
        @(negedge E);
        @(negedge E);
        
        @(negedge E);
        // Release bus to BLT.
        bus_status = 1'b1;
        bus_available = 1'b1;
        
        // HALT should deassert from BLT.
        @(negedge E);
        @(negedge E);
        @(negedge E);
`endif
       
       #50000000;
       $finish;

    end

endmodule // robotron_cpu_test

