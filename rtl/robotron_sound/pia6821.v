//===========================================================================//
//
// Synthesizble cpu68 core; ported to verilog 01/2013 brad@heeltoe.com
//
//===========================================================================//
//
//  S Y N T H E Z I A B L E    I/O Port   C O R E
//
//  www.OpenCores.Org - May 2004
//  This core adheres to the GNU public license  
//
// File name      : pia6821.vhd
//
// Purpose        : Implements 2 x 8 bit parallel I/O ports
//                  with programmable data direction registers
//                  
// Dependencies   : ieee.Std_Logic_1164
//                  ieee.std_logic_unsigned
//
// Author         : John E. Kent      
//
//===========================================================================////
//
// Revision History:
//
// Date:          Revision         Author
// 1 May 2004     0.0              John Kent
// Initial version developed from ioport.vhd
//
//===========================================================================////
//
// Memory Map
//
// IO + $00 - Port A Data & Direction register
// IO + $01 - Port A Control register
// IO + $02 - Port B Data & Direction Direction Register
// IO + $03 - Port B Control Register
//

module pia6821(
	       input 		clk,
	       input 		rst,
	       input 		cs,
	       input 		rw,
	       input [1:0] 	addr,
	       input [7:0] 	data_in,
	       output reg [7:0] data_out,
	       output 		irqa,
	       output 		irqb,
	       input [7:0] 	pa_i,
	       output [7:0] 	pa_o,
	       input 		ca1,
	       input 		ca2_i,
	       output 		ca2_o,
	       input [7:0] 	pb_i,
	       output [7:0] 	pb_o,
	       input 		cb1,
	       input 		cb2_i,
	       output 		cb2_o
	       );

   reg [7:0] porta_ddr;
   reg [7:0] porta_data;
   reg [5:0] porta_ctrl;
   reg      porta_read;

   reg [7:0] portb_ddr;
   reg [7:0] portb_data;
   reg [5:0] portb_ctrl;
   reg 	     portb_read;
   reg 	     portb_write;

   reg 	     ca1_del   ;
   reg 	     ca1_rise  ;
   reg 	     ca1_fall  ;
   wire      ca1_edge  ;
   reg 	     irqa1     ;

   reg 	     ca2_del   ;
   reg 	     ca2_rise  ;
   reg 	     ca2_fall  ;
   wire	     ca2_edge  ;
   reg 	     irqa2     ;
   reg 	     ca2_out   ;

   reg 	     cb1_del   ;
   reg 	     cb1_rise  ;
   reg 	     cb1_fall  ;
   wire      cb1_edge  ;
   reg 	     irqb1     ;

   reg 	     cb2_del   ;
   reg 	     cb2_rise  ;
   reg 	     cb2_fall  ;
   wire	     cb2_edge  ;
   reg 	     irqb2     ;
   reg 	     cb2_out   ;


   //--------------------------------
   //-- read I/O port
   //--------------------------------

   integer   i;
   integer   count;
   
   always @(addr or cs or
            irqa1 or irqa2 or irqb1 or irqb2 or
            porta_ddr or  portb_ddr or
	    porta_data or portb_data or
	    porta_ctrl or portb_ctrl or
	    pa_i or pb_i )
     begin
	case (addr)
	  2'b00:
	    begin
	       for (count = 0; count < 8; count = count + 1)
		 begin
		    if (porta_ctrl[2] == 1'b0)
		      begin
			 data_out[count] = porta_ddr[count];
			 porta_read = 1'b0;
		      end
		    else
		      begin
			 if (porta_ddr[count])
			   data_out[count] = porta_data[count];
			 else
			   data_out[count] = pa_i[count];
			 porta_read = cs;
		      end
		 end

	       portb_read = 1'b0;
	    end

	  2'b01:
	       begin
		  data_out = { irqa1, irqa2, porta_ctrl };
		  porta_read = 1'b0;
		  portb_read = 1'b0;
	       end
	  
	  2'b10:
	    begin
	       for (count = 0; count < 8; count = count + 1)
		 begin
		    if (portb_ctrl[2] == 1'b0)
		      begin
			 data_out[count] = portb_ddr[count];
			 portb_read = 1'b0;
		      end
		    else
		      begin
			 if (portb_ddr[count])
			   data_out[count] = portb_data[count];
			 else
			   data_out[count] = pb_i[count];
			 portb_read = cs;
		      end
		 end

	       porta_read = 1'b0;
	    end

	  2'b11:
	    begin
	       data_out = { irqb1, irqb2, portb_ctrl };
	       porta_read = 1'b0;
	       portb_read = 1'b0;
	    end

	  default:
	    begin
	       data_out = 8'b0;
	       porta_read = 1'b0;
	       portb_read = 1'b0;
	    end

	endcase
     end // always @ (addr or cs or...
   
//---------------------------------
//-- Write I/O ports
//---------------------------------

always @(posedge clk or posedge rst)
  if (rst)
    begin
       porta_ddr   <= 8'b00000000;
       porta_data  <= 8'b00000000;
       porta_ctrl  <= 6'b000000;
       portb_ddr   <= 8'b00000000;
       portb_data  <= 8'b00000000;
       portb_ctrl  <= 6'b000000;
       portb_write <= 1'b0;
    end
  else
    begin
       if (cs & rw == 1'b0)
	 case (addr)
	   2'b00:
	     begin
		if (porta_ctrl[2] == 1'b0)
		  begin
		     porta_ddr  <= data_in;
		     porta_data <= porta_data;
		  end
		else
		  begin
		     porta_ddr  <= porta_ddr;
		     porta_data <= data_in;
`ifdef debug_pia
		     $display("pia6821: porta_data %x", data_in);
`endif
		  end
		porta_ctrl  <= porta_ctrl;
		portb_ddr   <= portb_ddr;
		portb_data  <= portb_data;
		portb_ctrl  <= portb_ctrl;
		portb_write <= 1'b0;
	     end

	   2'b01:
	     begin
		porta_ddr   <= porta_ddr;
		porta_data  <= porta_data;
		porta_ctrl  <= data_in[5:0];
		portb_ddr   <= portb_ddr;
		portb_data  <= portb_data;
		portb_ctrl  <= portb_ctrl;
		portb_write <= 1'b0;
	     end

	   2'b10:
	     begin
		porta_ddr   <= porta_ddr;
		porta_data  <= porta_data;
		porta_ctrl  <= porta_ctrl;
		if (portb_ctrl[2] == 1'b0)
		  begin
		     portb_ddr   <= data_in;
		     portb_data  <= portb_data;
		     portb_write <= 1'b0;
		  end
		else
		  begin
		     portb_ddr   <= portb_ddr;
		     portb_data  <= data_in;
		     portb_write <= 1'b1;
		  end

		portb_ctrl  <= portb_ctrl;
	     end

	   2'b11:
	     begin
		porta_ddr   <= porta_ddr;
		porta_data  <= porta_data;
		porta_ctrl  <= porta_ctrl;
		portb_ddr   <= portb_ddr;
		portb_data  <= portb_data;
		portb_ctrl  <= data_in[5:0];
		portb_write <= 1'b0;
	     end
	   
	   default:
	     begin
		porta_ddr   <= porta_ddr;
		porta_data  <= porta_data;
		porta_ctrl  <= porta_ctrl;
		portb_ddr   <= portb_ddr;
		portb_data  <= portb_data;
		portb_ctrl  <= portb_ctrl;
		portb_write <= 1'b0;
	     end
	 endcase
       else
	 begin
	    porta_ddr   <= porta_ddr;
	    porta_data  <= porta_data;
	    porta_ctrl  <= porta_ctrl;
	    portb_data  <= portb_data;
	    portb_ddr   <= portb_ddr;
	    portb_ctrl  <= portb_ctrl;
	    portb_write <= 1'b0;
	 end // else: !if(cs & rw == 1'b0)
    end

//---------------------------------
//-- direction control port a
//---------------------------------

   assign pa_o[0] = porta_ddr[0] ? porta_data[0] : 1'bz;
   assign pa_o[1] = porta_ddr[1] ? porta_data[1] : 1'bz;
   assign pa_o[2] = porta_ddr[2] ? porta_data[2] : 1'bz;
   assign pa_o[3] = porta_ddr[3] ? porta_data[3] : 1'bz;
   assign pa_o[4] = porta_ddr[4] ? porta_data[4] : 1'bz;
   assign pa_o[5] = porta_ddr[5] ? porta_data[5] : 1'bz;
   assign pa_o[6] = porta_ddr[6] ? porta_data[6] : 1'bz;
   assign pa_o[7] = porta_ddr[7] ? porta_data[7] : 1'bz;

//---------------------------------
//-- CA1 Edge detect
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    begin
       ca1_del  <= 1'b0;
       ca1_rise <= 1'b0;
       ca1_fall <= 1'b0;
       irqa1    <= 1'b0;
    end
  else
    begin
       ca1_del  <= ca1;
       ca1_rise <= ~ca1_del & ca1;
       ca1_fall <= ca1_del & ~ca1;
       if (ca1_edge)
	 irqa1 <= 1'b1;
       else
	 if (porta_read)
	   irqa1 <= 1'b0;
	 else
	   irqa1 <= irqa1;
    end // else: !if(rst)

   assign ca1_edge = porta_ctrl[1] == 1'b0 ? ca1_fall : ca1_rise;

//---------------------------------
//-- CA2 Edge detect
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    begin
       ca2_del  <= 1'b0;
       ca2_rise <= 1'b0;
       ca2_fall <= 1'b0;
       irqa2    <= 1'b0;
    end
  else
    begin
       ca2_del  <= ca2_i;
       ca2_rise <= ~ca2_del & ca2_i;
       ca2_fall <= ca2_del & ~ca2_i;
       if (porta_ctrl[5] == 1'b0 & ca2_edge)
	 irqa2 <= 1'b1;
       else
	 if (porta_read)
	   irqa2 <= 1'b0;
	 else
	   irqa2 <= irqa2;
    end

   assign ca2_edge = porta_ctrl[4] == 1'b0 ? ca2_fall : ca2_rise;

//---------------------------------
//-- CA2 output control
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    ca2_out <= 1'b0;
  else
    begin
       case (porta_ctrl[5:3])
	 3'b100: // read PA clears, CA1 edge sets
	   if (porta_read)
	     ca2_out <= 1'b0;
	 else
	   if (ca1_edge)
	     ca2_out <= 1'b1;
	   else
	     ca2_out <= ca2_out;
	 3'b101: // read PA clears, E sets
	   ca2_out <= ~porta_read;
	 3'b110: // set low
	   ca2_out <= 1'b0;
	 3'b111: // set high
	   ca2_out <= 1'b1;
	 default: // no change
	   ca2_out <= ca2_out;
       endcase // case (porta_ctrl[5:3])
    end

//---------------------------------
//-- CA2 direction control
//---------------------------------

   assign ca2_o = porta_ctrl[5] ? ca2_out : 1'bz;

//---------------------------------
//-- direction control port b
//---------------------------------

   assign pb_o[0] = portb_ddr[0] ? portb_data[0] : 1'bz;
   assign pb_o[1] = portb_ddr[1] ? portb_data[1] : 1'bz;
   assign pb_o[2] = portb_ddr[2] ? portb_data[2] : 1'bz;
   assign pb_o[3] = portb_ddr[3] ? portb_data[3] : 1'bz;
   assign pb_o[4] = portb_ddr[4] ? portb_data[4] : 1'bz;
   assign pb_o[5] = portb_ddr[5] ? portb_data[5] : 1'bz;
   assign pb_o[6] = portb_ddr[6] ? portb_data[6] : 1'bz;
   assign pb_o[7] = portb_ddr[7] ? portb_data[7] : 1'bz;

//---------------------------------
//-- CB1 Edge detect
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    begin
       cb1_del  <= 1'b0;
       cb1_rise <= 1'b0;
       cb1_fall <= 1'b0;
       irqb1    <= 1'b0;
    end
  else
    begin
       cb1_del  <= cb1;
       cb1_rise <= ~cb1_del & cb1;
       cb1_fall <= cb1_del & ~cb1;
       if (cb1_edge)
	 irqb1 <= 1'b1;
       else
	 if (portb_read)
	   irqb1 <= 1'b0;
	 else
	   irqb1 <= irqb1;
    end

  assign cb1_edge = portb_ctrl[1] == 1'b0 ? cb1_fall : cb1_rise;


//---------------------------------
//-- CB2 Edge detect
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    begin
       cb2_del  <= 1'b0;
       cb2_rise <= 1'b0;
       cb2_fall <= 1'b0;
       irqb2    <= 1'b0;
    end
  else
    begin
       cb2_del  <= cb2_i;
       cb2_rise <= ~cb2_del & cb2_i;
       cb2_fall <= cb2_del & ~cb2_i;
       if (portb_ctrl[5] == 1'b0 & cb2_edge)
	 irqb2 <= 1'b1;
       else
	 if (portb_read)
	   irqb2 <= 1'b0;
	 else
	   irqb2 <= irqb2;
    end

   assign cb2_edge = portb_ctrl[4] == 1'b0 ? cb2_fall : cb2_rise;

//---------------------------------
//-- CB2 output control
//---------------------------------

always @(negedge clk or posedge rst)
  if (rst)
    cb2_out <= 1'b0;
  else
    begin
       case (portb_ctrl[5:3])
	 3'b100: //- write PB clears, CA1 edge sets
	   begin
	      if (portb_write)
		cb2_out <= 1'b0;
	      else
		if (cb1_edge)
		  cb2_out <= 1'b1;
		else
		  cb2_out <= cb2_out;
	   end
	 3'b101: // write PB clears, E sets
	   cb2_out <= ~portb_write;
	 3'b110: // set low
	   cb2_out <= 1'b0;
	 3'b111: // set high
	   cb2_out <= 1'b1;
	 default: // no change
	   cb2_out <= cb2_out;
       endcase
    end
   

//---------------------------------
//-- CB2 direction control
//---------------------------------

   assign cb2_o = portb_ctrl[5] ? cb2_out : 1'bz;
   
//---------------------------------
//-- IRQ control
//---------------------------------

   assign irqa = (irqa1 & porta_ctrl[0]) | (irqa2 & porta_ctrl[3]);
   assign irqb = (irqb1 & portb_ctrl[0]) | (irqb2 & portb_ctrl[3]);

endmodule
