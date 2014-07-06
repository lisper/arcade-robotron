//
//
//

module logic7442(
		 input [3:0] in,
		 output reg [9:0] out
		 );

   always @(in)
     begin
	case (in)
	  4'b0000: out = 10'b1111111110;
	  4'b0001: out = 10'b1111111101;
	  4'b0010: out = 10'b1111111011;
	  4'b0011: out = 10'b1111110111;
	  4'b0100: out = 10'b1111101111;
	  4'b0101: out = 10'b1111011111;
	  4'b0110: out = 10'b1110111111;
	  4'b0111: out = 10'b1101111111;
	  4'b1000: out = 10'b1011111111;
	  4'b1001: out = 10'b0111111111;
	  default: out = 10'b1111111111;
      endcase;
     end
   
endmodule // logic7442


