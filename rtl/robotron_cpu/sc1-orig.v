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

//-- This entity models a pair of Williams SC1 pixel BLTter ICs.
//-- The interface is modified to be more conducive to synchronous
//-- FPGA implementation.

module sc1(
           input 	 clk,
           input 	 reset,
           input 	 e_sync,

           input 	 reg_cs,
           input [7:0] 	 reg_data_in,
           input [2:0] 	 rs,

           output 	 halt,
           input 	 halt_ack,

           input 	 blt_ack,

           output 	 read,
           output 	 write,

           output [15:0] blt_address_out,
           input [7:0] 	 blt_data_in,
           output [7:0]  blt_data_out,

           output 	 en_upper,
           output 	 en_lower
	   );

   parameter [1:0]
     state_idle          = 2'd0,
     state_wait_for_halt = 2'd1,
     state_src           = 2'd2,
     state_dst           = 2'd3;
   
   // 0: Run register
   reg 			 span_src;
   reg 			 span_dst;
   reg 			 synchronize_e;
   reg 			 zero_write_suppress;
   reg 			 constant_substitution;
   reg 			 shift_right;
   reg 			 suppress_lower;
   reg 			 suppress_upper;
   
   // 1: constant substitution value
   reg [7:0] 		 constant_value;
   
   // 2, 3: source address
   reg [15:0] 		 src_base;
   
   //-- 4, 5: destination address
   reg [15:0] 		 dst_base;
   
   // 6: width
   reg [8:0] 		 width;
   
   // 7: height
   reg [8:0] 		 height;
   
   // Internal
   reg [1:0] 		 state;
   
   reg [7:0] 		 blt_src_data;

   reg [15:0] 		 src_address;
   reg [15:0] 		 dst_address;
   
   reg [8:0] 		 x_count;
   wire [8:0] 		 x_count_next;
   reg [8:0] 		 y_count;
   wire [8:0] 		 y_count_next;
   
   //
   assign halt = ~(state == state_idle);
   
   assign blt_address_out = state == state_dst ? dst_address : src_address;
   assign read = state == state_src ? 1'b1 : 1'b0;
   assign write = state == state_dst ? 1'b1 : 1'b0;
   
   assign en_upper = (state == state_src) ||
                     (~(suppress_upper ||
			(zero_write_suppress && blt_src_data[7:4] == 4'b0000)
			));

   assign en_lower = (state == state_src) ||
                     (~(suppress_lower ||
			(zero_write_suppress && blt_src_data[3:0] == 4'b0000)
			));
   
   assign blt_data_out = constant_substitution ? constant_value : blt_src_data;
   
   assign x_count_next = x_count + 1;
   assign y_count_next = y_count + 1;

   always @(posedge clk or posedge reset)
     if (reset)
       begin
          state <= state_idle;

	  span_src <= 1'b0;
	  span_dst <= 1'b0;
	  synchronize_e <= 1'b0;
	  zero_write_suppress <= 1'b0;
	  constant_substitution <= 1'b0;
	  shift_right <= 1'b0;
	  suppress_lower <= 1'b0;
	  suppress_upper <= 1'b0;

	  constant_value <= 8'hff;
	  src_base <= 0;
	  dst_base <= 0;
	  width <= 0;
	  height <= 0;
       end
     else
       begin
          case (state)

            state_idle:
	      begin
                 if (reg_cs)
		   begin
                      case (rs)
			3'b000:   // 0: Start BLT with attributes
			  begin
                             suppress_upper <= reg_data_in[7];
                             suppress_lower <= reg_data_in[6];
                             shift_right <= reg_data_in[5];
                             constant_substitution <= reg_data_in[4];
                             zero_write_suppress <= reg_data_in[3];
                             synchronize_e <= reg_data_in[2];
                             span_dst <= reg_data_in[1];
                             span_src <= reg_data_in[0];
			     
                             state <= state_wait_for_halt;
			  end
			
			3'b001:  // 1: mask
                          constant_value <= reg_data_in;
			
			3'b010:  // 2: source address (high)
                          src_base[15:8] <= reg_data_in;
			
			3'b011:  // 3: source address (low)
                          src_base[7:0] <= reg_data_in;
			
			3'b100:  // 4: destination address (high)
                          dst_base[15:8] <= reg_data_in;
			
			3'b101:  // 5: destination address (low)
                          dst_base[7:0] <= reg_data_in;
			
			3'b110:  // 6: width
                          width <= { 1'b0, reg_data_in ^ 8'b00000100 };
			
			3'b111: // 7: height
                          height <= { 1'b0, reg_data_in ^ 8'b00000100 };

			default:
			  ;    // Do nothing.
		      endcase // case (rs)
		   end // if (reg_cs)
              end // case: state_idle
	    
	    state_wait_for_halt:
	      begin
                 if (halt_ack)
		   begin
                      src_address <= src_base;
                      dst_address <= dst_base;
                      
                      // TODO: Handle width or height = 0?
                      x_count <= 0;
                      y_count <= 0;

                      state <= state_src;
		   end
              end // case: state_wait_for_halt
	    
            state_src:
	      begin
                 if (blt_ack)
		   begin
                      blt_src_data <= blt_data_in;
                      state <= state_dst;
		   end
              end
            
            state_dst:
	      begin
                 if (blt_ack)
		   begin
                      state <= state_src;

                      if (x_count_next == width)
			begin
                           x_count <= 0;
                           y_count <= y_count_next;

                           if (y_count_next == height)
                             state <= state_idle;
			   
                           if (span_src)
                             src_address <= src_base + { 7'b0, y_count_next };
                           else
                             src_address <= src_address + 16'd1;
			   
                           if (span_dst)
                             dst_address <= dst_base + { 7'b0, y_count_next };
                           else
                             dst_address <= dst_address + 16'd1;
			end
                      else
			begin
                           x_count <= x_count_next;

                           if (span_src)
                             src_address <= src_address + 16'd256;
                           else
                             src_address <= src_address + 16'd1;
			   
                           if (span_dst)
                             dst_address <= dst_address + 16'd256;
                           else
                             dst_address <= dst_address + 16'd1;
			end
		   end // if (blt_ack)
	      end // case: state_dst

	    default:
	      ;                // Do nothing.
            
          endcase
       end // else: !if(reset)

endmodule // sc1
