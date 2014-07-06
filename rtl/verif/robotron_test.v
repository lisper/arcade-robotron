//
//
//

`timescale 1ns/1ns

module robotron_test;
   
   // Inputs
   reg CLK;
   reg RST;

   // BiDirs
   wire [5:0] PB_IN;
   wire       HAND_IN;

   // Outputs
   wire [7:0] DAC_OUT;

   parameter CLK_frequency = 3579545 / 4;
   parameter CLK_period = 1000 /*ms*/ / CLK_frequency;
	 
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
		      .clk_cpu(CLK)
		      .reset(RST),
		      .PB_IN(PB_IN),
		      .HAND_IN(HAND_IN),
		      .DAC_OUT(DAC_OUT)
		      );

   // Clock
   always
     begin
	CLK <= 1'b0;
	#(CLK_period / 2);
	CLK <= 1'b1;
	#(CLK_period / 2);
     end
 

   // Stimulus process
   initial
     begin		
	PB_IN = 6'b111111;
	HAND_IN = 1'b1;
		
	// hold reset state
	RST = 1'b1;
	#(CLK_period * 10);
	RST = 1'b0;
		
	#100 /*100 us*/;
	PB_IN = 6'b111111;
	HAND_IN = 1'b0;
		
	#5000;
	$finish;
     end

endmodule // robotron_test
