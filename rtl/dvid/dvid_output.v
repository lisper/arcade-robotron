// original vhdl from Mike Field <hamster@snap.net.nz>
// dvid_test 
// Top level design for testing my DVI-D interface

module dvid_output(input clk50,
		   input 	reset,
		   input 	reset_clk,
		   input [7:0] 	red,
		   input [7:0] 	green,
		   input [7:0] 	blue,
		   input 	hsync,
		   input 	vsync,
		   input 	blank,
		   output 	clk_vga,
		   output [3:0] TMDS,
		   output [3:0] TMDSB);

   wire clk_dvi_p;
   wire clk_dvi_n;
//   wire clk_vga;

   wire       red_s;
   wire       green_s;
   wire       blue_s;
   wire       clock_s;
   wire       locked;
   

   clocking120 clocking_inst(
			     .CLK_50(clk50),
			     .CLK_DVI_P(clk_dvi_p), // for 640x480@60Hz : 120MHZ
			     .CLK_DVI_N(clk_dvi_n), // 120MHz, 180 degree phase shift
			     .CLK_VGA(clk_vga),     // for 640x480@60Hz : 24MHZ
			     .RESET(reset_clk),
			     .LOCKED(locked)
			     );

   dvid dvid_inst(
		  .clk      (clk_dvi_p),
		  .clk_n    (clk_dvi_n), 
		  .clk_pixel(clk_vga),
		  .reset    (reset),
		  .red_p    (red),
		  .green_p  (green),
		  .blue_p   (blue),
		  .blank    (blank),
		  .hsync    (hsync),
		  .vsync    (vsync),
		  // outputs to TMDS drivers
		  .red_s    (red_s),
		  .green_s  (green_s),
		  .blue_s   (blue_s),
		  .clock_s  (clock_s)
		  );
      
   OBUFDS OBUFDS_blue  ( .O(TMDS[0]), .OB(TMDSB[0]), .I(blue_s ) );
   OBUFDS OBUFDS_red   ( .O(TMDS[1]), .OB(TMDSB[1]), .I(green_s) );
   OBUFDS OBUFDS_green ( .O(TMDS[2]), .OB(TMDSB[2]), .I(red_s  ) );
   OBUFDS OBUFDS_clock ( .O(TMDS[3]), .OB(TMDSB[3]), .I(clock_s) );

endmodule // dvid_test

