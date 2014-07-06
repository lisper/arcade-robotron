//===========================================================================//
//
// Synthesizble cpu68 core; ported to verilog 01/2013
// Brad Parker <brad@heeltoe.com>
//
//===========================================================================//
//
// S Y N T H E Z I A B L E    CPU68   C O R E
//
// www.OpenCores.Org - December 2002
// This core adheres to the GNU public license  
//
// File name      : cpu68.v
//
// Purpose        : Implements a 6800 compatible CPU core with some
//                  additional instructions found in the 6801
//                  
// Original Author : John E. Kent      
//
//===========================================================================//
//
// Revision History:
//
// Date:          Revision         Author
// 22 Sep 2002    0.1              John Kent
//
// 30 Oct 2002    0.2              John Kent
// made NMI edge triggered
//
// 30 Oct 2002    0.3              John Kent
// more corrections to NMI
// added wai_wait_state to prevent stack overflow on wai.
//
//  1 Nov 2002    0.4              John Kent
// removed WAI states and integrated WAI with the interrupt service routine
// replace Data out (do) and Data in (di) register with a single Memory Data (md) reg.
// Added Multiply instruction states.
// run ALU and CC out of CPU module for timing measurements.
// 
//  3 Nov 2002    0.5              John Kent
// Memory Data Register was not loaded on Store instructions
// SEV and CLV were not defined in the ALU
// Overflow Flag on NEG was incorrect
//
// 16th Feb 2003  0.6              John Kent
// Rearranged the execution cycle for dual operand instructions
// so that occurs during the following fetch cycle.
// This allows the reduction of one clock cycle from dual operand
// instruction. Note that this also necessitated re-arranging the
// program counter so that it is no longer incremented in the ALU.
// The effective address has also been re-arranged to include a 
// separate added. The STD (store accd) now sets the condition codes.
//
// 28th Jun 2003 0.7               John Kent
// Added Hold and Halt signals. Hold is used to steal cycles from the
// CPU or add wait states. Halt puts the CPU in the inactive state
// and is only honoured in the fetch cycle. Both signals are active high.
//
// 9th Jan 2004 0.8						John Kent
// Clear instruction did an alu_ld8 rather than an alu_clr, so
// the carry bit was not cleared correctly.
// This error was picked up by Michael Hassenfratz.
//

module cpu68(
	     input 	       clk,
	     input 	       rst,
	     output reg        rw,
	     output reg        vma,
	     output reg [15:0] address,
	     input [7:0]       data_in,
	     output reg [7:0]  data_out,
	     input 	       hold,
	     input 	       halt,
	     input 	       irq,
	     input 	       nmi,
	     output reg [15:0] test_alu,
	     output reg [7:0]  test_cc
	     );

  parameter SBIT = 7;
  parameter XBIT = 6;
  parameter HBIT = 5;
  parameter IBIT = 4;
  parameter NBIT = 3;
  parameter ZBIT = 2;
  parameter VBIT = 1;
  parameter CBIT = 0;

   parameter [6:0]
     reset_state = 1,
     fetch_state = 2,
     decode_state = 3,
     extended_state = 4,
     indexed_state = 5,
     read8_state = 6,
     read16_state = 7,
     immediate16_state = 8,
     write8_state = 9,
     write16_state = 10,
     execute_state = 11,
     halt_state = 12,
     error_state = 13,
     mul_state = 20,
     mulea_state = 21,
     muld_state= 22,
     mul0_state = 23,
     mul1_state = 24,
     mul2_state = 25,
     mul3_state = 26,
     mul4_state = 27,
     mul5_state = 28,
     mul6_state = 29,
     mul7_state= 30,
     jmp_state = 40,
     jsr_state = 41,
     jsr1_state= 42,
     branch_state = 43,
     bsr_state = 44,
     bsr1_state = 45,
     rts_hi_state = 46,
     rts_lo_state = 47,
     int_pcl_state = 50,
     int_pch_state = 51,
     int_ixl_state = 52,
     int_ixh_state = 53,
     int_cc_state = 54,
     int_acca_state = 55,
     int_accb_state = 56,
     int_wai_state = 57,
     int_mask_state = 58,
     rti_state = 60,
     rti_cc_state = 61,
     rti_acca_state = 62,
     rti_accb_state = 63,
     rti_ixl_state = 64,
     rti_ixh_state = 65,
     rti_pcl_state = 66,
     rti_pch_state = 67,
     pula_state = 70,
     psha_state = 71,
     pulb_state = 72,
     pshb_state = 73,
     pulx_lo_state = 74,
     pulx_hi_state = 75,
     pshx_lo_state = 76,
     pshx_hi_state = 77,
     vect_lo_state = 80,
     vect_hi_state = 81;

   parameter [3:0]
     idle_ad = 1,
     fetch_ad = 2,
     read_ad = 3,
     write_ad = 4,
     push_ad = 5,
     pull_ad = 6,
     int_hi_ad = 7,
     int_lo_ad = 8;

   parameter [3:0]
     md_lo_dout = 1,
     md_hi_dout = 2,
     acca_dout = 3,
     accb_dout = 4,
     ix_lo_dout = 5,
     ix_hi_dout = 6,
     cc_dout = 7,
     pc_lo_dout = 8,
     pc_hi_dout = 9;
   
   parameter [1:0]
     reset_op = 1,
     fetch_op = 2,
     latch_op = 3;

   parameter [2:0]
     reset_acca = 1,
     load_acca = 2,
     load_hi_acca = 3,
     pull_acca = 4,
     latch_acca = 5;

   parameter [2:0]
     reset_accb = 1,
     load_accb = 2,
     pull_accb = 3,
     latch_accb = 4;

   parameter [2:0]
     reset_cc = 1,
     load_cc = 2,
     pull_cc = 3,
     latch_cc = 4;

   parameter [2:0]
     reset_ix = 1,
     load_ix = 2,
     pull_lo_ix = 3,
     pull_hi_ix = 4,
     latch_ix = 5;

   parameter [1:0]
     reset_sp = 1,
     latch_sp = 2,
     load_sp = 3;

   parameter [2:0]	// pc_ctrl
     reset_pc = 1,
     latch_pc = 2,
     load_ea_pc = 3,
     add_ea_pc = 4,
     pull_lo_pc = 5,
     pull_hi_pc = 6,
     inc_pc = 7;

   parameter [2:0]
     reset_md = 1,
     latch_md = 2,
     load_md = 3,
     fetch_first_md = 4,
     fetch_next_md = 5,
     shiftl_md = 6;

   parameter [2:0]
     reset_ea = 1,
     latch_ea = 2,
     add_ix_ea = 3,
     load_accb_ea = 4,
     inc_ea = 5,
     fetch_first_ea = 6,
     fetch_next_ea = 7;

   parameter [2:0]
     reset_iv = 1,
     latch_iv = 2,
     swi_iv = 3,
     nmi_iv = 4,
     irq_iv = 5;

   parameter [1:0]
     reset_nmi = 1,
     set_nmi = 2,
     latch_nmi = 3;

   parameter[2:0]
     acca_left = 1,
     accb_left = 2,
     accd_left = 3,
     md_left = 4,
     ix_left = 5,
     sp_left = 6;

   parameter [2:0]
     md_right = 1,
     zero_right = 2,
     plus_one_right = 3,
     accb_right = 4;

   parameter [5:0]
     alu_add8 = 1,
     alu_sub8 = 2,
     alu_add16 = 3,
     alu_sub16 = 4,
     alu_adc = 5,
     alu_sbc = 6,
     alu_and = 7,
     alu_ora = 8,
     alu_eor = 9,
     alu_tst = 10,
     alu_inc = 11,
     alu_dec = 12,
     alu_clr = 13,
     alu_neg = 14,
     alu_com = 15,
     alu_inx = 16,
     alu_dex = 17,
     alu_cpx = 18,
     alu_lsr16 = 20,
     alu_lsl16 = 21,
     alu_ror8 = 22,
     alu_rol8 = 23,
     alu_asr8 = 24,
     alu_asl8 = 25,
     alu_lsr8 = 26,
     alu_sei = 30,
     alu_cli = 31,
     alu_sec = 32,
     alu_clc = 33,
     alu_sev = 34,
     alu_clv = 35,
     alu_tpa = 36,
     alu_tap = 37,
     alu_ld8 = 38,
     alu_st8 = 39,
     alu_ld16 = 40,
     alu_st16 = 41,
     alu_nop = 42,
     alu_daa = 43;

   reg [7:0] op_code;
   reg [7:0] acca;
   reg [7:0] accb;
   reg [7:0] cc;
   reg [7:0] cc_out;
   reg [15:0] xreg;
   reg [15:0] sp;
   reg [15:0] ea;
   reg [15:0] pc;
   reg [15:0] md;
   reg [15:0] left;
   reg [15:0] right;
   reg [15:0] out_alu;
   reg [1:0]  iv;
   reg nmi_req;
   reg nmi_ack;

   reg [6:0] state;
   reg [6:0] next_state;

   reg [2:0] pc_ctrl;
   reg [2:0] ea_ctrl;
   reg [1:0] op_ctrl;
   reg [2:0] md_ctrl;
   reg [2:0] acca_ctrl;
   reg [2:0] accb_ctrl;
   reg [2:0] ix_ctrl;
   reg [2:0] cc_ctrl;
   reg [1:0] sp_ctrl;
   reg [2:0] iv_ctrl;
   reg [2:0] left_ctrl;
   reg [2:0] right_ctrl;
   reg [5:0] alu_ctrl;
   reg [3:0] addr_ctrl;
   reg [3:0] dout_ctrl;
   reg [1:0] nmi_ctrl;



//----------------------------------
//-- Address bus multiplexer
//----------------------------------

always @(addr_ctrl or pc or ea or  sp or iv )
  case (addr_ctrl)
    idle_ad:
      begin
	 address = 16'hffff;
	 vma     = 1'b0;
	 rw      = 1'b1;
      end
    fetch_ad:
      begin
	 address = pc;
	 vma     = 1'b1;
	 rw      = 1'b1;
      end
    read_ad:
      begin
	 address = ea;
	 vma     = 1'b1;
	 rw      = 1'b1;
	 end
    write_ad:
      begin
	 address = ea;
	 vma     = 1'b1;
	 rw      = 1'b0;
      end
    push_ad:
      begin
	 address = sp;
	 vma     = 1'b1;
	 rw      = 1'b0;
      end
    pull_ad:
      begin
	 address = sp;
	 vma     = 1'b1;
	 rw      = 1'b1;
      end
    int_hi_ad:
      begin
	 address = { 13'b1111111111111, iv, 1'b0 };
	 vma     = 1'b1;
	 rw      = 1'b1;
      end
    int_lo_ad:
      begin
	 address = { 13'b1111111111111, iv, 1'b1 };
	 vma     = 1'b1;
	 rw      = 1'b1;
      end
    default:
      begin
	 address = 16'hffff;
	 vma     = 1'b0;
	 rw      = 1'b1;
      end
  endcase

//--------------------------------
//-- Data Bus output
//--------------------------------

always @(dout_ctrl, md, acca, accb, xreg, pc, cc )
    case (dout_ctrl)
      md_hi_dout: // alu output
	data_out = md[15:8];
      md_lo_dout:
	data_out = md[7:0];
      acca_dout: // accumulator a
	data_out = acca;
      accb_dout: // accumulator b
	data_out = accb;
      ix_lo_dout: // index reg
	data_out = xreg[7:0];
      ix_hi_dout: // index reg
	data_out = xreg[15:8];
      cc_dout: // condition codes
	data_out = cc;
      pc_lo_dout: // low order pc
	data_out = pc[7:0];
      pc_hi_dout: // high order pc
	data_out = pc[15:8];
      default:
	data_out = 8'b0;
    endcase


//----------------------------------
//-- Program Counter Control
//----------------------------------

   reg [15:0] tempof;
   reg [15:0] temppc;

   always @(pc_ctrl, pc, out_alu, data_in, ea, hold )
     case (pc_ctrl)
       add_ea_pc:
	 if (ea[7] == 1'b0)
	   tempof = { 8'b00000000, ea[7:0] };
	 else
	   tempof = { 8'b11111111, ea[7:0] };
       inc_pc:
	 tempof = 16'b0000000000000001;
       default:
	 tempof = 16'b0000000000000000;
     endcase

   always @(pc_ctrl, pc, out_alu, data_in, ea, hold )
     case (pc_ctrl)
       reset_pc:
	 temppc = 16'b1111111111111110;
       load_ea_pc:
	 temppc = ea;
       pull_lo_pc:
	 begin
	    temppc[7:0] = data_in;
	    temppc[15:8] = pc[15:8];
	 end
       pull_hi_pc:
	 begin
	    temppc[7:0] = pc[7:0];
	    temppc[15:8] = data_in;
	 end
       default:
	 temppc = pc;
     endcase

   always @(negedge clk)
     if (hold)
       pc <= pc;
     else
       pc <= temppc + tempof;


   //----------------------------------
   //-- Effective Address  Control
   //----------------------------------

   reg [15:0] tempind;
   reg [15:0] tempea;

   always @(ea_ctrl, ea, out_alu, data_in, accb, xreg, hold )
     case (ea_ctrl)
       add_ix_ea:
	 tempind = { 8'b00000000, ea[7:0] };
       inc_ea:
	 tempind = 16'b0000000000000001;
       default:
	 tempind = 16'b0000000000000000;
     endcase

   always @(ea_ctrl, ea, out_alu, data_in, accb, xreg, hold )
     case (ea_ctrl)
       reset_ea:
	 tempea = 16'b0000000000000000;
       load_accb_ea:
	 tempea = { 8'b00000000, accb[7:0] };
       add_ix_ea:
	 tempea = xreg;
       fetch_first_ea:
	 begin
	    tempea[7:0] = data_in;
	    tempea[15:8] = 8'b0;
	 end
       fetch_next_ea:
	 begin
	    tempea[7:0] = data_in;
	    tempea[15:8] = ea[7:0];
	 end
       default:
	 tempea = ea;
     endcase

   always @(negedge clk)
     if (hold)
       ea <= ea;
     else
       ea <= tempea + tempind;

//--------------------------------
//-- Accumulator A
//--------------------------------

   always @(negedge clk)
     if (hold)
       acca <= acca;
     else
       case (acca_ctrl)
	 reset_acca:   acca <= 8'b0;
	 load_acca:    acca <= out_alu[7:0];
	 load_hi_acca: acca <= out_alu[15:8];
	 pull_acca:    acca <= data_in;
         //latch_acca: acca <= acca;
	 default:       acca <= acca;
       endcase

//--------------------------------
//-- Accumulator B
//--------------------------------

   always @(negedge clk)
     if (hold)
       accb <= accb;
     else
       case (accb_ctrl)
	 reset_accb:   accb <= 8'b0;
	 load_accb:    accb <= out_alu[7:0];
	 pull_accb:    accb <= data_in;
         //latch_accb:   accb <= acca;
	 default:      accb <= accb;
       endcase

//--------------------------------
//-- X Index register
//--------------------------------

   always @(negedge clk)
     if (hold)
       xreg <= xreg;
     else
       case (ix_ctrl)
	 reset_ix:   xreg <= 16'b0;
	 load_ix:    xreg <= out_alu[15:0];
	 pull_hi_ix: xreg[15:8] <= data_in;
	 pull_lo_ix: xreg[ 7:0] <= data_in;
         //latch_ix,
	 default:    xreg <= xreg;
       endcase

//--------------------------------
//-- stack pointer
//--------------------------------

   always @(negedge clk)
     if (hold)
       sp <= sp;
     else
       case (sp_ctrl)
	 reset_sp:	   sp <= 16'b0000000000000000;
	 load_sp:	   sp <= out_alu[15:0];
	 //latch_sp,
	 default:	   sp <= sp;
       endcase

//--------------------------------
//-- Memory Data
//--------------------------------

   always @(negedge clk)
     if (hold)
       md <= md;
     else
       case (md_ctrl)
	 reset_md:
	   md <= 16'b0000000000000000;
	 load_md:
	   md <= out_alu[15:0];
	 fetch_first_md:
	   begin
	      md[15:8] <= 8'b0;
	      md[7:0] <= data_in;
	   end
	 fetch_next_md:
	   begin
	      md[15:8] <= md[7:0];
	      md[7:0] <= data_in;
	   end
	 shiftl_md:
	   begin
	      md[15:1] <= md[14:0];
	      md[0] <= 1'b0;
	   end
	 //latch_md,
	 default:	   md <= md;
    endcase

//----------------------------------
//-- Condition Codes
//----------------------------------

   always @(negedge clk)
     if (hold)
       cc <= cc;
     else
       case (cc_ctrl)
	 reset_cc:	   cc <= 8'b11000000;
	 load_cc:	   cc <= cc_out;
  	 pull_cc:	   cc <= data_in;
	 //latch_cc,
	 default:          cc <= cc;
    endcase

//----------------------------------
//-- interrupt vector
//----------------------------------

   always @(negedge clk)
     if (hold)
       iv <= iv;
     else
       case (iv_ctrl)
	 reset_iv:    iv <= 2'b11;
	 nmi_iv:      iv <= 2'b10;
  	 swi_iv:      iv <= 2'b01;
	 irq_iv:      iv <= 2'b00;
	 default:     iv <= iv;
       endcase

//----------------------------------
//-- op code fetch
//----------------------------------

   always @(negedge clk)
     if (hold)
       op_code <= op_code;
     else
       case (op_ctrl)
	 reset_op:	op_code <= 8'b00000001; // nop
  	 fetch_op:      op_code <= data_in;
	 //latch_op,
	 default:	op_code <= op_code;
       endcase

//----------------------------------
//-- Left Mux
//----------------------------------

   always @( left_ctrl, acca, accb, xreg, sp, pc, ea, md )
     case (left_ctrl)
       acca_left: left = { 8'b0, acca };
       accb_left: left = { 8'b0, accb };
       accd_left: left = { acca, accb };
       ix_left:   left = xreg;
       sp_left:   left = sp;
       //md_left,
       default:   left = md;
    endcase

//----------------------------------
//-- Right Mux
//----------------------------------

   always @( right_ctrl, data_in, md, accb, ea )
     case (right_ctrl)
       zero_right:	   right = 16'b0000000000000000;
       plus_one_right:	   right = 16'b0000000000000001;
       accb_right:	   right = { 8'b0, accb };
       //md_right,
       default:	           right = md;
     endcase

//----------------------------------
//-- Arithmetic Logic Unit
//----------------------------------

   wire valid_lo, valid_hi;
   reg carry_in;
   reg [7:0] daa_reg;

   assign valid_lo = left[3:0] <= 9;
   assign valid_hi = left[7:4] <= 9;

   always @( alu_ctrl, cc, left, right, out_alu, cc_out )
     begin
	case (alu_ctrl)
	  alu_adc, alu_sbc, alu_rol8, alu_ror8:
	    carry_in = cc[CBIT];
	  default:
	    carry_in = 1'b0;
	endcase

	if (cc[CBIT] == 1'b0)
	  begin
	     if (cc[HBIT] == 1'b1)
	       begin
		  if (valid_hi)
		    daa_reg = 8'b00000110;
		  else
		    daa_reg = 8'b01100110;
	       end
	     else
	       if (valid_lo)
		 begin
		    if (valid_hi)
		      daa_reg = 8'b0;
		    else
		      daa_reg = 8'b01100000;
		 end
	       else
		 begin
		    if (left[7:4] <= 8)
		      daa_reg = 8'b00000110;
		    else
		      daa_reg = 8'b01100110;
		 end
	  end // if (cc[CBIT] == 1'b0)
	else
	  begin
	     if (cc[HBIT] == 1'b1)
	       daa_reg = 8'b01100110;
 	     else
	       if (valid_lo)
		 daa_reg = 8'b01100000;
	       else
		 daa_reg = 8'b01100110;
	  end

	case (alu_ctrl)
  	  alu_add8, alu_inc, alu_add16, alu_inx, alu_adc:
	    out_alu = left + right + { 15'b0, carry_in };
  	  alu_sub8, alu_dec, alu_sub16, alu_dex, alu_sbc, alu_cpx:
	    out_alu = left - right - { 15'b0, carry_in};
  	  alu_and:
	    out_alu = left & right; 	// and/bit
  	  alu_ora:
	    out_alu = left | right; 	// or
  	  alu_eor:
	    out_alu = left ^ right; 	// eor/xor
  	  alu_lsl16, alu_asl8, alu_rol8:
	    out_alu = { left[14:0], carry_in }; 	// rol8/asl8/lsl16
  	  alu_lsr16, alu_lsr8:
	    out_alu = { carry_in, left[15:1] }; 	// lsr
  	  alu_ror8:
	    out_alu = { 8'b0, carry_in, left[7:1] }; 	// ror
  	  alu_asr8:
	    out_alu = { 8'b0, left[7], left[7:1] }; 	// asr
  	  alu_neg:
	    out_alu = right - left; 	// neg (right=0)
  	  alu_com:
	    out_alu = ~left;
  	  alu_clr, alu_ld8, alu_ld16:
	    out_alu = right; 	        // clr, ld
	  alu_st8, alu_st16:
	    out_alu = left;
	  alu_daa:
	    out_alu = left + { 8'b0, daa_reg };
	  alu_tpa:
	    out_alu = { 8'b0, cc };
  	  default:
	    out_alu = left; 		// nop
	endcase
	
	//--
	//-- carry bit
	//--
	case (alu_ctrl)
  	  alu_add8, alu_adc:
	    cc_out[CBIT] = (left[7] & right[7]) |
		            (left[7] & ~out_alu[7]) |
			    (right[7] & ~out_alu[7]);
  	 alu_sub8, alu_sbc:
	   cc_out[CBIT] = ((~left[7]) & right[7]) |
		          ((~left[7]) & out_alu[7]) |
			  (right[7] & out_alu[7]);
  	 alu_add16 :
	   cc_out[CBIT] = (left[15] & right[15]) |
		          (left[15] & ~out_alu[15]) |
			  (right[15] & ~out_alu[15]);
  	 alu_sub16:
	   cc_out[CBIT] = ((~left[15]) & right[15]) |
		          ((~left[15]) & out_alu[15]) |
			  (right[15] & out_alu[15]);
	 alu_ror8, alu_lsr16, alu_lsr8, alu_asr8:
	   cc_out[CBIT] = left[0];
	 alu_rol8, alu_asl8:
	   cc_out[CBIT] = left[7];
	 alu_lsl16:
	   cc_out[CBIT] = left[15];
	 alu_com:
	   cc_out[CBIT] = 1'b1;
	 alu_neg, alu_clr:
	   cc_out[CBIT] = out_alu[7] | out_alu[6] | out_alu[5] | out_alu[4] |
		          out_alu[3] | out_alu[2] | out_alu[1] | out_alu[0]; 
	  alu_daa:
	    if (daa_reg[7:4] == 4'b0110)
	      cc_out[CBIT] = 1'b1;
	    else
	      cc_out[CBIT] = 1'b0;
  	 alu_sec:
	   cc_out[CBIT] = 1'b1;
  	  alu_clc:
	    cc_out[CBIT] = 1'b0;
	  alu_tap:
	    cc_out[CBIT] = left[CBIT];
  	  default: 		// carry is ~affected by cpx
	    cc_out[CBIT] = cc[CBIT];
	endcase

	//--
	//-- Zero flag
	//--
	case (alu_ctrl)
  	  alu_add8, alu_sub8,
	  alu_adc, alu_sbc,
  	  alu_and, alu_ora, alu_eor,
  	  alu_inc, alu_dec, 
	  alu_neg, alu_com, alu_clr,
	  alu_rol8, alu_ror8, alu_asr8, alu_asl8, alu_lsr8,
	  alu_ld8 , alu_st8:
	    cc_out[ZBIT] = ~( out_alu[7]  | out_alu[6]  | out_alu[5]  | out_alu[4]  |
	                      out_alu[3]  | out_alu[2]  | out_alu[1]  | out_alu[0] );
  	  alu_add16, alu_sub16,
  	    alu_lsl16, alu_lsr16,
  	    alu_inx, alu_dex,
	    alu_ld16 , alu_st16, alu_cpx:
	      cc_out[ZBIT] = ~( out_alu[15] | out_alu[14] | out_alu[13] | out_alu[12] |
	                        out_alu[11] | out_alu[10] | out_alu[9]  | out_alu[8]  |
  	                        out_alu[7]  | out_alu[6]  | out_alu[5]  | out_alu[4]  |
	                        out_alu[3]  | out_alu[2]  | out_alu[1]  | out_alu[0] );
	  alu_tap:
	    cc_out[ZBIT] = left[ZBIT];
  	  default:
	    cc_out[ZBIT] = cc[ZBIT];
	endcase

	//--
	//-- negative flag
	//--
	case (alu_ctrl)
  	  alu_add8, alu_sub8,
	  alu_adc, alu_sbc,
	  alu_and, alu_ora, alu_eor,
  	  alu_rol8, alu_ror8, alu_asr8, alu_asl8, alu_lsr8,
  	  alu_inc, alu_dec, alu_neg, alu_com, alu_clr,
	  alu_ld8 , alu_st8:
	    cc_out[NBIT] = out_alu[7];
	  alu_add16, alu_sub16,
	    alu_lsl16, alu_lsr16,
	    alu_ld16, alu_st16, alu_cpx:
	      cc_out[NBIT] = out_alu[15];
	  alu_tap:
	    cc_out[NBIT] = left[NBIT];
  	  default:
	    cc_out[NBIT] = cc[NBIT];
	endcase

	//--
	//-- Interrupt mask flag
	//--
	case (alu_ctrl)
  	  alu_sei:
	    cc_out[IBIT] = 1'b1;               // set interrupt mask
  	  alu_cli:
	    cc_out[IBIT] = 1'b0;               // clear interrupt mask
	  alu_tap:
	    cc_out[IBIT] = left[IBIT];
  	  default:
	    cc_out[IBIT] = cc[IBIT];           // interrupt mask
	endcase

	//--
	//-- Half Carry flag
	//--
	case (alu_ctrl)
  	  alu_add8, alu_adc:
	    cc_out[HBIT] = (left[3] & right[3]) |
			   (right[3] & ~out_alu[3]) | 
			   (left[3] & ~out_alu[3]);
	  alu_tap:
	    cc_out[HBIT] = left[HBIT];
  	  default:
	    cc_out[HBIT] = cc[HBIT];
	endcase

	//--
	//-- Overflow flag
	//--
	case (alu_ctrl)
  	  alu_add8, alu_adc:
	    cc_out[VBIT] =   (left[7]  &   right[7]  & (~out_alu[7])) |
			   ((~left[7]) & (~right[7]) &   out_alu[7]);
	  alu_sub8, alu_sbc:
	    cc_out[VBIT] =   (left[7]  & (~right[7]) & (~out_alu[7])) |
			   ((~left[7]) &   right[7]  &   out_alu[7]);
  	  alu_add16:
	    cc_out[VBIT] =   (left[15]  &   right[15]  & (~out_alu[15])) |
			   ((~left[15]) & (~right[15]) &   out_alu[15]);
	  alu_sub16, alu_cpx:
	    cc_out[VBIT] =   (left[15]  & (~right[15]) & (~out_alu[15])) |
			   ((~left[15]) &   right[15] &    out_alu[15]);
	  alu_inc:
	    cc_out[VBIT] = ((~left[7]) & left[6] & left[5] & left[4] &
		              left[3]  & left[2] & left[1] & left[0]);
	  alu_dec, alu_neg:
	    cc_out[VBIT] =   (left[7]  & (~left[6]) & (~left[5]) & (~left[4]) &
		            (~left[3]) & (~left[2]) & (~left[1]) & (~left[0]));
	  alu_asr8:
	    cc_out[VBIT] = left[0] ^ left[7];
	  alu_lsr8, alu_lsr16:
	    cc_out[VBIT] = left[0];
	  alu_ror8:
	    cc_out[VBIT] = left[0] ^ cc[CBIT];
	  alu_lsl16:
	    cc_out[VBIT] = left[15] ^ left[14];
	  alu_rol8, alu_asl8 :
	    cc_out[VBIT] = left[7] ^ left[6];
	  alu_tap:
	    cc_out[VBIT] = left[VBIT];
	  alu_and, alu_ora, alu_eor, alu_com,
	    alu_st8, alu_st16, alu_ld8, alu_ld16,
	    alu_clv:
	      cc_out[VBIT] = 1'b0;
	  alu_sev:
	    cc_out[VBIT] = 1'b1;
  	  default:
	    cc_out[VBIT] = cc[VBIT];
	endcase

	case (alu_ctrl)
	  alu_tap:
	    begin
	       cc_out[XBIT] = cc[XBIT] & left[XBIT];
	       cc_out[SBIT] = left[SBIT];
	    end
	  default:
	    begin
	       cc_out[XBIT] = cc[XBIT] & left[XBIT];
	       cc_out[SBIT] = cc[SBIT];
	    end
	endcase

	test_alu = out_alu;
	test_cc  = cc_out;
     end // always @ ( alu_ctrl, cc, left, right, out_alu, cc_out )

   //------------------------------------
   //-- Detect Edge of NMI interrupt
   //------------------------------------

   always @(negedge clk or posedge rst)
     if (hold)
       nmi_req <= nmi_req;
     else
       if (rst)
	 nmi_req <= 1'b0;
       else
	 if (nmi & nmi_ack == 1'b0)
	   nmi_req <= 1'b1;
	 else
	   if (nmi == 1'b0 & nmi_ack)
	     nmi_req <= 1'b0;
	   else
	     nmi_req <= nmi_req;

   //------------------------------------
   //-- Nmi mux
   //------------------------------------

   always @(negedge clk or posedge rst)
     if (hold)
       nmi_ack <= nmi_ack;
     else
       case (nmi_ctrl)
	 set_nmi:   nmi_ack <= 1'b1;
	 reset_nmi: nmi_ack <= 1'b0;
	 //latch_nmi,
	 default:   nmi_ack <= nmi_ack;
       endcase

   //------------------------------------
   //-- state sequencer
   //------------------------------------

   always @( state, op_code, cc, ea, irq, nmi_req, nmi_ack, hold, halt )
     begin
	case (state)
          reset_state:        //  released from reset
	    begin
	       // reset the registers
               op_ctrl    = reset_op;
	       acca_ctrl  = reset_acca;
	       accb_ctrl  = reset_accb;
	       ix_ctrl    = reset_ix;
	       sp_ctrl    = reset_sp;
	       pc_ctrl    = reset_pc;
	       ea_ctrl    = reset_ea;
	       md_ctrl    = reset_md;
	       iv_ctrl    = reset_iv;
	       nmi_ctrl   = reset_nmi;
	       // idle the ALU
               left_ctrl  = acca_left;
	       right_ctrl = zero_right;
	       alu_ctrl   = alu_nop;
               cc_ctrl    = reset_cc;
	       // idle the bus
	       dout_ctrl  = md_lo_dout;
               addr_ctrl  = idle_ad;
	       next_state = vect_hi_state;
	    end
	  
	  //
	  // Jump via interrupt vector
	  // iv holds interrupt type
	  // fetch PC hi from vector location
	  //
          vect_hi_state:
	    begin
	       // default the registers
               op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               md_ctrl    = latch_md;
               ea_ctrl    = latch_ea;
               iv_ctrl    = latch_iv;
	       // idle the ALU
               left_ctrl  = acca_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
	       // fetch pc low interrupt vector
	       pc_ctrl    = pull_hi_pc;
               addr_ctrl  = int_hi_ad;
               dout_ctrl  = pc_hi_dout;
	       next_state = vect_lo_state;
	    end
	  
	  //
	  // jump via interrupt vector
	  // iv holds vector type
	  // fetch PC lo from vector location
	  //
          vect_lo_state:
	    begin
			    // default the registers
             op_ctrl    = latch_op;
				 nmi_ctrl   = latch_nmi;
             acca_ctrl  = latch_acca;
             accb_ctrl  = latch_accb;
             ix_ctrl    = latch_ix;
             sp_ctrl    = latch_sp;
             md_ctrl    = latch_md;
             ea_ctrl    = latch_ea;
             iv_ctrl    = latch_iv;
				 // idle the ALU
             left_ctrl  = acca_left;
             right_ctrl = zero_right;
             alu_ctrl   = alu_nop;
             cc_ctrl    = latch_cc;
				 // fetch the vector low byte
		       pc_ctrl    = pull_lo_pc;
             addr_ctrl  = int_lo_ad;
             dout_ctrl  = pc_lo_dout;
	 	       next_state = fetch_state;
	    end
	  
	  //
	  // Here to fetch an instruction
	  // PC points to opcode
	  // Should service interrupt requests at this point
	  // either from the timer
	  // or from the external input.
	  //
          fetch_state:
	    begin
`ifdef debug_pc
	       $display("cpu68: fetch pc=%x op_code=%x", pc, op_code);
`endif
	       case (op_code[7:4])
		 4'b0000,
	         4'b0001,
	         4'b0010,  // branch conditional
	         4'b0011,
	         4'b0100,  // acca single op
	         4'b0101,  // accb single op
	         4'b0110,  // indexed single op
	         4'b0111: // extended single op
		   begin
		      // idle ALU
                      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
                      acca_ctrl  = latch_acca;
                      accb_ctrl  = latch_accb;
                      ix_ctrl    = latch_ix;
                      sp_ctrl    = latch_sp;
		   end // case: op_code[7:4]...
		 
	         4'b1000, // acca immediate
	           4'b1001, // acca direct
	           4'b1010, // acca indexed
                   4'b1011: // acca extended
		     begin
			case (op_code[3:0])
			  4'b0000: // suba
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sub8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0001: // cmpa
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sub8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0010: // sbca
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sbc;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0011: // subd
			    begin
			       left_ctrl   = accd_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sub16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_hi_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0100: // anda
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_and;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0101: // bita
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_and;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0110: // ldaa
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ld8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0111: // staa
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_st8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1000: // eora
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_eor;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1001: // adca
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_adc;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1010: // oraa
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ora;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1011: // adda
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_add8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1100: // cpx
			    begin
			       left_ctrl   = ix_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_cpx;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1101: // bsr / jsr
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_nop;
			       cc_ctrl     = latch_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1110: // lds
			    begin
			       left_ctrl   = sp_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ld16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = load_sp;
			    end
			  4'b1111: // sts
			    begin
			       left_ctrl   = sp_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_st16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  default:
			    begin
			       left_ctrl   = acca_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_nop;
			       cc_ctrl     = latch_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			endcase // case op_code[3
		     end // case: 4'b1000,...

		 4'b1100, // accb immediate
	           4'b1101, // accb direct
	           4'b1110, // accb indexed
		   4'b1111: // accb extended
		     begin
			case (op_code[3:0])
			  4'b0000: // subb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sub8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0001: // cmpb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sub8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0010: // sbcb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_sbc;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0011: // addd
			    begin
			       left_ctrl   = accd_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_add16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_hi_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0100: // andb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_and;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0101: // bitb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_and;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0110: // ldab
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ld8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b0111: // stab
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_st8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1000: // eorb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_eor;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1001: // adcb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_adc;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1010: // orab
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ora;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1011: // addb
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_add8;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end				       
			  4'b1100: // ldd
			    begin
			       left_ctrl   = accd_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ld16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = load_hi_acca;
			       accb_ctrl   = load_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1101: // std
			    begin
			       left_ctrl   = accd_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_st16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1110: // ldx
			    begin
			       left_ctrl   = ix_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_ld16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = load_ix;
			       sp_ctrl     = latch_sp;
			    end
			  4'b1111: // stx
			    begin
			       left_ctrl   = ix_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_st16;
			       cc_ctrl     = load_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			  default:
			    begin
			       left_ctrl   = accb_left;
			       right_ctrl  = md_right;
			       alu_ctrl    = alu_nop;
			       cc_ctrl     = latch_cc;
			       acca_ctrl   = latch_acca;
			       accb_ctrl   = latch_accb;
			       ix_ctrl     = latch_ix;
			       sp_ctrl     = latch_sp;
			    end
			endcase // case (op_code[3:0])
		     end // case: 4'b1100,...
		 
		 default:
		   begin
		      left_ctrl   = accd_left;
		      right_ctrl  = md_right;
		      alu_ctrl    = alu_nop;
		      cc_ctrl     = latch_cc;
		      acca_ctrl   = latch_acca;
		      accb_ctrl   = latch_accb;
		      ix_ctrl     = latch_ix;
		      sp_ctrl     = latch_sp;
		   end
               endcase // case op_code[7

          md_ctrl    = latch_md;
	  // fetch the op code
	  op_ctrl    = fetch_op;
          ea_ctrl    = reset_ea;
          addr_ctrl  = fetch_ad;
          dout_ctrl  = md_lo_dout;
	  iv_ctrl    = latch_iv;
	  if (halt)
	    begin
               pc_ctrl    = latch_pc;
	       nmi_ctrl   = latch_nmi;
	       next_state = halt_state;
	       // service non maskable interrupts
	    end
	  else
	    if (nmi_req && ~nmi_ack)
	      begin
		 pc_ctrl    = latch_pc;
		 nmi_ctrl   = set_nmi;
		 next_state = int_pcl_state;
	      end
	    else
	      // service maskable interrupts
	      begin
		 //
		 // nmi request is not cleared until nmi input goes low
		 //
		 if (nmi_req == 1'b0 && nmi_ack)
		   nmi_ctrl = reset_nmi;
		 else
		   nmi_ctrl = latch_nmi;

		 //
		 // IRQ is level sensitive
		 //
		 if (irq && ~cc[IBIT])
		   begin
		      pc_ctrl    = latch_pc;
		      next_state = int_pcl_state;
		   end
		 else
		   begin
		      // Advance the PC to fetch next instruction byte
		      pc_ctrl    = inc_pc;
		      next_state = decode_state;
		   end
	      end // else: !if(nmi_req && ~nmi_ack)
	    end // case: fetch_state
	      
	  //
	  // Here to decode instruction
	  // and fetch next byte of intruction
	  // whether it be necessary or not
	  //
          decode_state:
	    begin
	       // fetch first byte of address or immediate data
               ea_ctrl    = fetch_first_ea;
               addr_ctrl  = fetch_ad;
               dout_ctrl  = md_lo_dout;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               iv_ctrl    = latch_iv;
	       case (op_code[7:4])
		 4'b0000:
		   begin
		      md_ctrl    = fetch_first_md;
		      sp_ctrl    = latch_sp;
		      pc_ctrl    = latch_pc;
  	              case (op_code[3:0])
		        4'b0001: // nop
			  begin
			     left_ctrl  = accd_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b0100: // lsrd
			  begin
			     left_ctrl  = accd_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_lsr16;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = load_hi_acca;
			     accb_ctrl  = load_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b0101: // lsld
			  begin
			     left_ctrl  = accd_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_lsl16;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = load_hi_acca;
			     accb_ctrl  = load_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b0110: // tap
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_tap;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b0111: // tpa
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_tpa;
			     cc_ctrl    = latch_cc;
			     acca_ctrl  = load_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1000: // inx
			  begin
			     left_ctrl  = ix_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_inx;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = load_ix;
			  end
		        4'b1001: // dex
			  begin
			     left_ctrl  = ix_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_dex;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = load_ix;
			  end
		        4'b1010: // clv
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_clv;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1011: // sev
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_sev;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1100: // clc
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_clc;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1101: // sec
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_sec;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1110: // cli
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_cli;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		        4'b1111: // sei
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_sei;
			     cc_ctrl    = load_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
			default:
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     acca_ctrl  = latch_acca;
			     accb_ctrl  = latch_accb;
			     ix_ctrl    = latch_ix;
			  end
		      endcase

		      next_state = fetch_state;
		   end // case: 4'b0000
		 
				 // acca / accb inherent instructions
	          4'b0001:
		    begin
		       md_ctrl    = fetch_first_md;
		       ix_ctrl    = latch_ix;
		       sp_ctrl    = latch_sp;
		       pc_ctrl    = latch_pc;
		       left_ctrl  = acca_left;
	               right_ctrl = accb_right;
	               case (op_code[3:0])
		         4'b0000: // sba
			   begin
			      alu_ctrl   = alu_sub8;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = load_acca;
			      accb_ctrl  = latch_accb;
			   end
		         4'b0001: // cba
			   begin
			      alu_ctrl   = alu_sub8;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = latch_acca;
			      accb_ctrl  = latch_accb;
			      end
		         4'b0110: // tab
			   begin
			      alu_ctrl   = alu_st8;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = latch_acca;
			      accb_ctrl  = load_accb;
			   end
		         4'b0111: // tba
			   begin
			      alu_ctrl   = alu_ld8;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = load_acca;
			      accb_ctrl  = latch_accb;
			   end
		         4'b1001: // daa
			   begin
			      alu_ctrl   = alu_daa;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = load_acca;
			      accb_ctrl  = latch_accb;
			   end
		         4'b1011: // aba
			   begin
			      alu_ctrl   = alu_add8;
			      cc_ctrl    = load_cc;
			      acca_ctrl  = load_acca;
			      accb_ctrl  = latch_accb;
			   end
		         default:
			   begin
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      acca_ctrl  = latch_acca;
			      accb_ctrl  = latch_accb;
			   end
		       endcase // case (op_code[3:0])

		       next_state = fetch_state;
		    end // case: 4'b0001
		 
	         4'b0010: // branch conditional
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      // increment the pc
		      pc_ctrl    = inc_pc;
		      case (op_code[3:0])
		        4'b0000: // bra
			  begin
			     next_state = branch_state;
			  end
		        4'b0001: // brn
			  begin
			     next_state = fetch_state;
			  end
		        4'b0010: // bhi
			  begin
			     if ((cc[CBIT] | cc[ZBIT]) == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
		        4'b0011: // bls
			  begin
			     if (cc[CBIT] | cc[ZBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b0100: // bcc/bhs
			  begin
			     if (cc[CBIT] == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b0101: // bcs/blo
			  begin
			     if (cc[CBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b0110: // bne
			  begin
			     if (cc[ZBIT] == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b0111: // beq
			  begin
			     if (cc[ZBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1000: // bvc
			  begin
			     if (cc[VBIT] == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1001: // bvs
			  begin
			     if (cc[VBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1010: // bpl
			  begin
			     if (cc[NBIT] == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1011: // bmi
			  begin
			     if (cc[NBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1100: // bge
			  begin
			     if ((cc[NBIT] ^ cc[VBIT]) == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1101: // blt
			  begin
			     if (cc[NBIT] ^ cc[VBIT])
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1110: // bgt
			  begin
			     if ((cc[ZBIT] | (cc[NBIT] ^ cc[VBIT])) == 1'b0)
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			4'b1111: // ble
			  begin
			     if (cc[ZBIT] | (cc[NBIT] ^ cc[VBIT]))
			       next_state = branch_state;
			     else
			       next_state = fetch_state;
			  end
			default:
			  begin
			     next_state = fetch_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b0010
		 
		 //
		 // Single byte stack operators
		 // Do not advance PC
		 //
	         4'b0011:
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      pc_ctrl    = latch_pc;
	              case (op_code[3:0])
		        4'b0000: // tsx
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = load_ix;
			     sp_ctrl    = latch_sp;
			     next_state = fetch_state;
			  end
		        4'b0001: // ins
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = fetch_state;
			  end
		        4'b0010: // pula
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = pula_state;
			  end
		        4'b0011: // pulb
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = pulb_state;
			  end
		        4'b0100: // des
			  begin
			     // decrement sp
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_sub16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = fetch_state;
			  end
		        4'b0101: // txs
			  begin
		             left_ctrl  = ix_left;
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_sub16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = fetch_state;
			  end
		        4'b0110: // psha
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = psha_state;
			  end
		        4'b0111: // pshb
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = pshb_state;
			  end
		        4'b1000: // pulx
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = pulx_hi_state;
			  end
		        4'b1001: // rts
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = rts_hi_state;
			  end
		        4'b1010: // abx
			  begin
		             left_ctrl  = ix_left;
		             right_ctrl = accb_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = load_ix;
			     sp_ctrl    = latch_sp;
			     next_state = fetch_state;
			  end
		        4'b1011: // rti
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = plus_one_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = load_sp;
			     next_state = rti_cc_state;
			  end
		        4'b1100: // pshx
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = pshx_lo_state;
			  end
		        4'b1101: // mul
			  begin
		             left_ctrl  = acca_left;
		             right_ctrl = accb_right;
			     alu_ctrl   = alu_add16;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = mul_state;
			  end
		        4'b1110: // wai
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = int_pcl_state;
			  end
		        4'b1111: // swi
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = int_pcl_state;
			  end
		        default:
			  begin
		             left_ctrl  = sp_left;
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     ix_ctrl    = latch_ix;
			     sp_ctrl    = latch_sp;
			     next_state = fetch_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b0011
		 
		 //
		 // Accumulator A Single operand
		 // source = Acc A dest = Acc A
		 // Do not advance PC
		 //
	         4'b0100: // acca single op
		   begin
		      md_ctrl    = fetch_first_md;
		      accb_ctrl  = latch_accb;
		      pc_ctrl    = latch_pc;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      left_ctrl  = acca_left;
	              case (op_code[3:0])
		        4'b0000: // neg
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_neg;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
 			4'b0011: // com
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_com;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b0100: // lsr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_lsr8;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b0110: // ror
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_ror8;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b0111: // asr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_asr8;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1000: // asl
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_asl8;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1001: // rol
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_rol8;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1010: // dec
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_dec;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1011: // undefined
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     acca_ctrl  = latch_acca;
			     cc_ctrl    = latch_cc;
			  end
		        4'b1100: // inc
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_inc;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1101: // tst
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     acca_ctrl  = latch_acca;
			     cc_ctrl    = load_cc;
			  end
		        4'b1110: // jmp
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     acca_ctrl  = latch_acca;
			     cc_ctrl    = latch_cc;
			  end
		        4'b1111: // clr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_clr;
			     acca_ctrl  = load_acca;
			     cc_ctrl    = load_cc;
			  end
		        default:
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     acca_ctrl  = latch_acca;
			     cc_ctrl    = latch_cc;
			  end
		      endcase

		      next_state = fetch_state;
		   end // case: 4'b0100
		 
		 //
		 // single operand acc b
		 // Do not advance PC
		 //
	         4'b0101:
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      pc_ctrl    = latch_pc;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      left_ctrl  = accb_left;
	              case (op_code[3:0])
		        4'b0000: // neg
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_neg;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
 			4'b0011: // com
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_com;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b0100: // lsr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_lsr8;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b0110: // ror
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_ror8;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b0111: // asr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_asr8;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1000: // asl
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_asl8;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1001: // rol
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_rol8;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1010: // dec
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_dec;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1011: // undefined
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     accb_ctrl  = latch_accb;
			     cc_ctrl    = latch_cc;
			  end
		        4'b1100: // inc
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_inc;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1101: // tst
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     accb_ctrl  = latch_accb;
			     cc_ctrl    = load_cc;
			  end
		        4'b1110: // jmp
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     accb_ctrl  = latch_accb;
			     cc_ctrl    = latch_cc;
			  end
		        4'b1111: // clr
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_clr;
			     accb_ctrl  = load_accb;
			     cc_ctrl    = load_cc;
			  end
		        default:
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     accb_ctrl  = latch_accb;
			     cc_ctrl    = latch_cc;
			  end
		      endcase

		      next_state = fetch_state;
		   end // case: 4'b0101
		 
		 //
		 // Single operand indexed
		 // Two byte instruction so advance PC
		 // EA should hold index offset
		 //
	         4'b0110: // indexed single op
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc 
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      next_state = indexed_state;
		   end // case: 4'b0110
		 
		 //
		 // Single operand extended addressing
		 // three byte instruction so advance the PC
		 // Low order EA holds high order address
		 //
	         4'b0111: // extended single op
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      next_state = extended_state;
		   end // case: 4'b0111
		 
	         4'b1000: // acca immediate
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      case (op_code[3:0])
			4'b0011, // subdd #
			4'b1100, // cpx #
			4'b1110: // lds #
			  next_state = immediate16_state;
			4'b1101: // bsr
			  next_state = bsr_state;
			default:
			  next_state = fetch_state;
		      endcase // case (op_code[3:0])
		   end // case: 4'b1000

	         4'b1001: // acca direct
		   begin
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      pc_ctrl    = inc_pc;
		      case (op_code[3:0])
			4'b0111:  // staa direct
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
			4'b1111: // sts direct
			  begin
			     left_ctrl  = sp_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st16;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write16_state;
			  end
			4'b1101: // jsr direct
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     next_state = jsr_state;
			  end
			default:
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     next_state = read8_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1001
			
	         4'b1010: // acca indexed
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      next_state = indexed_state;
		   end

		 4'b1011: // acca extended
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      next_state = extended_state;
		   end

	         4'b1100: // accb immediate
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      case (op_code[3:0])
			4'b0011, // addd #
			4'b1100, // ldd #
			4'b1110: // ldx #
			  next_state = immediate16_state;
			default:
			  next_state = fetch_state;
		      endcase
		   end // case: 4'b1100
		 
	         4'b1101: // accb direct
		   begin
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      pc_ctrl    = inc_pc;
		      case (op_code[3:0])
			4'b0111:  // stab direct
			  begin
			     left_ctrl  = accb_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
			4'b1101: // std direct
			  begin
			     left_ctrl  = accd_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st16;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write16_state;
			  end
			4'b1111: // stx direct
			  begin
			     left_ctrl  = ix_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st16;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write16_state;
			  end
			default:
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     next_state = read8_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1101

	          4'b1110: // accb indexed
		    begin
		       md_ctrl    = fetch_first_md;
		       acca_ctrl  = latch_acca;
		       accb_ctrl  = latch_accb;
		       ix_ctrl    = latch_ix;
		       sp_ctrl    = latch_sp;
		       // increment the pc
		       left_ctrl  = acca_left;
		       right_ctrl = zero_right;
		       alu_ctrl   = alu_nop;
		       cc_ctrl    = latch_cc;
		       pc_ctrl    = inc_pc;
		       next_state = indexed_state;
		    end

		 4'b1111: // accb extended
		   begin
		      md_ctrl    = fetch_first_md;
		      acca_ctrl  = latch_acca;
		      accb_ctrl  = latch_accb;
		      ix_ctrl    = latch_ix;
		      sp_ctrl    = latch_sp;
		      // increment the pc
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      pc_ctrl    = inc_pc;
		      next_state = extended_state;
		   end

	          default:
		    begin
		       md_ctrl    = fetch_first_md;
		       acca_ctrl  = latch_acca;
		       accb_ctrl  = latch_accb;
		       ix_ctrl    = latch_ix;
		       sp_ctrl    = latch_sp;
		       // idle the pc
		       left_ctrl  = acca_left;
		       right_ctrl = zero_right;
		       alu_ctrl   = alu_nop;
  		       cc_ctrl    = latch_cc;
		       pc_ctrl    = latch_pc;
 		       next_state = fetch_state;
		    end
               endcase // case (op_code[7:4])
	    end // case: decode_state
	  
	  immediate16_state:
	    begin
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
	       op_ctrl    = latch_op;
               iv_ctrl    = latch_iv;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment pc
               left_ctrl  = acca_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
               pc_ctrl    = inc_pc;
	       // fetch next immediate byte
	       md_ctrl    = fetch_next_md;
               addr_ctrl  = fetch_ad;
               dout_ctrl  = md_lo_dout;
	       next_state = fetch_state;
	    end // case: immediate16_state
	  
          //
	  // ea holds 8 bit index offet
	  // calculate the effective memory address
	  // using the alu
	  //
          indexed_state:
	    begin
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               pc_ctrl    = latch_pc;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
	       // calculate effective address from index reg
               // index offest is not sign extended
               ea_ctrl    = add_ix_ea;
	       // idle the bus
               addr_ctrl  = idle_ad;
               dout_ctrl  = md_lo_dout;
	       // work out next state
	       case (op_code[7:4])
		 4'b0110: // single op indexed
		   begin
		      md_ctrl    = latch_md;
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
	              case (op_code[3:0])
		        4'b1011: // undefined
			  next_state = fetch_state;
		        4'b1110: // jmp
			  next_state = jmp_state;
		        default:
			  next_state = read8_state;
		      endcase // case (op_code[3:0])
		   end // case: 4'b0110
		 
	          4'b1010: // acca indexed
		    begin
		       case (op_code[3:0])
			 4'b0111:  // staa
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st8;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write8_state;
			   end
			 4'b1101: // jsr
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = latch_md;
			      next_state = jsr_state;
			   end
			 4'b1111: // sts
			   begin
			      left_ctrl  = sp_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st16;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write16_state;
			   end
			 default:
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = latch_md;
			      next_state = read8_state;
			   end
		       endcase // case (op_code[3:0])
		    end // case: 4'b1010
		 
	         4'b1110: // accb indexed
		   begin
		      case (op_code[3:0])
			4'b0111:  // stab direct
			  begin
			     left_ctrl  = accb_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
			4'b1101: // std direct
			  begin
			     left_ctrl  = accd_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st16;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write16_state;
			  end
			4'b1111: // stx direct
			  begin
			     left_ctrl  = ix_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_st16;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = load_md;
			     next_state = write16_state;
			  end
			default:
			  begin
			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = latch_md;
			     next_state = read8_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1110
		 
		 default:
		   begin
		      md_ctrl    = latch_md;
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      next_state = fetch_state;
		   end
	       endcase // case (op_code[7:4])
	    end // case: indexed_state
	  
          //
	  // ea holds the low byte of the absolute address
	  // Move ea low byte into ea high byte
	  // load new ea low byte to for absolute 16 bit address
	  // advance the program counter
	  //
	  extended_state: // fetch ea low byte
	    begin
		    acca_ctrl  = latch_acca;
		    accb_ctrl  = latch_accb;
		    ix_ctrl    = latch_ix;
		    sp_ctrl    = latch_sp;
		    iv_ctrl    = latch_iv;
		    op_ctrl    = latch_op;
		    nmi_ctrl   = latch_nmi;
		    // increment pc
		    pc_ctrl    = inc_pc;
		    // fetch next effective address bytes
		    ea_ctrl    = fetch_next_ea;
		    addr_ctrl  = fetch_ad;
	       dout_ctrl  = md_lo_dout;
	       // work out the next state
	       case (op_code[7:4])
		      4'b0111: // single op extended
			begin
			   md_ctrl    = latch_md;
			   left_ctrl  = acca_left;
			   right_ctrl = zero_right;
			   alu_ctrl   = alu_nop;
			   cc_ctrl    = latch_cc;
			   case (op_code[3:0])
		             4'b1011: // undefined
			       next_state = fetch_state;
		             4'b1110: // jmp
			       next_state = jmp_state;
		             default:
			       next_state = read8_state;
		           endcase // case (op_code[3:0])
			end // case: 4'b0111
		      
	          4'b1011: // acca extended
		    begin
		       case (op_code[3:0])
			 4'b0111:  // staa
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st8;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write8_state;
			   end
			 4'b1101: // jsr
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = latch_md;
			      next_state = jsr_state;
			   end
			 4'b1111: // sts
			   begin
			      left_ctrl  = sp_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st16;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write16_state;
			   end
			 default:
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = latch_md;
			      next_state = read8_state;
			   end
		       endcase // case (op_code[3:0])
		    end // case: 4'b1011

	         4'b1111: // accb extended
		   begin
		      case (op_code[3:0])
			4'b0111:  // stab
			  begin
			      left_ctrl  = accb_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st8;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write8_state;
			   end
			 4'b1101: // std
			   begin
			      left_ctrl  = accd_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st16;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write16_state;
			   end
			 4'b1111: // stx
			   begin
			      left_ctrl  = ix_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_st16;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = load_md;
			      next_state = write16_state;
			   end
			 default:
			   begin
			      left_ctrl  = acca_left;
			      right_ctrl = zero_right;
			      alu_ctrl   = alu_nop;
			      cc_ctrl    = latch_cc;
			      md_ctrl    = latch_md;
			      next_state = read8_state;
			   end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1111
		 
		 default:
		   begin
		      md_ctrl    = latch_md;
		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      next_state = fetch_state;
		   end
	       endcase // case (op_code[7:4])
	    end // case: extended_state
		    
          //
	  // here if ea holds low byte (direct page)
	  // can enter here from extended addressing
	  // read memory location
	  // note that reads may be 8 or 16 bits
	  //
	  read8_state: // read data
	    begin
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               pc_ctrl    = latch_pc;
               iv_ctrl    = latch_iv;
			      op_ctrl    = latch_op;
				   nmi_ctrl   = latch_nmi;
					//
               addr_ctrl  = read_ad;
	       dout_ctrl  = md_lo_dout;
	       case (op_code[7:4])
		 4'b0110, 4'b0111: // single operand
		   begin
 					      left_ctrl  = acca_left;
					      right_ctrl = zero_right;
					      alu_ctrl   = alu_nop;
                     cc_ctrl    = latch_cc;
				         md_ctrl    = fetch_first_md;
					      ea_ctrl    = latch_ea;
		      next_state = execute_state;
		   end
		 
	         4'b1001, 4'b1010, 4'b1011: // acca
		   begin
		      case (op_code[3:0])
			4'b0011,  // subd
			4'b1110,  // lds
			4'b1100: // cpx
			  begin
 			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     // increment the effective address in case of 16 bit load
			     ea_ctrl    = inc_ea;
			     next_state = read16_state;
			  end
//					    4'b0111:   // staa
// 					      left_ctrl  = acca_left;
//					      right_ctrl = zero_right;
//					      alu_ctrl   = alu_st8;
//                     cc_ctrl    = latch_cc;
//				         md_ctrl    = load_md;
// 					      ea_ctrl    = latch_ea;
//					      next_state = write8_state;
//					    4'b1101: // jsr
//			            left_ctrl  = acca_left;
//				         right_ctrl = zero_right;
//				         alu_ctrl   = alu_nop;
//                     cc_ctrl    = latch_cc;
//                     md_ctrl    = latch_md;
// 					      ea_ctrl    = latch_ea;
//					      next_state = jsr_state;
//					    4'b1111:  // sts
// 					      left_ctrl  = sp_left;
//					      right_ctrl = zero_right;
//					      alu_ctrl   = alu_st16;
//                     cc_ctrl    = latch_cc;
//				         md_ctrl    = load_md;
//					      ea_ctrl    = latch_ea;
//					      next_state = write16_state;
			default:
			  begin
 			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
 			     ea_ctrl    = latch_ea;
			     next_state = fetch_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1001, 4'b1010, 4'b1011
		 
	         4'b1101, 4'b1110, 4'b1111: // accb
		   begin
		      case (op_code[3:0])
			4'b0011,  // addd
			4'b1100,  // ldd
			4'b1110: // ldx
			  begin
 			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     // increment the effective address in case of 16 bit load
			     ea_ctrl    = inc_ea;
			     next_state = read16_state;
			  end
//					    4'b0111:   // stab
// 					      left_ctrl  = accb_left;
//					      right_ctrl = zero_right;
//					      alu_ctrl   = alu_st8;
//                     cc_ctrl    = latch_cc;
//				         md_ctrl    = load_md;
//					      ea_ctrl    = latch_ea;
//					      next_state = write8_state;
//					    4'b1101: // std
//			            left_ctrl  = accd_left;
//				         right_ctrl = zero_right;
//				         alu_ctrl   = alu_st16;
//                     cc_ctrl    = latch_cc;
//                     md_ctrl    = load_md;
// 					      ea_ctrl    = latch_ea;
//					      next_state = write16_state;
//					    4'b1111:  // stx
// 					      left_ctrl  = ix_left;
//					      right_ctrl = zero_right;
//					      alu_ctrl   = alu_st16;
//                     cc_ctrl    = latch_cc;
//				         md_ctrl    = load_md;
//					      ea_ctrl    = latch_ea;
//					      next_state = write16_state;
			default:
			  begin
 			     left_ctrl  = acca_left;
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = fetch_first_md;
			     ea_ctrl    = latch_ea;
			     next_state = execute_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b1101, 4'b1110, 4'b1111
		 
		 default:
		   begin
 		      left_ctrl  = acca_left;
		      right_ctrl = zero_right;
		      alu_ctrl   = alu_nop;
		      cc_ctrl    = latch_cc;
		      md_ctrl    = fetch_first_md;
		      ea_ctrl    = latch_ea;
		      next_state = fetch_state;
		   end
	       endcase // case (op_code[7:4])
	    end // case: read8_state
	  
	  read16_state: // read second data byte from ea
	    begin
                 // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
                 left_ctrl  = acca_left;
                 right_ctrl = zero_right;
                 alu_ctrl   = alu_nop;
                 cc_ctrl    = latch_cc;
					  // idle the effective address
                 ea_ctrl    = latch_ea;
					  // read the low byte of the 16 bit data
				     md_ctrl    = fetch_next_md;
                 addr_ctrl  = read_ad;
                 dout_ctrl  = md_lo_dout;
	       next_state = fetch_state;
	    end // case: read16_state
	  
           //
	  // 16 bit Write state
			  // write high byte of ALU output.
			  // EA hold address of memory to write to
			  // Advance the effective address in ALU
			  //
	  write16_state:
	    begin
				 // default
             acca_ctrl  = latch_acca;
             accb_ctrl  = latch_accb;
             ix_ctrl    = latch_ix;
             sp_ctrl    = latch_sp;
             pc_ctrl    = latch_pc;
             md_ctrl    = latch_md;
             iv_ctrl    = latch_iv;
			    op_ctrl    = latch_op;
				 nmi_ctrl   = latch_nmi;
				 // increment the effective address
				 left_ctrl  = acca_left;
				 right_ctrl = zero_right;
				 alu_ctrl   = alu_nop;
             cc_ctrl    = latch_cc;
			    ea_ctrl    = inc_ea;
 				 // write the ALU hi byte to ea
             addr_ctrl  = write_ad;
             dout_ctrl  = md_hi_dout;
				 next_state = write8_state;
	    end // case: write16_state
	  
          //
	  // 8 bit write
	  // Write low 8 bits of ALU output
	  //
	  write8_state:
	    begin
				 // default registers
             acca_ctrl  = latch_acca;
             accb_ctrl  = latch_accb;
             ix_ctrl    = latch_ix;
             sp_ctrl    = latch_sp;
             pc_ctrl    = latch_pc;
             md_ctrl    = latch_md;
             iv_ctrl    = latch_iv;
			    op_ctrl    = latch_op;
				 nmi_ctrl   = latch_nmi;
             ea_ctrl    = latch_ea;
				 // idle the ALU
             left_ctrl  = acca_left;
             right_ctrl = zero_right;
             alu_ctrl   = alu_nop;
             cc_ctrl    = latch_cc;
				 // write ALU low byte output
             addr_ctrl  = write_ad;
             dout_ctrl  = md_lo_dout;
				 next_state = fetch_state;
	    end // case: write8_state
	  
	  jmp_state:
	    begin
               acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // load PC with effective address
                 left_ctrl  = acca_left;
					  right_ctrl = zero_right;
				     alu_ctrl   = alu_nop;
                 cc_ctrl    = latch_cc;
					  pc_ctrl    = load_ea_pc;
					  // idle the bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
                 next_state = fetch_state;
	    end // case: jmp_state
	  
	  jsr_state: // JSR
	    begin
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
                 // decrement sp
                 left_ctrl  = sp_left;
                 right_ctrl = plus_one_right;
                 alu_ctrl   = alu_sub16;
                 cc_ctrl    = latch_cc;
                 sp_ctrl    = load_sp;
					  // write pc low
                 addr_ctrl  = push_ad;
					  dout_ctrl  = pc_lo_dout; 
                 next_state = jsr1_state;
	    end // case: jsr_state
	  
	  jsr1_state: // JSR
	    begin
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 pc_ctrl    = latch_pc;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
                 // decrement sp
                 left_ctrl  = sp_left;
                 right_ctrl = plus_one_right;
                 alu_ctrl   = alu_sub16;
                 cc_ctrl    = latch_cc;
                 sp_ctrl    = load_sp;
					  // write pc hi
                 addr_ctrl  = push_ad;
					  dout_ctrl  = pc_hi_dout; 
               next_state = jmp_state;
	    end // case: jsr1_state
	  
	  branch_state: // Bcc
	    begin
				     // default registers
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // calculate signed branch
					  left_ctrl  = acca_left;
					  right_ctrl = zero_right;
				     alu_ctrl   = alu_nop;
                 cc_ctrl    = latch_cc;
					  pc_ctrl    = add_ea_pc;
					  // idle the bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
                 next_state = fetch_state;
	    end // case: branch_state
	  
	  bsr_state: // BSR
	    begin
				     // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 pc_ctrl    = latch_pc;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
                 // decrement sp
                 left_ctrl  = sp_left;
                 right_ctrl = plus_one_right;
                 alu_ctrl   = alu_sub16;
                 cc_ctrl    = latch_cc;
                 sp_ctrl    = load_sp;
					  // write pc low
                 addr_ctrl  = push_ad;
					  dout_ctrl  = pc_lo_dout; 
                 next_state = bsr1_state;
	    end // case: bsr_state
	  
	  bsr1_state: // BSR
	    begin
				     // default registers
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 pc_ctrl    = latch_pc;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
                 // decrement sp
                 left_ctrl  = sp_left;
                 right_ctrl = plus_one_right;
                 alu_ctrl   = alu_sub16;
                 cc_ctrl    = latch_cc;
                 sp_ctrl    = load_sp;
					  // write pc hi
                 addr_ctrl  = push_ad;
					  dout_ctrl  = pc_hi_dout; 
                 next_state = branch_state;
	    end // case: bsr1_state
	  
	  rts_hi_state: // RTS
	    begin
				     // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 pc_ctrl    = latch_pc;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // increment the sp
                 left_ctrl  = sp_left;
                 right_ctrl = plus_one_right;
                 alu_ctrl   = alu_add16;
                 cc_ctrl    = latch_cc;
                 sp_ctrl    = load_sp;
                 // read pc hi
					  pc_ctrl    = pull_hi_pc;
                 addr_ctrl  = pull_ad;
                 dout_ctrl  = pc_hi_dout;
                 next_state = rts_lo_state;
	    end // case: rts_hi_state
	  
	  rts_lo_state: // RTS1
	    begin
				     // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 md_ctrl    = latch_md;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // idle the ALU
                 left_ctrl  = acca_left;
                 right_ctrl = zero_right;
                 alu_ctrl   = alu_nop;
                 cc_ctrl    = latch_cc;
					  // read pc low
					  pc_ctrl    = pull_lo_pc;
                 addr_ctrl  = pull_ad;
                 dout_ctrl  = pc_lo_dout;
                 next_state = fetch_state;
	    end // case: rts_lo_state
	  
	  mul_state:
	    begin
				   // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // move acca to md
                 left_ctrl  = acca_left;
                 right_ctrl = zero_right;
                 alu_ctrl   = alu_st16;
                 cc_ctrl    = latch_cc;
                 md_ctrl    = load_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mulea_state;
	    end // case: mul_state
	  
	  mulea_state:
	    begin
				     // default
                 acca_ctrl  = latch_acca;
                 accb_ctrl  = latch_accb;
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 md_ctrl    = latch_md;
					  // idle ALU
                 left_ctrl  = acca_left;
                 right_ctrl = zero_right;
                 alu_ctrl   = alu_nop;
                 cc_ctrl    = latch_cc;
					  // move accb to ea
                 ea_ctrl    = load_accb_ea;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = muld_state;
	    end // case: mulea_state
	  
				 muld_state:
	    begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
                 md_ctrl    = latch_md;
					  // clear accd
                 left_ctrl  = acca_left;
                 right_ctrl = zero_right;
                 alu_ctrl   = alu_ld8;
                 cc_ctrl    = latch_cc;
                 acca_ctrl  = load_hi_acca;
                 accb_ctrl  = load_accb;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul0_state;
	    end // case: muld_state
	  
				 mul0_state:
	    begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 0 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
	       if (ea[0])
		 begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
		    end
	       else
		 begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
		 end
	       
               md_ctrl    = shiftl_md;
					  // idle bus
               addr_ctrl  = idle_ad;
               dout_ctrl  = md_lo_dout;
	       next_state = mul1_state;
	    end // case: mul0_state
   
	  mul1_state:
	    begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 1 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
	       if (ea[1])
		 begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
		    end
	       else
		 begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
		 end // else: !if(ea[1])
	       
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul2_state;
	    end // case: mul1_state
	  
   
				 mul2_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 2 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
				      if (ea[2])
					begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					   end
				      else
					begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					end // else: !if(ea[2])
				      
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul3_state;
				   end // case: mul2_state
	  
				 mul3_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 3 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
				      if (ea[3])
					begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					   end
				      else
					begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					  end
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul4_state;
				   end // case: mul3_state
	  
				 mul4_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 4 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
					  if (ea[4])
					    begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					       end
					  else
					    begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					  end
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul5_state;
				   end // case: mul4_state
	  
				 mul5_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 5 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
				      if (ea[5])
					begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					   end
				      else
					begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					  end
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul6_state;
				   end // case: mul5_state
	  
				 mul6_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 6 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
				      if (ea[6])
					begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					   end
				      else
					begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					  end
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = mul7_state;
				   end // case: mul6_state
	  
	  mul7_state:
				   begin
				     // default
                 ix_ctrl    = latch_ix;
                 sp_ctrl    = latch_sp;
                 pc_ctrl    = latch_pc;
                 iv_ctrl    = latch_iv;
			        op_ctrl    = latch_op;
				     nmi_ctrl   = latch_nmi;
                 ea_ctrl    = latch_ea;
					  // if bit 7 of ea set, add accd to md
                 left_ctrl  = accd_left;
                 right_ctrl = md_right;
                 alu_ctrl   = alu_add16;
				      if (ea[7])
					begin
                   cc_ctrl    = load_cc;
                   acca_ctrl  = load_hi_acca;
                   accb_ctrl  = load_accb;
					   end
				      else
					begin
                   cc_ctrl    = latch_cc;
                   acca_ctrl  = latch_acca;
                   accb_ctrl  = latch_accb;
					   end
                 md_ctrl    = shiftl_md;
					  // idle bus
                 addr_ctrl  = idle_ad;
                 dout_ctrl  = md_lo_dout;
				     next_state = fetch_state;
				   end // case: mul7_state

	  execute_state: // execute single operand instruction
	    begin
	       // default
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
	       case (op_code[7:4])
	         4'b0110, // indexed single op
	         4'b0111: // extended single op
		   begin
                      acca_ctrl  = latch_acca;
                      accb_ctrl  = latch_accb;
                      ix_ctrl    = latch_ix;
                      sp_ctrl    = latch_sp;
                      pc_ctrl    = latch_pc;
                      iv_ctrl    = latch_iv;
                      ea_ctrl    = latch_ea;
		      // idle the bus
                      addr_ctrl  = idle_ad;
                      dout_ctrl  = md_lo_dout;
                      left_ctrl  = md_left;
	              case (op_code[3:0])
		        4'b0000: // neg
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_neg;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
 			4'b0011: // com
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_com;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b0100: // lsr
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_lsr8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b0110: // ror
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_ror8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b0111: // asr
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_asr8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b1000: // asl
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_asl8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b1001: // rol
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_rol8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b1010: // dec
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_dec;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b1011: // undefined
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = latch_md;
			     next_state = fetch_state;
			  end
		        4'b1100: // inc
			  begin
		             right_ctrl = plus_one_right;
			     alu_ctrl   = alu_inc;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        4'b1101: // tst
			  begin
		             right_ctrl = zero_right;
			     alu_ctrl   = alu_st8;
			     cc_ctrl    = load_cc;
			     md_ctrl    = latch_md;
			     next_state = fetch_state;
			  end
		        4'b1110: // jmp
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = latch_md;
			     next_state = fetch_state;
			  end
		        4'b1111: // clr
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_clr;
			     cc_ctrl    = load_cc;
			     md_ctrl    = load_md;
			     next_state = write8_state;
			  end
		        default:
			  begin
			     right_ctrl = zero_right;
			     alu_ctrl   = alu_nop;
			     cc_ctrl    = latch_cc;
			     md_ctrl    = latch_md;
			     next_state = fetch_state;
			  end
		      endcase // case (op_code[3:0])
		   end // case: 4'b0110,...
		 
	         default:
		   begin
		      left_ctrl   = accd_left;
		      right_ctrl  = md_right;
		      alu_ctrl    = alu_nop;
		      cc_ctrl     = latch_cc;
		      acca_ctrl   = latch_acca;
                      accb_ctrl   = latch_accb;
                      ix_ctrl     = latch_ix;
                      sp_ctrl     = latch_sp;
                      pc_ctrl     = latch_pc;
                      md_ctrl     = latch_md;
                      iv_ctrl     = latch_iv;
                      ea_ctrl     = latch_ea;
		      // idle the bus
                      addr_ctrl  = idle_ad;
                      dout_ctrl  = md_lo_dout;
		      next_state = fetch_state;
		   end
               endcase // case (op_code[7:4])
	    end // case: execute_state
	  
	  psha_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write acca
               addr_ctrl  = push_ad;
	       dout_ctrl  = acca_dout; 
               next_state = fetch_state;
	    end
	  
	  pula_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // idle sp
               left_ctrl  = sp_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
               sp_ctrl    = latch_sp;
	       // read acca
	       acca_ctrl  = pull_acca;
               addr_ctrl  = pull_ad;
               dout_ctrl  = acca_dout;
               next_state = fetch_state;
	    end // case: pula_state
	  
	  pshb_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write accb
               addr_ctrl  = push_ad;
	       dout_ctrl  = accb_dout; 
               next_state = fetch_state;
	    end // case: pshb_state
	  
	  pulb_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // idle sp
               left_ctrl  = sp_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
               sp_ctrl    = latch_sp;
	       // read accb
	       accb_ctrl  = pull_accb;
               addr_ctrl  = pull_ad;
               dout_ctrl  = accb_dout;
               next_state = fetch_state;
	    end // case: pulb_state
	  
	  pshx_lo_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write ix low
               addr_ctrl  = push_ad;
	       dout_ctrl  = ix_lo_dout; 
               next_state = pshx_hi_state;
	    end // case: pshx_lo_state
	  
	  pshx_hi_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write ix hi
               addr_ctrl  = push_ad;
	       dout_ctrl  = ix_hi_dout; 
               next_state = fetch_state;
	    end // case: pshx_hi_state
	  
	  pulx_hi_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // pull ix hi
	       ix_ctrl    = pull_hi_ix;
               addr_ctrl  = pull_ad;
               dout_ctrl  = ix_hi_dout;
               next_state = pulx_lo_state;
	    end // case: pulx_hi_state
	  
	  pulx_lo_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // idle sp
               left_ctrl  = sp_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
               sp_ctrl    = latch_sp;
	       // read ix low
	       ix_ctrl    = pull_lo_ix;
               addr_ctrl  = pull_ad;
               dout_ctrl  = ix_lo_dout;
               next_state = fetch_state;
	    end // case: pulx_lo_state
	  
          //
	  // return from interrupt
	  // enter here from bogus interrupts
	  //
	  rti_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               sp_ctrl    = load_sp;
	       // idle address bus
               cc_ctrl    = latch_cc;
               addr_ctrl  = idle_ad;
               dout_ctrl  = cc_dout;
               next_state = rti_cc_state;
	    end // case: rti_state
	  
	  rti_cc_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               sp_ctrl    = load_sp;
	       // read cc
               cc_ctrl    = pull_cc;
               addr_ctrl  = pull_ad;
               dout_ctrl  = cc_dout;
               next_state = rti_accb_state;
	    end // case: rti_cc_state
	  
	  rti_accb_state:
	    begin
	       // default registers
               acca_ctrl  = latch_acca;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // read accb
	       accb_ctrl  = pull_accb;
               addr_ctrl  = pull_ad;
               dout_ctrl  = accb_dout;
               next_state = rti_acca_state;
	    end // case: rti_accb_state
	  
	  rti_acca_state:
	    begin
	       // default registers
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // read acca
	       acca_ctrl  = pull_acca;
               addr_ctrl  = pull_ad;
               dout_ctrl  = acca_dout;
               next_state = rti_ixh_state;
	    end // case: rti_acca_state
	  
	  rti_ixh_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // read ix hi
	       ix_ctrl    = pull_hi_ix;
               addr_ctrl  = pull_ad;
               dout_ctrl  = ix_hi_dout;
               next_state = rti_ixl_state;
	    end // case: rti_ixh_state
	  
	  rti_ixl_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // read ix low
	       ix_ctrl    = pull_lo_ix;
               addr_ctrl  = pull_ad;
               dout_ctrl  = ix_lo_dout;
               next_state = rti_pch_state;
	    end // case: rti_ixl_state
	  
	  rti_pch_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // increment sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_add16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // pull pc hi
	       pc_ctrl    = pull_hi_pc;
               addr_ctrl  = pull_ad;
               dout_ctrl  = pc_hi_dout;
               next_state = rti_pcl_state;
	    end // case: rti_pch_state
	  
	  rti_pcl_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // idle sp
               left_ctrl  = sp_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
               sp_ctrl    = latch_sp;
	       // pull pc low
	       pc_ctrl    = pull_lo_pc;
               addr_ctrl  = pull_ad;
               dout_ctrl  = pc_lo_dout;
               next_state = fetch_state;
	    end // case: rti_pcl_state
	  
	  //
	  // here on interrupt
	  // iv register hold interrupt type
	  //
	  int_pcl_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write pc low
               addr_ctrl  = push_ad;
	       dout_ctrl  = pc_lo_dout; 
               next_state = int_pch_state;
	    end
	  
	  int_pch_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write pc hi
               addr_ctrl  = push_ad;
	       dout_ctrl  = pc_hi_dout; 
               next_state = int_ixl_state;
	    end

	  int_ixl_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write ix low
               addr_ctrl  = push_ad;
	       dout_ctrl  = ix_lo_dout; 
               next_state = int_ixh_state;
	    end // case: int_ixl_state
	  
	  int_ixh_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write ix hi
               addr_ctrl  = push_ad;
	       dout_ctrl  = ix_hi_dout; 
               next_state = int_acca_state;
	    end // case: int_ixh_state
	  
	  int_acca_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write acca
               addr_ctrl  = push_ad;
	       dout_ctrl  = acca_dout; 
               next_state = int_accb_state;
	    end // case: int_acca_state
	  

	  int_accb_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write accb
               addr_ctrl  = push_ad;
	       dout_ctrl  = accb_dout; 
               next_state = int_cc_state;
	    end // case: int_accb_state
	  
	  int_cc_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
               // decrement sp
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_sub16;
               cc_ctrl    = latch_cc;
               sp_ctrl    = load_sp;
	       // write cc
               addr_ctrl  = push_ad;
	       dout_ctrl  = cc_dout;
	       nmi_ctrl   = latch_nmi;
	       //
	       // nmi is edge triggered
	       // nmi_req is cleared nmi goes low.
	       //
	       if (nmi_req)
		 begin
		    iv_ctrl    = nmi_iv;
		    next_state = vect_hi_state;
		 end
	       else
		 //
		 // IRQ is level sensitive
		 //
		 if (irq && cc[IBIT] == 1'b0)
		   begin
		      iv_ctrl    = irq_iv;
		      next_state = int_mask_state;
		   end
		 else
		   case (op_code)
		     8'b00111110: // WAI (wait for interrupt)
		       begin
			  iv_ctrl    = latch_iv;
	                  next_state = int_wai_state;
		       end
		     8'b00111111: // SWI (Software interrupt)
		       begin
			  iv_ctrl    = swi_iv;
	                  next_state = vect_hi_state;
		       end
		     default: // bogus interrupt (return)
		       begin
			  iv_ctrl    = latch_iv;
	                  next_state = rti_state;
		       end
		   endcase
	    end // case: int_cc_state
	  
	  int_wai_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
	       op_ctrl    = latch_op;
               ea_ctrl    = latch_ea;
               // enable interrupts
               left_ctrl  = sp_left;
               right_ctrl = plus_one_right;
               alu_ctrl   = alu_cli;
               cc_ctrl    = load_cc;
               sp_ctrl    = latch_sp;
	       // idle bus
               addr_ctrl  = idle_ad;
	       dout_ctrl  = cc_dout; 
	       if (nmi_req && nmi_ack == 1'b0)
		 begin
		    iv_ctrl    = nmi_iv;
		    nmi_ctrl   = set_nmi;
		    next_state = vect_hi_state;
		 end
	       else
		 begin
		    //
		    // nmi request is not cleared until nmi input goes low
		    //
		    if (nmi_req == 1'b0 && nmi_ack)
		      nmi_ctrl = reset_nmi;
		    else
		      nmi_ctrl = latch_nmi;

		    //
		    // IRQ is level sensitive
		    //
		    if (irq  && cc[IBIT] == 1'b0)
		      begin
		  	 iv_ctrl    = irq_iv;
			 next_state = int_mask_state;
		      end
		    else
		      begin
			 iv_ctrl    = latch_iv;
			 next_state = int_wai_state;
		      end
		 end // else: !if(nmi_req && nmi_ack == 1'b0)
	    end // case: int_wai_state
	  
	  int_mask_state:
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // Mask IRQ
               left_ctrl  = sp_left;
               right_ctrl = zero_right;
	       alu_ctrl   = alu_sei;
	       cc_ctrl    = load_cc;
               sp_ctrl    = latch_sp;
	       // idle bus cycle
               addr_ctrl  = idle_ad;
               dout_ctrl  = md_lo_dout;
               next_state = vect_hi_state;
	    end // case: int_mask_state
	  
	  halt_state: // halt CPU.
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // do nothing in ALU
               left_ctrl  = acca_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
	       // idle bus cycle
               addr_ctrl  = idle_ad;
               dout_ctrl  = md_lo_dout;
	       if (halt)
		 next_state = halt_state;
	       else
		 next_state = fetch_state;
	    end // case: halt_state

	  default: // error state halt on undefine states
	    begin
	       // default
               acca_ctrl  = latch_acca;
               accb_ctrl  = latch_accb;
               ix_ctrl    = latch_ix;
               sp_ctrl    = latch_sp;
               pc_ctrl    = latch_pc;
               md_ctrl    = latch_md;
               iv_ctrl    = latch_iv;
	       op_ctrl    = latch_op;
	       nmi_ctrl   = latch_nmi;
               ea_ctrl    = latch_ea;
	       // do nothing in ALU
               left_ctrl  = acca_left;
               right_ctrl = zero_right;
               alu_ctrl   = alu_nop;
               cc_ctrl    = latch_cc;
	       // idle bus cycle
               addr_ctrl  = idle_ad;
               dout_ctrl  = md_lo_dout;
	       next_state = error_state;
	    end
	endcase // case (state)
     end

   //--------------------------------
   //-- state machine
   //--------------------------------

   always @(negedge clk or posedge rst)
     if (rst)
       state <= reset_state;
     else
       if (hold)
	 state <= state;
       else
	 state <= next_state;
   
endmodule // cpu68

