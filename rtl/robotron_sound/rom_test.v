//
// rom_test.v
//

`timescale 1ns/1ns

module rom_test;

   // Inputs
   reg clk;
   reg rst;
   reg cs;
   reg [11:0] rom_addr;

   // Outputs
   wire [7:0] data;

   // Clock period definitions
   parameter clk_period = 280/* ns*/;
 
   // Instantiate the Unit Under Test (UUT)
   rom_snd uut (
		.clk(clk),
		.rst(rst),
		.cs(cs),
		.addr(rom_addr),
		.data(data)
		);

   // Clock process definitions
   always
     begin
	clk = 1'b0;
	#(clk_period/2);
	clk = 1'b1;
	#(clk_period/2);
     end

   integer errors;
   
   task check_data;
      input [7:0] what;
      input [11:0] addr;
      begin
	 if (data != what)
	   begin
	      $display("addr %x data %x read incorrect, wanted %x", addr, data, what);
	      errors = errors + 1;
	   end
	 else
	      $display("addr %x data %b read correct", addr, data);
      end
   endtask
   
   task read_rom;
      input [11:0] addr;
      begin
	 rom_addr = addr;
	 @(posedge clk);
	 @(negedge clk);
      end
   endtask
      
   // Stimulus process
   initial
     begin
	errors = 0;
	cs = 1'b1;
		
	rst = 1'b1;
	#(clk_period * 2);
	rst = 1'b0;
	#(clk_period * 2);

	@(negedge clk);

	// insert stimulus here
	read_rom(12'b000000000000);
	check_data(8'b01110110, 0);
		
	read_rom(12'b000000000001);
	check_data(8'b00101000, 1);

	read_rom(12'b000000000010);
	check_data(8'b01000011, 2);
		
	read_rom(12'b000000000011);
	check_data(8'b00101001, 3);
		
	read_rom(12'b011111111111);
	check_data(8'b10010001, 12'h7ff);
	
	read_rom(12'b100000000000);
	check_data(8'b00000110, 12'h800);
	
	read_rom(12'b100000000001);
	check_data(8'b00100010, 12'h801);
	
	read_rom(12'b100000000010);
	check_data(8'b11110000, 12'h802);
	
	read_rom(12'b100000000011);
	check_data(8'b10010110, 12'h803);
	
	read_rom(12'b111111111111);
	check_data(8'b00011101, 12'hfff);

	if (errors != 0)
	  begin
	     $display("**FAILED**");
	     $finish;
	  end

	#50000;
	$finish;
     end
endmodule

