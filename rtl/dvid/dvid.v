// original vhdl from Mike Field <hamster@snap.net.nz>
// DVI-D
// Converts VGA signals into DVID bitstreams.
//
//    'clk' and 'clk_n' should be 5x clk_pixel.
//
//    'blank' should be asserted during the non-display portions of the frame

module dvid(input clk,
            input 	clk_n,
            input 	clk_pixel,
	    input 	reset,
            input [7:0] red_p,
            input [7:0] green_p,
            input [7:0] blue_p,
            input 	blank,
            input 	hsync,
            input 	vsync,
            output 	red_s,
            output 	green_s,
            output 	blue_s,
            output 	clock_s);

   wire [9:0] encoded_red, encoded_green, encoded_blue;
   reg [9:0]  latched_red, latched_green, latched_blue;
   reg [9:0]  shift_red,   shift_green,   shift_blue;
   
   reg [9:0]  shift_clock;
   
   wire [1:0] c_red;
   wire [1:0] c_green;
   wire [1:0] c_blue;

   assign c_red = 0;
   assign c_green = 0;
   assign c_blue = { vsync, hsync };

   TDMS_encoder TDMS_encoder_red(.clk(clk_pixel),
				  .data(red_p),
				  .c(c_red),
				  .blank(blank),
				  .encoded(encoded_red));
   
   TDMS_encoder TDMS_encoder_green(.clk(clk_pixel),
				  .data(green_p),
				  .c(c_green),
				  .blank(blank),
				  .encoded(encoded_green));
   
   TDMS_encoder TDMS_encoder_blue(.clk(clk_pixel),
				  .data(blue_p),
				  .c(c_blue),
				  .blank(blank),
				  .encoded(encoded_blue));

   
   ODDR2 #(.DDR_ALIGNMENT("C0"), .INIT(0), .SRTYPE("ASYNC"))
     ODDR2_red (.Q(red_s),
		.D0(shift_red[0]),
		.D1(shift_red[1]),
		.C0(clk),
		.C1(clk_n),
		.CE(1'b1),
		.R(1'b0),
		.S(1'b0));
   
   ODDR2 #(.DDR_ALIGNMENT("C0"), .INIT(1'b0), .SRTYPE("ASYNC"))
     ODDR2_green (.Q(green_s),
		.D0(shift_green[0]),
		.D1(shift_green[1]),
		.C0(clk),
		.C1(clk_n),
		.CE(1'b1),
		.R(1'b0),
		.S(1'b0));

   ODDR2 #(.DDR_ALIGNMENT("C0"), .INIT(1'b0), .SRTYPE("ASYNC"))
     ODDR2_blue (.Q(blue_s),
		.D0(shift_blue[0]),
		.D1(shift_blue[1]),
		.C0(clk),
		.C1(clk_n),
		.CE(1'b1),
		.R(1'b0),
		.S(1'b0));

   ODDR2 #(.DDR_ALIGNMENT("C0"), .INIT(1'b0), .SRTYPE("ASYNC"))
     ODDR2_clock(.Q(clock_s),
		 .D0(shift_clock[0]),
		 .D1(shift_clock[1]),
		 .C0(clk),
		 .C1(clk_n),
		 .CE(1'b1),
		 .R(1'b0),
		 .S(1'b0));
   

   always @(posedge clk_pixel)
     if (reset)
       begin
          latched_red   <= 0;
          latched_green <= 0;
          latched_blue  <= 0;
       end
     else
       begin
          latched_red   <= encoded_red;
          latched_green <= encoded_green;
          latched_blue  <= encoded_blue;
       end

   always @(posedge clk)
     if (reset)
       shift_clock <= 10'b0000011111;
     else
       begin
          if (shift_clock == 10'b0000011111)
	    begin
               shift_red   <= latched_red;
               shift_green <= latched_green;
               shift_blue  <= latched_blue;
	    end
          else
	    begin
               shift_red   <= { 2'b00, shift_red  [9:2] };
               shift_green <= { 2'b00, shift_green[9:2] };
               shift_blue  <= { 2'b00, shift_blue [9:2] };
	    end

          shift_clock <= { shift_clock[1:0], shift_clock[9:2] };
       end

endmodule // dvid
