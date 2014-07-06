//
// robotron_sound.v
//

module robotron_sound(
		      input 	   clk_fast,
		      input 	   clk_cpu,
		      input 	   reset,
		      input [5:0]  pb,
		      input 	   hand,
		      output [7:0] dac
		      );

   wire [15:0] CPU_ADDRESS_OUT;
   reg  [7:0]  CPU_DATA_IN;
   wire [7:0]  CPU_DATA_OUT;
   wire CPU_RW;
   wire CPU_IRQ;
   wire CPU_VMA;
   wire CPU_HALT;
   wire CPU_HOLD;
   wire CPU_NMI;
   
   wire ROM_CS;
   wire [7:0] ROM_DATA_OUT;
   
   wire RAM_CS;
   wire RAM_RW;
   wire [7:0] RAM_DATA_IN;
   wire [7:0] RAM_DATA_OUT;
   
   wire PIA_RW;
   wire PIA_CS;
   wire PIA_IRQA;
   wire PIA_IRQB;
   wire [7:0] PIA_DATA_IN;
   wire [7:0] PIA_DATA_OUT;
   wire PIA_CA1;
   wire PIA_CB1;
   wire PIA_CA2_I;
   wire PIA_CA2_O;
   wire PIA_CB2_I;
   wire PIA_CB2_O;
   wire [7:0] PIA_PA_I;
   wire [7:0] PIA_PA_O;
   wire [7:0] PIA_PB_I;
   wire [7:0] PIA_PB_O;
   
   wire [3:0] BCD_DEMUX_INPUT;
   wire [9:0] BCD_DEMUX_OUTPUT;
   
   wire SPEECH_CLOCK;
   wire SPEECH_DATA;

   wire [15:0] test_alu;
   wire [7:0] test_cc;

   //
   assign CPU_HALT = 1'b0;
   assign CPU_HOLD = 1'b0;
   assign CPU_NMI = 1'b0;
   
   assign SPEECH_CLOCK = 1'b0;
   assign SPEECH_DATA = 1'b0;
   
   cpu68 CPU(.clk(clk_cpu),
             .data_in(CPU_DATA_IN),
             .halt(CPU_HALT),
             .hold(CPU_HOLD),
             .irq(CPU_IRQ),
             .nmi(CPU_NMI),
             .rst(reset),
             .address(CPU_ADDRESS_OUT),
             .data_out(CPU_DATA_OUT),
             .rw(CPU_RW),
             .test_alu(test_alu),
             .test_cc(test_cc),
             .vma(CPU_VMA));
                
   assign CPU_IRQ = PIA_IRQA | PIA_IRQB;

   always @(PIA_CS or PIA_DATA_OUT or RAM_CS or RAM_DATA_OUT or ROM_DATA_OUT)
     begin
	if (PIA_CS == 1'b1)
          CPU_DATA_IN = PIA_DATA_OUT;
	else
	  if (RAM_CS == 1'b1)
	    CPU_DATA_IN = RAM_DATA_OUT;
	  else
            CPU_DATA_IN = ROM_DATA_OUT;
     end

   
   m6810 RAM(.clk(clk_cpu),
             .rst(reset),
             .address(CPU_ADDRESS_OUT[6:0]),
             .cs(RAM_CS),
             .rw(RAM_RW),
             .data_in(RAM_DATA_IN),
             .data_out(RAM_DATA_OUT));
   
   assign RAM_CS = ~CPU_ADDRESS_OUT[8] &
		   ~CPU_ADDRESS_OUT[9] &
		   ~CPU_ADDRESS_OUT[10] &
		   ~CPU_ADDRESS_OUT[11]
                   & ~BCD_DEMUX_OUTPUT[8]
                   & CPU_VMA;

   assign RAM_RW = CPU_RW;
   assign RAM_DATA_IN = CPU_DATA_OUT;
   
   pia6821 PIA(.addr(CPU_ADDRESS_OUT[1:0]),
               .ca1(PIA_CA1),
               .cb1(PIA_CB1),
                .clk(clk_cpu),
                .cs(PIA_CS),
                .data_in(PIA_DATA_IN),
                .rst(reset),
                .rw(PIA_RW),
                .data_out(PIA_DATA_OUT),
                .irqa(PIA_IRQA),
                .irqb(PIA_IRQB),
                .ca2_i(PIA_CA2_I),
                .ca2_o(PIA_CA2_O),
                .cb2_i(PIA_CB2_I),
                .cb2_o(PIA_CB2_O),
                .pa_i(PIA_PA_I),
                .pa_o(PIA_PA_O),
                .pb_i(PIA_PB_I),
                .pb_o(PIA_PB_O)
                );
   
   assign PIA_CA1 = 1'b1;
   assign PIA_CA2_I = SPEECH_DATA;
   assign PIA_CB1 = ~(hand & pb[5] & pb[4] & pb[3] & pb[2] & pb[1] & pb[0]);
   assign PIA_CB2_I = SPEECH_CLOCK;
   assign PIA_CS = (~(BCD_DEMUX_OUTPUT[0] & BCD_DEMUX_OUTPUT[8]))
		      & CPU_ADDRESS_OUT[10]
		      & CPU_VMA;
   assign PIA_DATA_IN = CPU_DATA_OUT;
   assign PIA_RW = CPU_RW;
   assign PIA_PA_I = 8'b00000000;
   assign dac = PIA_PA_O;
   assign PIA_PB_I[5:0] = pb[5:0];
   assign PIA_PB_I[6] = 1'b0;
   assign PIA_PB_I[7] = 1'b0;

`ifdef debug_pia
   always @(posedge clk_cpu)
     if (PIA_CS)
       begin
	  if (PIA_RW)
	    $display("pia6821: R @ %x => %x", CPU_ADDRESS_OUT, PIA_DATA_OUT);
	  else
	    $display("pia6821: W @ %x <= %x", CPU_ADDRESS_OUT, PIA_DATA_IN);
       end
`endif

`ifdef debug
   reg old_PIA_CB1, old_hand;
   reg [5:0] old_pb;

   always @(posedge clk_cpu)
     begin
	if (old_PIA_CB1 != PIA_CB1)
	  $display("soundboard: PIA_CB1 change %b", PIA_CB1);

	if (old_hand != hand)
	  $display("soundboard: hand change %b", hand);

	if (old_pb != pb)
	  $display("soundboard: pb change %x", pb);

	old_PIA_CB1 <= PIA_CB1;
	old_hand <= hand;
	old_pb <= pb;
     end
`endif
   
   rom_snd ROM(.addr(CPU_ADDRESS_OUT[11:0]),
               .clk(clk_cpu),
               .cs(ROM_CS),
               .rst(reset),
               .data(ROM_DATA_OUT));
   
   assign ROM_CS = ~BCD_DEMUX_OUTPUT[7] & CPU_VMA;
   
   logic7442 BCD_DEMUX(.in(BCD_DEMUX_INPUT),
		       .out(BCD_DEMUX_OUTPUT));
   
   assign BCD_DEMUX_INPUT = { ~CPU_ADDRESS_OUT[15], CPU_ADDRESS_OUT[14:12] };

endmodule
