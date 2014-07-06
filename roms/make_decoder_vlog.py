#!/usr/bin/env python

import os
import sys
import numpy
from math import log
from os.path import splitext

filename = sys.argv[1]
entity_name = os.path.basename( filename.replace(".", "_") )
data = numpy.fromfile(filename, dtype=numpy.uint8)
bit_high = int(log(len(data), 2) - 1)
bit_low = 0

cases = []
for index in range(len(data)):
    value = data[index]
    index_bit_pattern = bin(index)[2:].zfill(bit_high+1)
    value_bit_pattern = bin(value)[2:].zfill(8)
    d = {
        "index": index,
        "index_bin": index_bit_pattern,
        "value": value,
        "value_bin": value_bit_pattern,
    }
    case = """        9'b%(index_bin)s: // %(index)x
            data = 8'b%(value_bin)s; // %(value)x
""" % d
    cases.append(case)
cases = ''.join(cases)

print("""// From %(filename)s
 
module %(entity_name)s (
        input [%(bit_high)d:%(bit_low)d] address,
        output reg [7:0] data);

  always @(*)
    case (address)
%(cases)s
        default:
            data = 8'b0;
        endcase
endmodule
""" % locals())

