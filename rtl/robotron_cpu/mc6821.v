//-----------------------------------------------------------------------
//--
//-- Copyright 2012 ShareBrained Technology, Inc.
//--
//-- This file is part of robotron-fpga.
//--
//-- robotron-fpga is free software: you can redistribute
//-- it and/or modify it under the terms of the GNU General
//-- Public License as published by the Free Software
//-- Foundation, either version 3 of the License, or (at your
//-- option) any later version.
//--
//-- robotron-fpga is distributed in the hope that it will
//-- be useful, but WITHOUT ANY WARRANTY; without even the
//-- implied warranty of MERCHANTABILITY or FITNESS FOR A
//-- PARTICULAR PURPOSE. See the GNU General Public License
//-- for more details.
//--
//-- You should have received a copy of the GNU General
//-- Public License along with robotron-fpga. If not, see
//-- <http://www.gnu.org/licenses/>.
//--
//-----------------------------------------------------------------------

module mc6821(
              input 	   reset,
              input 	   clock,
              input 	   e_sync,
              
              input [1:0]  rs,
              input 	   cs,
              input 	   write,
              
              input [7:0]  data_in,
              output [7:0] data_out,
              
	      input 	   ca1,
              input 	   ca2_in,
              output 	   ca2_out,
              output 	   ca2_dir,
              output 	   irq_a,
              input [7:0]  pa_in,
              output [7:0] pa_out,
              output [7:0] pa_dir,
              
              input 	   cb1,
              input 	   cb2_in,
              output 	   cb2_out,
              output 	   cb2_dir,
              output 	   irq_b,
              input [7:0]  pb_in,
              output [7:0] pb_out,
	      output [7:0] pb_dir
	      );

   wire read;
   
   reg ca1_q;
   reg ca2_q;
   reg cb1_q;
   reg cb2_q;
   
   reg [7:0] output_a;
   reg [7:0] ddr_a;
   wire [7:0] cr_a;

   reg       irqa_1_intf;
   reg       irqa_2_intf;
   reg 	     ca2_is_output;
   reg 	     cr_a_4;
   reg 	     cr_a_3;
   reg 	     output_a_access;
   reg	     ca1_edge;
   wire      ca2_edge;
   reg 	     ca1_int_en;
   wire      ca2_int_en;
   wire      ca2_in_gated;
   reg      ca2_out_value;

   reg [7:0]  output_b;
   reg [7:0]  ddr_b;
   wire [7:0] cr_b;

   reg       irqb_1_intf;
   reg 	     irqb_2_intf;
   reg 	     cb2_is_output;
   reg 	     cr_b_4;
   reg 	     cr_b_3;
   reg 	     output_b_access;
   reg      cb1_edge;
   wire	     cb2_edge;
   reg      cb1_int_en;
   wire	     cb2_int_en;
   wire       cb2_in_gated;
   reg       cb2_out_value;


   //
   assign irq_a = ((irqa_1_intf & ca1_int_en) |
		   (irqa_2_intf & ca2_int_en));

   assign irq_b = ((irqb_1_intf & cb1_int_en) |
		   (irqb_2_intf & cb2_int_en));
   
   assign ca2_out = ca2_out_value;
   assign ca2_dir = ca2_is_output;
   
   assign cb2_out = cb2_out_value;
   assign cb2_dir = cb2_is_output;
   
   assign read = ~write;
   
   assign pa_out = output_a;
   assign pa_dir = ddr_a;
   
   assign pb_out = output_b;
   assign pb_dir = ddr_b;
   
   assign cr_a = { irqa_1_intf, irqa_2_intf, ca2_is_output, cr_a_4,
		   cr_a_3, output_a_access, ca1_edge, ca1_int_en };

   assign cr_b = { irqb_1_intf, irqb_2_intf, cb2_is_output, cr_b_4,
		   cr_b_3, output_b_access, cb1_edge, cb1_int_en };
   
   // TODO: Port B reads from output data register, not from pin state.
   
   assign data_out =
		    (rs == 2'b00 && output_a_access)  ? pa_in :
                    (rs == 2'b00 && ~output_a_access) ? ddr_a :
                    (rs == 2'b01)                     ? cr_a :
                    (rs == 2'b10 && output_b_access)  ? pb_in :
                    (rs == 2'b10 && ~output_b_access) ? ddr_b :
                    (rs == 2'b11)                     ? cr_b :
                    8'b0;
   
   
   assign ca2_edge = cr_a_4;
   assign cb2_edge = cr_b_4;
   
   assign ca2_int_en = cr_a_3 & ~ca2_is_output;
   assign cb2_int_en = cr_b_3 & ~cb2_is_output;
   
   //-------------------------------------------------------------------
   // Effects of register reads.
   // See elsewhere, this is not the only place.

   always @(posedge clock or posedge reset)
     if (reset)
       begin
       end
     else
       begin
	  if (cs && read)
            case (rs)
              2'b00:
		// TODO: Crazy CA2 output handling
		//if (ddr_a_access == 1'b0)
		//    if (ca2_is_output && cr_a_4 == 1'b0)
		//        ca2_output <= 1'b0;
		;
	      
              2'b01:
		;  // Do nothing!
              
              2'b10:
		// TODO: Crazy CB2 output handling
		//if (ddr_b_access == 1'b0)
		//    if (cb2_is_output && cr_b_4 == 1'b0)
		//        cb2_output <= 1'b0;
		;
	      
              2'b11:
		;  // Do nothing!

              default:
		;  // Do nothing!
            endcase
       end // else: !if(reset)
   
   //-------------------------------------------------------------------
   // Register writes.

   always @(posedge clock or posedge reset)
     if (reset)
       begin
	  output_a <= 0;
	  ddr_a <= 0;

	  output_b <= 0;
	  ddr_b <= 0;

	  cr_a_4 <= 0;
	  cr_a_3 <= 0;
	  output_a_access <= 0;
	  ca1_edge <= 0;
	  ca1_int_en <= 0;

	  ca2_is_output <= 0;
	  ca2_out_value <= 0;

	  cr_b_4 <= 0;
	  cr_b_3 <= 0;
	  output_b_access <= 0;
	  cb1_edge <= 0;
	  cb1_int_en <= 0;
          
	  cb2_is_output <= 0;
	  cb2_out_value <= 0;
       end
     else
       begin
          if (cs && write)
            case (rs)
              2'b00:
		begin
                   if (output_a_access)
                     output_a <= data_in;
                   else
                     ddr_a <= data_in;
                end
              
              2'b01:
		begin
                   ca2_is_output <= data_in[5];
                   cr_a_4 <= data_in[4];
                   cr_a_3 <= data_in[3];
                   output_a_access <= data_in[2];
                   ca1_edge <= data_in[1];
                   ca1_int_en <= data_in[0];
                   
                   if (data_in[4] && data_in[5])
                     ca2_out_value <= data_in[3];
                end
              
              2'b10:
		begin
                   if (output_b_access)
		     output_b <= data_in;
                   else
                     ddr_b <= data_in;
                end
              
              2'b11:
		begin
                   cb2_is_output <= data_in[5];
                   cr_b_4 <= data_in[4];
                   cr_b_3 <= data_in[3];
                   output_b_access <= data_in[2];
                   cb1_edge <= data_in[1];
                   cb1_int_en <= data_in[0];
                   
                   if (data_in[4] && data_in[5])
                     cb2_out_value <= data_in[3];
		end // case: 2'b11

	      default:
		;  // Do nothing!
            endcase
       end // else: !if(reset)
   
   //-------------------------------------------------------------------
   // Sampling of interrupt inputs.
   
   assign ca2_in_gated = ca2_in & ~ca2_is_output;
   assign cb2_in_gated = cb2_in & ~cb2_is_output;

   always @(posedge clock or posedge reset)
     if (reset)
       begin
	  ca1_q <= 1'b0;
	  ca2_q <= 1'b0;
	  cb1_q <= 1'b0;
	  cb2_q <= 1'b0;
       end
     else
       if (e_sync)
	 begin
            ca1_q <= ca1;
            ca2_q <= ca2_in_gated;
            cb1_q <= cb1;
            cb2_q <= cb2_in_gated;
	 end
   
   //-------------------------------------------------------------------
   // Interrupt edge detection.

   always @(posedge clock or posedge reset)
     if (reset)
       irqa_1_intf <= 0;
     else
       begin
	  if (((ca1_edge == 1'b0 && ca1_q && ca1 == 1'b0) ||
               (ca1_edge == 1'b1 && ca1_q && ca1 == 1'b1)) &&
              e_sync)
            irqa_1_intf <= 1'b1;
	  else
	    if (cs && read && rs == 2'b00 && output_a_access)
              irqa_1_intf <= 1'b0;
       end

   always @(posedge clock or posedge reset)
     if (reset)
       irqa_2_intf <= 0;
     else
       begin
	  if (((ca2_edge == 1'b0 && ca2_q && ca2_in_gated == 1'b0) ||
               (ca2_edge == 1'b1 && ca2_q && ca2_in_gated == 1'b1)) &&
              e_sync)
            irqa_2_intf <= 1'b1;
	  else
	    if (cs && read && rs == 2'b00 && output_a_access)
              irqa_2_intf <= 1'b0;
       end

   always @(posedge clock or posedge reset)
     if (reset)
       irqb_1_intf <= 0;
     else
       begin
	  if (((cb1_edge == 1'b0 && cb1_q && cb1 == 1'b0) ||
               (cb1_edge == 1'b1 && cb1_q && cb1 == 1'b1)) &&
              e_sync)
            irqb_1_intf <= 1'b1;
	  else
	    if (cs && read && rs == 2'b10 && output_b_access)
              irqb_1_intf <= 1'b0;
       end

   always @(posedge clock or posedge reset)
     if (reset)
       irqb_2_intf <= 0;
     else
       begin
          if (((cb2_edge == 1'b0 && cb2_q && cb2_in_gated == 1'b0) ||
               (cb2_edge == 1'b1 && cb2_q && cb2_in_gated == 1'b1)) &&
              e_sync)
            irqb_2_intf <= 1'b1;
          else
    	    if (cs && read && rs == 2'b10 && output_b_access)
              irqb_2_intf <= 1'b0;
       end
   
endmodule
