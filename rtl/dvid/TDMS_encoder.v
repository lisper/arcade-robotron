// original vhdl from Mike Field <hamster@snap.net.nz>
// TDMS Encoder 
//     8 bits colour, 2 control bits and one blanking bits in
//     10 bits of TDMS encoded data out
//     Clocked at the pixel clock

module TDMS_encoder(input clk,
		    input [7:0]  data,
		    input [1:0]  c,
		    input 	 blank,
		    output reg [9:0] encoded);

   //
   wire [8:0] xored;
   wire [8:0] xnored;

   wire [3:0] ones;
   reg [8:0]  data_word;
   reg [8:0]  data_word_inv;
   wire [3:0] data_word_disparity;

   reg [3:0]  dc_bias;

   // Work our the two different encodings for the byte
   assign xored[0] = data[0];
   assign xored[1] = data[1] ^ xored[0];
   assign xored[2] = data[2] ^ xored[1];
   assign xored[3] = data[3] ^ xored[2];
   assign xored[4] = data[4] ^ xored[3];
   assign xored[5] = data[5] ^ xored[4];
   assign xored[6] = data[6] ^ xored[5];
   assign xored[7] = data[7] ^ xored[6];
   assign xored[8] = 1'b1;

   assign xnored[0] = data[0];
   assign xnored[1] = data[1] ~^ xnored[0];
   assign xnored[2] = data[2] ~^ xnored[1];
   assign xnored[3] = data[3] ~^ xnored[2];
   assign xnored[4] = data[4] ~^ xnored[3];
   assign xnored[5] = data[5] ~^ xnored[4];
   assign xnored[6] = data[6] ~^ xnored[5];
   assign xnored[7] = data[7] ~^ xnored[6];
   assign xnored[8] = 1'b0;
   
   // Count how many ones are set in data
   assign ones = 4'b0000 + data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7];
 
   // Decide which encoding to use
   always @(ones, data[0], xnored, xored)
     begin
	if (ones > 4 || (ones == 4 && data[0] == 1'b0))
	  begin
             data_word     = xnored;
             data_word_inv = ~xnored;
	  end
	else
	  begin
             data_word     = xored;
             data_word_inv = ~xored;
	  end
     end

   // Work out the DC bias of the dataword;
   assign data_word_disparity = 4'b1100 + data_word[0] + data_word[1] + data_word[2] + data_word[3] 
                                    + data_word[4] + data_word[5] + data_word[6] + data_word[7];
   
   // Now work out what the output should be
   always @(posedge clk)
     begin
        if (blank)
	  begin
             // In the control periods, all values have and have balanced bit count
             case (c)
               2'b00:   encoded <= 10'b1101010100;
               2'b01:   encoded <= 10'b0010101011;
               2'b10:   encoded <= 10'b0101010100;
               default: encoded <= 10'b1010101011;
             endcase;
             dc_bias <= 0;
	  end
	else
	  begin
             if (dc_bias == 5'b00000 || data_word_disparity == 0)
	       begin
		  // dataword has no disparity
		  if (data_word[8] == 1'b1)
		    begin
                       encoded <= { 2'b01, data_word[7:0] };
                       dc_bias <= dc_bias + data_word_disparity;
		    end
		  else
		    begin
                       encoded <= { 2'b10, data_word_inv[7:0] };
                       dc_bias <= dc_bias - data_word_disparity;
		    end
               end
             else
	       if ((dc_bias[3] == 1'b0 && data_word_disparity[3] == 1'b0) ||
                   (dc_bias[3] == 1'b1 && data_word_disparity[3] == 1'b1))
		 begin
		    encoded <= { 1'b1, data_word[8], data_word_inv[7:0] };
		    dc_bias <= dc_bias + data_word[8] - data_word_disparity;
		 end
	       else
		 begin
		    encoded <= { 1'b0, data_word };
		    dc_bias <= dc_bias - data_word_inv[8] + data_word_disparity;
		 end
	  end // else: !if(blank == 1'b1)
     end // always @ (posedge clk)

endmodule // TDMS_encoder
