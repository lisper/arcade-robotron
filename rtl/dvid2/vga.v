// original vhdl from Mike Field <hamster@snap.net.nz>
// VGA timing
// Generates an 640x480 VGA showing all colours

module vga(input pixelClock,
	   input 	reset,
           output [7:0] Red,
           output [7:0] Green,
           output [7:0] Blue,
           output 	hSync,
           output 	vSync,
           output 	blank);

   
   parameter
     hRez       = 640,
     hStartSync = 656,
     hEndSync   = 752,
     hMaxCount  = 800,
     hSyncActive = 1'b0;

   parameter
     vRez       = 480,
     vStartSync = 490,
     vEndSync   = 492,
     vMaxCount  = 525,
     vSyncActive = 1'b1;

   //
   reg [11:0] r_hCounter;
   reg [11:0] r_vCounter;

   reg [7:0]  r_red;
   reg [7:0]  r_green;
   reg [7:0]  r_blue;

   reg 	      r_hSync;
   reg 	      r_vSync;
   reg 	      r_blank;		

   //
   reg [11:0] n_hCounter;
   reg [11:0] n_vCounter;

   reg [7:0]  n_red;
   reg [7:0]  n_green;
   reg [7:0]  n_blue;

   reg        n_hSync;
   reg        n_vSync;
   reg        n_blank;

   // Assign the outputs
   assign hSync = r_hSync;
   assign vSync = r_vSync;
   assign Red   = r_red;
   assign Green = r_green;
   assign Blue  = r_blue;
   assign blank = r_blank;

   always @(*)
     begin
	n_hCounter = r_hCounter;
	n_vCounter = r_vCounter;

	n_red = r_red;
	n_green = r_green;
	n_blue = r_blank;
	n_blue = r_blue;

//	n_hSync = r_hSync;
//	n_vSync = r_vSync;
	n_blank = r_blank;

	n_hSync = ~hSyncActive;      
	n_vSync = ~vSyncActive;      

	// Count the lines and rows      
	if (r_hCounter == hMaxCount-1)
	  begin
             n_hCounter = 0;
             if (r_vCounter == vMaxCount-1)
               n_vCounter = 0;
             else
               n_vCounter = r_vCounter + 12'b000000000001;
	  end
	else
          n_hCounter = r_hCounter + 12'b000000000001;

      if (r_hCounter < hRez && r_vCounter < vRez)
	begin
           n_red   = { n_hCounter[5:0], n_hCounter[5:4] };
           n_green = n_hCounter[7:0];
           n_blue  = n_vCounter[7:0];
           n_blank = 1'b0;
	end
      else
	begin
           n_red   = 0;
           n_green = 0;
           n_blue  = 0;
           n_blank = 1'b1;
	end
      
	// Are we in the hSync pulse?
	if (r_hCounter >= hStartSync && r_hCounter < hEndSync)
          n_hSync = hSyncActive;

	// Are we in the vSync pulse?
	if (r_vCounter >= vStartSync && r_vCounter < vEndSync)
          n_vSync = vSyncActive; 
     end

   always @(posedge pixelClock)
     if (reset)
       begin
	  r_hCounter <= 0;
	  r_vCounter <= 0;
	  r_red <= 0;
	  r_green <= 0;
	  r_blue <= 0;

	  r_hSync <= 0;
	  r_vSync <= 0;
	  r_blank <= 0;
       end
     else
       begin
	  r_hCounter <= n_hCounter;
	  r_vCounter <= n_vCounter;

	  r_red <= n_red;
	  r_green <= n_green;
	  r_blue <= n_blue;

	  r_hSync <= n_hSync;
	  r_vSync <= n_vSync;
	  r_blank <= n_blank;
       end

endmodule // vga

