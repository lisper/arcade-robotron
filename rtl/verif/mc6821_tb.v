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

module mc6821_tb;

    reg reset;
    reg clock;
    reg e_sync;
    reg e_set;
    reg e_clear;
    reg [1:0] rs;
    reg cs;
    reg write;
    reg [7:0] data_in;
   wire [7:0]  data_out;
    reg ca1;
    reg ca2_in;
   wire ca2_out;
   wire ca2_dir;
   wire irq_a;
    reg [7:0] pa_in;
    wire [7:0] pa_out;
    wire [7:0] pa_dir;
    reg cb1;
    reg cb2_in;
   wire cb2_out;
   wire cb2_dir;
   wire irq_b;
    reg [7:0] pb_in;
   wire [7:0]  pb_out;
   wire [7:0]   pb_dir;

   parameter clock_period = 83.333/* ns*/;

   mc6821 uut(
              .reset(reset),
              .clock(clock),
	      .e_sync(e_sync),
//              .e_set(e_set),
//              .e_clear(e_clear),
              .rs(rs),
              .cs(cs),
              .write(write),
              .data_in(data_in),
              .data_out(data_out),
              .ca1(ca1),
              .ca2_in(ca2_in),
              .ca2_out(ca2_out),
              .ca2_dir(ca2_dir),
              .irq_a(irq_a),
              .pa_in(pa_in),
              .pa_out(pa_out),
              .pa_dir(pa_dir),
              .cb1(cb1),
              .cb2_in(cb2_in),
              .cb2_out(cb2_out),
              .cb2_dir(cb2_dir),
              .irq_b(irq_b),
              .pb_in(pb_in),
              .pb_out(pb_out),
              .pb_dir(pb_dir)
              );

   //
   always
     begin
	clock = 1'b0;
	#(clock_period/2);
	clock = 1'b1;
	#(clock_period/2);
     end

   always
    begin
        @(posedge clock);
        @(posedge clock);
        e_set = 1'b1;
        @(posedge clock);
        e_set = 1'b0;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
        e_clear = 1'b1;
        @(posedge clock);
        e_clear = 1'b0;
        @(posedge clock);
        @(posedge clock);
        @(posedge clock);
    end

   always @(posedge clock)
     if (e_set)
       e_sync = 1;
     else
       if (e_clear)
	 e_sync = 0;

   initial
    begin		
        pb_in = 8'b01010101;

       // Configure CRA, with DDR register selected
       @(posedge e_set);
        rs = 2'b01;
        cs = 1'b1;
        data_in = 8'b00011011;
        write = 1'b1;

        // Configure DDR as all outputs
        @(posedge e_set);
        rs = 2'b00;
        cs = 1'b1;
        data_in = 8'b11111111;
        write = 1'b1;

        // Configure CRA, with output register selected
        @(posedge e_set);
        rs = 2'b01;
        cs = 1'b1;
        data_in = 8'b00011111;
        write = 1'b1;

        // Configure output register value
        @(posedge e_set);
        rs = 2'b00;
        cs = 1'b1;
        data_in = 8'b10101010;
        write = 1'b1;

        // Configure CRB, with output register selected
        @(posedge e_set);
        rs = 2'b11;
        cs = 1'b1;
        data_in = 8'b00011111;
        write = 1'b1;

        @(posedge e_set);
        cs = 1'b0;
        write = 1'b0;
        ca1 = 1'b1;
        ca2_in = 1'b1;

        @(posedge e_set);
        @(posedge e_set);
        rs = 2'b00;
        cs = 1'b1;
        write = 1'b0;

        @(posedge e_set);
        cs = 1'b0;

        @(posedge e_set);
        rs = 2'b00;
        cs = 1'b1;
        write = 1'b0;

        @(posedge e_set);
        rs = 2'b10;
        cs = 1'b1;
        write = 1'b0;

        @(posedge e_set);

       #50000;
       $finish;
    end

endmodule
