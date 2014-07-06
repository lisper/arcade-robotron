//-----------------------------------------------------------------------
//--
//-- Copyright 2009-2012 ShareBrained Technology, Inc.
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

module led_decoder(input [3:0] in,
		   output [6:0] out);

   assign out =
	       (in == 4'b0001) ? 7'b1111001 : //1
	       (in == 4'b0010) ? 7'b0100100 : //2
	       (in == 4'b0011) ? 7'b0110000 : //3
	       (in == 4'b0100) ? 7'b0011001 : //4
	       (in == 4'b0101) ? 7'b0010010 : //5
	       (in == 4'b0110) ? 7'b0000010 : //6
	       (in == 4'b0111) ? 7'b1111000 : //7
	       (in == 4'b1000) ? 7'b0000000 : //8
	       (in == 4'b1001) ? 7'b0010000 : //9
	       (in == 4'b1010) ? 7'b0001000 : //A
	       (in == 4'b1011) ? 7'b0000011 : //b
	       (in == 4'b1100) ? 7'b1000110 : //C
	       (in == 4'b1101) ? 7'b0100001 : //d
	       (in == 4'b1110) ? 7'b0000110 : //E
	       (in == 4'b1111) ? 7'b0001110 : //F
		7'b1000000; //0

endmodule
