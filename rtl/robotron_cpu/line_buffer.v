//
//
//

module line_buffer(
		   input 	pixclk,
		   input 	reset,

		   // output
		   input [11:0] hcount_2,
		   input [11:0] vcount_2,
		   input 	hsync_2,
		   input 	vsync_2,
		   output [2:0] red_2,
		   output [2:0] grn_2,
		   output [2:0] blu_2,

		   // input
		   input [11:0] hcount_1,
		   input [11:0] vcount_1,
		   input 	hsync_1,
		   input 	vsync_1,
		   input [2:0] 	red_1,
		   input [2:0] 	grn_1,
		   input [2:0] 	blu_1,
		   input [3:0] 	hoffset_1
		  );

   reg [8:0] line[0:2047];

   wire [10:0] w_addr;
   wire [10:0] r_addr;
   
   wire       oline, iline;
   wire [8:0] w_data;

   reg [8:0]  r_data;

   
   assign oline = vcount_2[0];
   assign iline = ~vcount_2[0];

   //xxxx 6 pixels come out for each hcount_1
   //xxxx 12 clocks, so one pixel each 2x clocks
   
   wire [9:0] hcountx12, hcountx4, hcountx12po;
   assign hcountx4 = { 3'b0, hcount_1[4:0], 2'b0 };
   assign hcountx12 = hcountx4 + hcountx4 + hcountx4;
   assign hcountx12po = hcountx12 + { 6'b0, hoffset_1 };

   assign w_addr = { iline, hcountx12po };
   assign w_data = { red_1, grn_1, blu_1 };

   assign r_addr = { oline, hcount_2[9:0] };

   assign red_2 = r_data[8:6];
   assign grn_2 = r_data[5:3];
   assign blu_2 = r_data[2:0];

   always @(posedge pixclk)
     if (reset)
       r_data <= 0;
     else
       begin
	  line[w_addr] <= w_data;
	  r_data <= line[r_addr];
       end
   
endmodule // line_buffer
