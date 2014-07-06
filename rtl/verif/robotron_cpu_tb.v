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
    
   reg [7:0]  ja;
   reg [7:0]  jb;

   // sounds
   wire       hand;
   wire [5:0] pb;
   wire [7:0] dac;
   
   //-------------------------------------------------------------------
    
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
		    .Vsync(Vsync),
		    .JA(ja),
		    .JB(jb),
		    .hand_out(hand),
		    .pb_out(pb)
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
   wire       cpu_halted;
   wire       cpu_ba;
   wire       cpu_bs;
   
   assign cpu_clk = E;
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
	     .ba_out(cpu_ba),
	     .bs_out(cpu_bs),
	     .halted(cpu_halted)
	     );

   assign BA = cpu_ba;
   assign BS = cpu_bs;

   //
   robotron_mem mem(
		    .clk(RamClk),
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
   
//`define sound
`ifdef sound
   //
   robotron_sound sound(
			.clk_fast(1'b0),
			.clk_cpu(cpu_clk),
			.reset(cpu_reset),
			.pb(pb),
			.hand(hand),
			.dac(dac)
			);
`endif   

   //
   initial
     begin
	//$timeformat(-9, 0, "ns", 7);
	$dumpfile("robotron_cpu_tb.vcd");
	$dumpvars(0, robotron_cpu_tb);
     end

   integer show_pc;
   
   //
   always @(posedge cpu_clk)
     if (show_pc)
       $display("%0t; pc=%x A=%x B=%x X=%x Y=%x SP=%x UP=%x cc=%x",
		$time,
		cpu.pc,
		cpu.acca,
		cpu.accb,
		cpu.xreg,
		cpu.yreg,
		cpu.sp,
		cpu.up,
		cpu.cc);
   
   //
   always
     begin
        CLK = 1'b0;
        #(CLK_period/2);
        CLK = 1'b1;
        #(CLK_period/2);
     end

   //
   initial
     begin		
	$display("CLK_frequency=%10.0f CLK_period=%f CLK_period/2=%f",
		 CLK_frequency, CLK_period, CLK_period/2);
	show_pc = 0;
	
	CLK = 0;
	SW = 8'b0;
	ja = 8'b0;
	jb = 8'b0;

        BTN[0] = 1'b1;
       #100;
        BTN[0] = 1'b0;
        
       #50000000;
       $finish;
    end

endmodule // robotron_cpu_test

