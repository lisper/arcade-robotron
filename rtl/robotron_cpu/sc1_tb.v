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

`timescale 1ns / 1ns

module sc1_tb;
   
    reg clk;
    reg reset;
    reg e_sync;
    reg reg_cs;
    reg [7:0] reg_data_in;
    reg [2:0] rs;
   wire halt;
    reg halt_ack;
    reg blt_ack;
   wire [15:0] blt_address_out;
   wire read;
   wire write;
    reg [7:0] blt_data_in;
    wire [7:0] blt_data_out;
   wire en_upper;
   wire en_lower;

   parameter clk_period = 83.333333/* ns*/;
 
   sc1 uut(
           .clk(clk),
           .reset(reset),
           .e_sync(e_sync),
           .reg_cs(reg_cs),
           .reg_data_in(reg_data_in),
           .rs(rs),
           .halt(halt),
           .halt_ack(halt_ack),
           .blt_ack(blt_ack),
           .blt_address_out(blt_address_out),
           .read(read),
           .write(write),
           .blt_data_in(blt_data_in),
           .blt_data_out(blt_data_out),
           .en_upper(en_upper),
           .en_lower(en_lower)
        );

   //
   initial
     begin
	$timeformat(-9, 0, "ns", 7);
	$dumpfile("sc1_test.vcd");
	$dumpvars(0, sc1_tb);
     end

   always
     begin
        clk = 1'b0;
        #(clk_period/2);
        
        clk = 1'b1;
        #(clk_period/2);
     end

   initial
     begin
	//halt = 1'b0;
	halt_ack = 1'b0;
        e_sync = 1'b1;
        
        @(posedge clk);
        rs = 3'b010;
        reg_data_in = 8'h11;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b011;
        reg_data_in = 8'h22;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b100;
        reg_data_in = 8'h33;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b101;
        reg_data_in = 8'h44;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b110;
        reg_data_in = 8'h00;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b111;
        reg_data_in = 8'h00;
        reg_cs = 1'b1;
        
        @(posedge clk);
        rs = 3'b000;
        reg_data_in = 8'b00000001;
        reg_cs = 1'b1;
        
        @(posedge clk);
        reg_cs = 1'b0;

        while (~halt)
	  @(posedge clk);
	
        halt_ack = 1'b1;
        
        @(posedge clk);
        blt_ack = 1'b1;
        blt_data_in = 8'h69;
        
        while (halt)
	  @(posedge clk);

        blt_ack = 1'b0;
        halt_ack = 1'b0;

	#50000;
	$finish;
	
    end

endmodule // sc1_tb

