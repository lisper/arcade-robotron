#!/usr/bin/env python

#
# Copyright 2009-2011 ShareBrained Technology, Inc.
#
# This file is part of robotron-fpga.
#
# robotron-fpga is free software: you can redistribute
# it and/or modify it under the terms of the GNU General
# Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your
# option) any later version.
#
# robotron-fpga is distributed in the hope that it will
# be useful, but WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General
# Public License along with robotron-fpga. If not, see
# <http://www.gnu.org/licenses/>.

def write_module(name, data, f):
    f.write("""module %(name)s
	(input clk,
	 input rst,
	 input cs,
	 input [10:0] addr,
	output reg [7:0] data);
""" % {'name': name})
    f.write("""

	always @(posedge clk)
	  case (addr)
""")
    init_lines = []
    for n in range(0, len(data)):
        start = n;
        end = (n + 1);
        init_data = reversed(data[start:end])
        init_data = ''.join([hex(ord(c))[2:].zfill(2) for c in init_data])
        init_line = '            11\'h%02x: data = 8\'h%s' % (n, init_data)
        init_lines.append(init_line)
    f.write(';\n'.join(init_lines))
    f.write(""";
	endcase
endmodule
""")


data = open('mame/robotron/robotron.snd', 'rb').read()
#data = open('mame/defender/defend.snd', 'rb').read()
file_out = open('output/rom_snd_blocks.v', 'w')

write_module('ROM_SND_F000', data[0:2048], file_out)
write_module('ROM_SND_F800', data[2048:4096], file_out)

file_out.close()
