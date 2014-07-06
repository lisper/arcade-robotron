//
//
//
module  cpu09 ( clk, rst, vma, addr, rw, data_out, data_in, irq, firq, nmi, halt, hold );
   
   input clk;
   input rst;
   output vma;
   output [15:0] addr;
   output 	 rw;
   output [7:0]  data_out;
   input [7:0] 	 data_in;
   input 	 irq;
   input 	 firq;
   input 	 nmi;
   input 	 halt;
   input 	 hold;

   wire [5:0] 	 cpu_state;
   wire 	 cpu_we;
   wire 	 cpu_oe;
   wire [15:0] 	 cpu_addr;
   wire [7:0] 	 cpu_data_in;
   wire [7:0] 	 cpu_data_out;
   wire 	 cpu_nmi;
   wire 	 cpu_irq;
   wire 	 cpu_firq;
   
   assign vma = cpu_oe;
   assign rw = cpu_we;
   assign addr = cpu_addr;
   assign data_out = cpu_data_out;
   assign cpu_data_in = data_in;
   assign cpu_nmi= nmi;
   assign cpu_irq = irq;
   assign cpu_firq = firq;
   
   MC6809_cpu cpu(
		  .cpu_clk(clk),
		  .cpu_reset(rst),
		  .cpu_nmi_n(cpu_nmi),
		  .cpu_irq_n(cpu_irq),
		  .cpu_firq_n(cpu_firq),
		  .cpu_state_o(cpu_state),
		  .cpu_we_o(cpu_we),
		  .cpu_oe_o(cpu_oe),
		  .cpu_addr_o(cpu_addr),
		  .cpu_data_i(cpu_data_in),
		  .cpu_data_o(cpu_data_out)
		  );

endmodule // cpu09
