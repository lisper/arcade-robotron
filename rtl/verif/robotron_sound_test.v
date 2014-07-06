//
// robotron_sound_test.v
// testbench
//

`timescale 1ns / 1ns

module robotron_sound_test;
   
   // Inputs
   reg CLK;
   reg RST;

   // BiDirs
   reg [5:0] PB_IN;
   reg      HAND_IN;

   // Outputs
   wire [7:0] DAC_OUT;

   parameter CLK_frequency = 3579545 / 4;
   parameter CLK_period = 1000000000 /*ns*/ / CLK_frequency;
	 
   task dac_task;
      begin
	 //file dac_out_file : text is out "dac_out-111111.txt";
	 //variable dac_out_line : line;

	 //if (1)
	 //begin
	 //	      write(dac_out_line, now);
	 //write(dac_out_line, HT);
	 //write(dac_out_line, DAC_OUT);
	 //writeline(dac_out_file, dac_out_line);
	 //end
      end
   endtask // dac_task

   // Instantiate the Unit Under Test (UUT)
   robotron_sound uut(
		      .clk_fast(CLK),
		      .clk_cpu(CLK),
		      .reset(RST),
		      .pb(PB_IN),
		      .hand(HAND_IN),
		      .dac(DAC_OUT)
		      );
   
   //
   initial
     begin
	$timeformat(-9, 0, "ns", 7);
	$dumpfile("robotron_sound_test.vcd");
	$dumpvars(0, robotron_sound_test);
     end

   // Clock
   always
     begin
	CLK = 1'b0;
	#(CLK_period / 2);
	CLK = 1'b1;
	#(CLK_period / 2);
     end
 

   // Stimulus process
   initial
     begin
	$display("CLK_frequency %d, CLK_period %d, Clk_period/2",
		 CLK_frequency, CLK_period, CLK_period/2);

	$display("starting...");
	PB_IN = 6'b111111;
	HAND_IN = 1'b1;

	$display("reset...");
	// hold reset state
	RST = 1'b1;
	#(CLK_period * 10);
	RST = 1'b0;
		
	$display("run... %t", $time);
	#100000; /*100 us*/;
//	PB_IN = 6'b111111;
	PB_IN = 6'b111100;
	$display("hand... %t", $time);
	HAND_IN = 1'b0;

	$display("waiting...");
	#50000000;
	$finish;
     end

endmodule // robotron_test
