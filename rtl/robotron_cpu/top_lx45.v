//
// robotron top for Spartan 6 LX45 on pipistrello board
//

`define main_cpu
`define main_display
`define sound_cpu
`define sound_dac
`define hdmi

module top_lx45(
		output [5:1]   led,
		input 	       sysclk,

		output 	       vga_hsync,
		output 	       vga_vsync,
		output 	       vga_r,
		output 	       vga_g,
		output 	       vga_b,

		input 	       switch,
		input [10:0]   Wing_A_in,
		input [6:0]    Wing_B_in,
		output [15:11] Wing_A_out,
   
		output [3:0]   tmds,
		output [3:0]   tmdsb,

		output 	       audio_l,
		output 	       audio_r
		);
   
   wire CLK;
    
   wire [15:0] A;
   wire [7:0]  D_IN;
   wire [7:0]  D_OUT;
   
   wire RESET_N;
   wire NMI_N;
   wire FIRQ_N;
   wire IRQ_N;
   wire HALT_N;

   wire LIC;
   wire AVMA;
   wire	R_W_N;
   wire TSC;
   wire	BA;
   wire	BS;
   wire BUSY;
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
   wire [7:0] SW;
   wire [3:0] BTN;

   wire [2:0] vgaRed;
   wire [2:0] vgaGreen;
   wire [2:0] vgaBlue;
   wire       Hsync;
   wire       Vsync;
   wire       Blank;

   wire [7:0] ja;
   wire [7:0] jb;

   // sounds
   wire       hand;
   wire [5:0] pb;
   wire [7:0] dac;
   
   //-------------------------------------------------------------------

   wire sysclk_buf;
   BUFG sysclk_bufg (.I(sysclk), .O(sysclk_buf));

   assign CLK = sysclk_buf;

   assign vga_hsync = ~Hsync;
   assign vga_vsync = Vsync;
   assign vga_r = vgaRed[2] | vgaRed[1]   | vgaRed[0];
   assign vga_g	= vgaGreen[2] | vgaGreen[1] | vgaGreen[0];
   assign vga_b	= vgaBlue[2]  | vgaBlue[1]  | vgaBlue[0];

   assign led = { LED[7], LED[5], LED[4], LED[3], LED[0] };

`ifdef testing
   assign SW = 8'b0;
   assign BTN = { button3, button2, button1, switch };
//   assign ja = 8'b0;
//   assign jb = 8'b0;
   assign ja = ~8'h10;
   assign jb = ~8'h20;
`else
   assign SW = 8'b0;
   assign BTN = { Wing_A_in[1], Wing_A_in[2], Wing_A_in[0], switch };

   assign ja = { Wing_A_in[8], Wing_A_in[7], Wing_A_in[10], Wing_A_in[9],
		 Wing_A_in[4], Wing_A_in[3], Wing_A_in[6], Wing_A_in[5] };

   assign jb = ~8'h00;

   assign Wing_A_out[11] = LED[0];
   assign Wing_A_out[12] = LED[3];
   assign Wing_A_out[13] = LED[4];
   assign Wing_A_out[14] = LED[5];
   assign Wing_A_out[15] = LED[6];
`endif // !`ifdef testing
   
`ifdef main_display
   //
   assign LIC = 1'b0;
   assign BUSY = 1'b0;
   wire cpu_clk_in;

   wire clk_vga;

   robotron_cpu uut(
		    .CLK(CLK),
		    .cpu_clk_in(cpu_clk_in),
		    .vga_clk_in(clk_vga),
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
		    .Blank(Blank),
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
`else // !`ifdef main_display
   assign cpu_reset = dcm_reset;
`endif
   
`ifdef main_cpu
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
`endif
   
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

`ifdef sound_cpu
   //
   robotron_sound sound(
			.clk_fast(1'b0),
			.clk_cpu(cpu_clk),
			.reset(cpu_reset),
			.pb(pb),
			.hand(hand),
			.dac(dac)
			);
`else
   assign dac = 8'b0;
`endif

`ifdef sound_dac
   //
   wire dac_o;
   
   ds_dac ds_output(.clk_i(sysclk_buf),
		    .res_i(cpu_reset),
		    .dac_i(dac),
		    .dac_o(dac_o)
		    );

   assign audio_l = dac_o;
   assign audio_r = dac_o;
   
`else
   assign audio_l = dac[1] | dac[4];
   assign audio_r = dac[1] | dac[4];
`endif
   
`ifdef hdmi
   //
   wire dvid_hsync, dvid_vsync, dvid_blank;
   wire [7:0] dvid_red;
   wire [7:0] dvid_green;
   wire [7:0] dvid_blue;
   wire       dcm_reset;
   reg [3:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[3];
   initial reset_reg = 4'b1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[2:0],1'b0};

   //
   // 12mhz clock, 83ns
   // video counter; 0..16639
   // video addres
   // 11111
   // 432109876543210
   // xxxxxxxxxx1110x hsync 001e
   // x11111xxxxxxxxx vsync
   // 1xxxxxxxxxxxxxx mask
   // 011111100000000 mask

   // x11 111x xxxx xxxx vsync
   //
   // 111111000000000
   // 7  e   0   0	7300 32256
   // 100000011111111
   // 4  0   f   f      40ff 16639
   //
   //
   // 32 x 1000ns = 32us / line
   // 16640 x 1000ns = 16.640us / frame

   //
   assign dvid_red   = (vgaRed == 3'b0)   ? 8'b0 : { vgaRed,   5'b11111 };
   assign dvid_green = (vgaGreen == 3'b0) ? 8'b0 : { vgaGreen, 5'b11111 };
   assign dvid_blue  = (vgaBlue == 3'b0)  ? 8'b0 : { vgaBlue,  5'b11111 };
   
   assign dvid_hsync = Hsync;
   assign dvid_vsync = Vsync;
   assign dvid_blank = Blank;

   dvid_output hdmi(.clk50(sysclk_buf),
		    .reset(/*cpu_reset*/dcm_reset),
		    .reset_clk(dcm_reset),
		    .red(dvid_red),
		    .green(dvid_green),
		    .blue(dvid_blue),
		    .hsync(dvid_hsync),
		    .vsync(dvid_vsync),
		    .blank(dvid_blank),
		    .clk_vga(clk_vga),
		    .clk_cpu(cpu_clk_in),
		    .TMDS(tmds),
		    .TMDSB(tmdsb));
`else // !`ifdef hdmi

   wire       LOCKED;
   wire       dcm_reset;
   reg [3:0]  reset_reg;

   // quick reset
   assign dcm_reset = reset_reg[3];
   initial reset_reg = 4'b1111;
		     
   always @ (posedge sysclk_buf)
     reset_reg <= {reset_reg[2:0],1'b0};

   wire [15:0] do_unused;
   wire        drdy_unused;
   wire        clkfbout;
   wire        clkout2_unused, clkout3_unused, clkout4_unused, clkout5_unused;

  PLL_BASE
  #(.BANDWIDTH              ("OPTIMIZED"),
    .CLK_FEEDBACK           ("CLKFBOUT"),
    .COMPENSATION           ("INTERNAL"),
    .DIVCLK_DIVIDE          (1),
    .CLKFBOUT_MULT          (12),
    .CLKFBOUT_PHASE         (0.000),

    .CLKOUT0_DIVIDE         (24),
    .CLKOUT0_PHASE          (0.000),
    .CLKOUT0_DUTY_CYCLE     (0.500),

    .CLKOUT1_DIVIDE         (50),
    .CLKOUT1_PHASE          (0.000),
    .CLKOUT1_DUTY_CYCLE     (0.500),

    .CLKIN_PERIOD           (20.000),
    .REF_JITTER             (0.010))
  pll_base_inst
    // Output clocks
   (.CLKFBOUT              (clkfbout),
    .CLKOUT0               (clkout0),
    .CLKOUT1               (clkout1),
    .CLKOUT2               (clkout2_unused),
    .CLKOUT3               (clkout3_unused),
    .CLKOUT4               (clkout4_unused),
    .CLKOUT5               (clkout5_unused),
    // Status and control signals
    .LOCKED                (LOCKED),
    .RST                   (dcm_reset),
     // Input clock control
    .CLKFBIN               (clkfbout),
    .CLKIN                 (sysclk_buf));

  BUFG clkout0_buf (.O(clk_vga), .I(clkout0));
  BUFG clkout1_buf (.O(cpu_clk_in), .I(clkout1));

`endif
   
endmodule
