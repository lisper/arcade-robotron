//===========================================================================//
//
// Synthesizble cpu68 core; ported to verilog 01/2013 
// Brad Parker <brad@heeltoe.com>
//
//===========================================================================--
//                                                                           --
//        Synthesizable 6809 instruction compatible VHDL CPU core            --
//                                                                           --
//===========================================================================--
//
// File name      : cpu09.vhd
//
// Entity name    : cpu09
//
// Purpose        : 6809 instruction compatible CPU core written in VHDL
//                  Not cycle compatible with the original 6809 CPU
//
// Dependencies   : ieee.std_logic_1164
//                  ieee.std_logic_unsigned
//
// Author         : John E. Kent
//
// Email          : dilbert57@opencores.org      
//
// Web            : http://opencores.org/project,system09
//
// 
//  Copyright (C) 2003 - 2010 John Kent
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//
//===========================================================================--
//                                                                           --
//                                Revision History                           --
//                                                                           --
//===========================================================================--
//
// Version 0.1 - 26 June 2003 - John Kent
// Added extra level in state stack
// fixed some calls to the extended addressing state
//
// Version 0.2 - 5 Sept 2003 - John Kent
// Fixed 16 bit indexed offset (was doing read rather than fetch)
// Added/Fixed STY and STS instructions.
// ORCC_STATE ANDed CC state rather than ORed it - Now fixed
// CMPX Loaded ACCA and ACCB - Now fixed 
//
// Version 1.0 - 6 Sep 2003 - John Kent 
// Initial release to Open Cores
// reversed clock edge
//
// Version 1.1 - 29 November 2003 John kent
//	ACCA and ACCB indexed offsets are 2's complement.
// ALU Right Mux now sign extends ACCA & ACCB offsets
// Absolute Indirect addressing performed a read on the
// second byte of the address rather than a fetch
// so it formed an incorrect address. Now fixed. 
//
// Version 1.2 - 29 November 2003 John Kent
// LEAX and LEAY affect the Z bit only
//	LEAS and LEAU do not affect any condition codes
// added an extra ALU control for LEA.
//
// Version 1.3 - 12 December 2003 John Kent
// CWAI did not work, was missed a PUSH_ST on calling
// the ANDCC_STATE. Thanks go to Ghassan Kraidy for
// finding this fault.
//
// Version 1.4 - 12 December 2003 John Kent
// Missing cc_ctrl assignment in otherwise case of 
// lea_state resulted in cc_ctrl being latched in
// that state.	
// The otherwise statement should never be reached,
// and has been fixed simply to resolve synthesis warnings.
//
// Version 1.5 - 17 january 2004 John kent
// The clear instruction used "alu_ld8" to control the ALU
// rather than "alu_clr". This mean the Carry was not being
// cleared correctly.
//
// Version 1.6 - 24 January 2004 John Kent
// Fixed problems in PSHU instruction
//
// Version 1.7 - 25 January 2004 John Kent
// removed redundant "alu_inx" and "alu_dex'
// Removed "test_alu" and "test_cc"
// STD instruction did not set condition codes
// JMP direct was not decoded properly
// CLR direct performed an unwanted read cycle
// Bogus "latch_md" in Page2 indexed addressing
//
// Version 1.8 - 27 January 2004 John Kent
// CWAI in decode1_state should increment the PC.
// ABX is supposed to be an unsigned addition.
// Added extra ALU function
// ASR8 slightly changed in the ALU.
//
//	Version 1.9 - 20 August 2005
// LSR8 is now handled in ASR8 and ROR8 case in the ALU,
// rather than LSR16. There was a problem with single 
// operand instructions using the MD register which is
// sign extended on the first 8 bit fetch.
//
// Version 1.10 - 13 September 2005
// TFR & EXG instructions did not work for the Condition Code Register
// An extra case has been added to the ALU for the alu_tfr control 
// to assign the left ALU input (alu_left) to the condition code
// outputs (cc_out). 
//
// Version 1.11 - 16 September 2005
// JSR ,X should not predecrement S before calculating the jump address.
// The reason is that JSR [0,S] needs S to point to the top of the stack
// to fetch a valid vector address. The solution is to have the addressing
// mode microcode called before decrementing S and then decrementing S in
// JSR_STATE. JSR_STATE in turn calls PUSH_RETURN_LO_STATE rather than
// PUSH_RETURN_HI_STATE so that both the High & Low halves of the PC are
// pushed on the stack. This adds one extra bus cycle, but resolves the
// addressing conflict. I've also removed the pre-decement S in 
// JSR EXTENDED as it also calls JSR_STATE.
//
// Version 1.12 - 6th June 2006
// 6809 Programming reference manual says V is not affected by ASR, LSR and ROR
// This is different to the 6800. CLR should reset the V bit.
//
// Version 1.13 - 7th July 2006
// Disable NMI on reset until S Stack pointer has been loaded.
// Added nmi_enable signal in sp_reg process and nmi_handler process.
//
// Version 1.14 - 11th July 2006
// 1. Added new state to RTI called rti_entire_state.
// This state tests the CC register after it has been loaded
// from the stack. Previously the current CC was tested which
// was incorrect. The Entire Flag should be set before the
// interrupt stacks the CC.
// 2. On bogus Interrupts, int_cc_state went to rti_state,
// which was an enumerated state, but not defined anywhere.
// rti_state has been changed to rti_cc_state so that bogus interrupt
// will perform an RTI after entering that state.
// 3. Sync should generate an interrupt if the interrupt masks
// are cleared. If the interrupt masks are set, then an interrupt
// will cause the the PC to advance to the next instruction.
// Note that I don't wait for an interrupt to be asserted for
// three clock cycles.
// 4. Added new ALU control state "alu_mul". "alu_mul" is used in
// the Multiply instruction replacing "alu_add16". This is similar 
// to "alu_add16" except it sets the Carry bit to B7 of the result
// in ACCB, sets the Zero bit if the 16 bit result is zero, but
// does not affect The Half carry (H), Negative (N) or Overflow (V)
// flags. The logic was re-arranged so that it adds md or zero so 
// that the Carry condition code is set on zero multiplicands.
// 5. DAA (Decimal Adjust Accumulator) should set the Negative (N)
// and Zero Flags. It will also affect the Overflow (V) flag although
// the operation is undefined. It's anyones guess what DAA does to V.
//
// Version 1.15 - 25th Feb 2007 - John Kent
// line 9672 changed "if Halt <= '1' then" to "if Halt = '1' then"
// Changed sensitivity lists.
//
// Version 1.16 - 5th February 2008 - John Kent
// FIRQ interrupts should take priority over IRQ Interrupts.
// This presumably means they should be tested for before IRQ
// when they happen concurrently.
//
// Version 1.17 - 18th February 2008 - John Kent
// NMI in CWAI should mask IRQ and FIRQ interrupts
//
// Version 1.18 - 21st February 2008 - John Kent
// Removed default register settings in each case statement
// and placed them at the beginning of the state sequencer.
// Modified the SYNC instruction so that the interrupt vector(iv)
// is not set unless an unmasked FIRQ or IRQ is received.
//
// Version 1.19 - 25th February 2008 - John Kent
// Enumerated separate states for FIRQ/FAST and NMIIRQ/ENTIRE
// Enumerated separate states for MASKI and MASKIF states
// Removed code on BSR/JSR in fetch cycle
//


module  cpu09 ( clk, rst, vma, addr, rw, data_out, data_in, irq, firq, nmi, halt, hold, ba_out, bs_out, halted );
   
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
   output 	 ba_out;
   output 	 bs_out;
   output 	 halted;
   
   reg [0:0] 	 alu__valid_lo;
   reg [0:0] 	 alu__valid_hi;
   reg 		 alu__carry_in;
   reg [7:0] 	 alu__daa_reg;

   parameter
     EBIT = 7,
     FBIT = 6,
     HBIT = 5,
     IBIT = 4,
     NBIT = 3,
     ZBIT = 2,
     VBIT = 1,
     CBIT = 0;
   
   //--
   //-- Interrupt vector modifiers
   //--
   parameter [2:0]
     RST_VEC  = 3'b111,
     NMI_VEC  = 3'b110,
     SWI_VEC  = 3'b101,
     IRQ_VEC  = 3'b100,
     FIRQ_VEC = 3'b011,
     SWI2_VEC = 3'b010,
     SWI3_VEC = 3'b001,
     RESV_VEC = 3'b000;

   // type state_type
   parameter
     reset_state = 8'd0,	// Start off in Reset
     // Fetch Interrupt Vectors (including reset)
     vect_lo_state = 8'd1,
     vect_hi_state = 8'd2,
     fetch_state = 8'd3,
     // Decode Instruction Cycles
     decode1_state = 8'd4,
     decode2_state = 8'd5,
     decode3_state = 8'd6,
     // Calculate Effective Address
     imm16_state = 8'd7,
     indexed_state = 8'd8,
     index8_state = 8'd9,
     index16_state = 8'd10,
     index16_2_state = 8'd11,
     pcrel8_state = 8'd12,
     pcrel16_state = 8'd13,
     pcrel16_2_state = 8'd14,
     indexaddr_state = 8'd15,
     indexaddr2_state = 8'd16,
     postincr1_state = 8'd17,
     postincr2_state = 8'd18,
     indirect_state = 8'd19,
     indirect2_state = 8'd20,
     indirect3_state = 8'd21,
     extended_state = 8'd22,
     // single ops
     single_op_read_state = 8'd23,
     single_op_exec_state = 8'd24,
     single_op_write_state = 8'd25,
     dual_op_read8_state = 8'd26,
     dual_op_read16_state = 8'd27,
     dual_op_read16_2_state = 8'd28,
     dual_op_write8_state = 8'd29,
     dual_op_write16_state = 8'd30,
     //
     sync_state = 8'd31,
     halt_state = 8'd32,
     error_state = 8'd33,
     //
     andcc_state = 8'd34,
     orcc_state = 8'd35,
     tfr_state = 8'd36,
     exg_state = 8'd37,
     exg1_state = 8'd38,
     lea_state = 8'd39,
     // Multiplication
     mul_state = 8'd40,
     mulea_state = 8'd41,
     muld_state = 8'd42,
     mul0_state = 8'd43,
     mul1_state = 8'd44,
     mul2_state = 8'd45,
     mul3_state = 8'd46,
     mul4_state = 8'd47,
     mul5_state = 8'd48,
     mul6_state = 8'd49,
     mul7_state = 8'd50,
     //  Branches
     lbranch_state = 8'd51,
     sbranch_state = 8'd52,
     // Jumps, Subroutine Calls and Returns
     jsr_state = 8'd53,
     jmp_state = 8'd54,
     push_return_hi_state = 8'd55,
     push_return_lo_state = 8'd56,
     pull_return_hi_state = 8'd57,
     pull_return_lo_state = 8'd58,
     // Interrupt cycles
     int_nmiirq_state = 8'd59,
     int_firq_state = 8'd60,
     int_entire_state = 8'd61,
     int_fast_state = 8'd62,
     int_pcl_state = 8'd63,
     int_pch_state = 8'd64,
     int_upl_state = 8'd65,
     int_uph_state = 8'd66,
     int_iyl_state = 8'd67,
     int_iyh_state = 8'd68,
     int_ixl_state = 8'd69,
     int_ixh_state = 8'd70,
     int_dp_state = 8'd71,
     int_accb_state = 8'd72,
     int_acca_state = 8'd73,
     int_cc_state = 8'd74,
     int_cwai_state = 8'd75,
     int_maski_state = 8'd76,
     int_maskif_state = 8'd77,
     // Return From Interrupt
     rti_cc_state = 8'd78,
     rti_entire_state = 8'd79,
     rti_acca_state = 8'd80,
     rti_accb_state = 8'd81,
     rti_dp_state = 8'd82,
     rti_ixl_state = 8'd83,
     rti_ixh_state = 8'd84,
     rti_iyl_state = 8'd85,
     rti_iyh_state = 8'd86,
     rti_upl_state = 8'd87,
     rti_uph_state = 8'd88,
     rti_pcl_state = 8'd89,
     rti_pch_state = 8'd90,
     // Push Registers using SP
     pshs_state = 8'd91,
     pshs_pcl_state = 8'd92,
     pshs_pch_state = 8'd93,
     pshs_upl_state = 8'd94,
     pshs_uph_state = 8'd95,
     pshs_iyl_state = 8'd96,
     pshs_iyh_state = 8'd97,
     pshs_ixl_state = 8'd98,
     pshs_ixh_state = 8'd99,
     pshs_dp_state = 8'd100,
     pshs_acca_state = 8'd101,
     pshs_accb_state = 8'd102,
     pshs_cc_state = 8'd103,
     // Pull Registers using SP
     puls_state = 8'd104,
     puls_cc_state = 8'd105,
     puls_acca_state = 8'd106,
     puls_accb_state = 8'd107,
     puls_dp_state = 8'd108,
     puls_ixl_state = 8'd109,
     puls_ixh_state = 8'd110,
     puls_iyl_state = 8'd111,
     puls_iyh_state = 8'd112,
     puls_upl_state = 8'd113,
     puls_uph_state = 8'd114,
     puls_pcl_state = 8'd115,
     puls_pch_state = 8'd116,
     // Push Registers using UP
     pshu_state = 8'd117,
     pshu_pcl_state = 8'd118,
     pshu_pch_state = 8'd119,
     pshu_spl_state = 8'd120,
     pshu_sph_state = 8'd121,
     pshu_iyl_state = 8'd122,
     pshu_iyh_state = 8'd123,
     pshu_ixl_state = 8'd124,
     pshu_ixh_state = 8'd125,
     pshu_dp_state = 8'd126,
     pshu_acca_state = 8'd127,
     pshu_accb_state = 8'd128,
     pshu_cc_state = 8'd129,
     // Pull Registers using UP
     pulu_state = 8'd130,
     pulu_cc_state = 8'd131,
     pulu_acca_state = 8'd132,
     pulu_accb_state = 8'd133,
     pulu_dp_state = 8'd134,
     pulu_ixl_state = 8'd135,
     pulu_ixh_state = 8'd136,
     pulu_iyl_state = 8'd137,
     pulu_iyh_state = 8'd138,
     pulu_spl_state = 8'd139,
     pulu_sph_state = 8'd140,
     pulu_pcl_state = 8'd141,
     pulu_pch_state = 8'd142;
   
   //type st_type
   parameter
     idle_st = 2'd0,
     push_st = 2'd1,
     pull_st = 2'd2;
   
   //type addr_type
   parameter
     idle_ad = 4'd0,
     fetch_ad = 4'd1,
     read_ad = 4'd2,
     write_ad = 4'd3,
     pushu_ad = 4'd4,
     pullu_ad = 4'd5,
     pushs_ad = 4'd6,
     pulls_ad = 4'd7,
     int_hi_ad = 4'd8,
     int_lo_ad = 4'd9;
   
   //type dout_type
   parameter
     cc_dout = 4'd0,
     acca_dout = 4'd1,
     accb_dout = 4'd2,
     dp_dout = 4'd3,
     ix_lo_dout = 4'd4,
     ix_hi_dout = 4'd5,
     iy_lo_dout = 4'd6,
     iy_hi_dout = 4'd7,
     up_lo_dout = 4'd8,
     up_hi_dout = 4'd9,
     sp_lo_dout = 4'd10,
     sp_hi_dout = 4'd11,
     pc_lo_dout = 4'd12,
     pc_hi_dout = 4'd13,
     md_lo_dout = 4'd14,
     md_hi_dout = 4'd15;
   
   //type op_type
   parameter
     reset_op = 2'd0,
     fetch_op = 2'd1,
     latch_op = 2'd2;
   
   //type pre_type
   parameter
     reset_pre = 2'd0,
     fetch_pre = 2'd1,
     latch_pre = 2'd2;
   
   //type cc_type
   parameter
     reset_cc = 2'd0,
     load_cc = 2'd1,
     pull_cc = 2'd2,
     latch_cc = 2'd3;
   
   //type acca_type
   parameter
     reset_acca = 3'd0,
     load_acca = 3'd1,
     load_hi_acca = 3'd2,
     pull_acca = 3'd3,
     latch_acca = 3'd4;
   
   //type accb_type
   parameter
     reset_accb = 2'd0,
     load_accb = 2'd1,
     pull_accb = 2'd2,
     latch_accb = 2'd3;
   
   //type dp_type
   parameter
     reset_dp = 2'd0,
     load_dp = 2'd1,
     pull_dp = 2'd2,
     latch_dp = 2'd3;
   
   //type ix_type
   parameter
     reset_ix = 3'd0,
     load_ix = 3'd1,
     pull_lo_ix = 3'd2,
     pull_hi_ix = 3'd3,
     latch_ix = 3'd4;
   
   //type iy_type
   parameter
     reset_iy = 3'd0,
     load_iy = 3'd1,
     pull_lo_iy = 3'd2,
     pull_hi_iy = 3'd3,
     latch_iy = 3'd4;
   
   //type sp_type
   parameter
     reset_sp = 3'd0,
     latch_sp = 3'd1,
     load_sp = 3'd2,
     pull_hi_sp = 3'd3,
     pull_lo_sp = 3'd4;
   
   //type up_type
   parameter
     reset_up = 3'd0,
     latch_up = 3'd1,
     load_up = 3'd2,
     pull_hi_up = 3'd3,
     pull_lo_up = 3'd4;
   
   //type pc_type
   parameter
     reset_pc = 3'd0,
     latch_pc = 3'd1,
     load_pc = 3'd2,
     pull_lo_pc = 3'd3,
     pull_hi_pc = 3'd4,
     incr_pc = 3'd5;
   
   //type md_type
   parameter
     reset_md = 3'd0,
     latch_md = 3'd1,
     load_md = 3'd2,
     fetch_first_md = 3'd3,
     fetch_next_md = 3'd4,
     shiftl_md = 3'd5;
   
   //type ea_type
   parameter
     reset_ea = 3'd0,
     latch_ea = 3'd1,
     load_ea = 3'd2,
     fetch_first_ea = 3'd3,
     fetch_next_ea = 3'd4;
   
   //type iv_type
   parameter
     latch_iv = 4'd0,
     reset_iv = 4'd1,
     nmi_iv = 4'd2,
     irq_iv = 4'd3,
     firq_iv = 4'd4,
     swi_iv = 4'd5,
     swi2_iv = 4'd6,
     swi3_iv = 4'd7,
     resv_iv = 4'd8;
   
   //type nmi_type
   parameter
     reset_nmi = 2'd0,
     set_nmi = 2'd1,
     latch_nmi = 2'd2;
   
   //type left_type
   parameter
     cc_left = 4'd0,
     acca_left = 4'd1,
     accb_left = 4'd2,
     dp_left = 4'd3,
     ix_left = 4'd4,
     iy_left = 4'd5,
     up_left = 4'd6,
     sp_left = 4'd7,
     accd_left = 4'd8,
     md_left = 4'd9,
     pc_left = 4'd10,
     ea_left = 4'd11;
   
   //type right_type
   parameter
     ea_right = 4'd0,
     zero_right = 4'd1,
     one_right = 4'd2,
     two_right = 4'd3,
     acca_right = 4'd4,
     accb_right = 4'd5,
     accd_right = 4'd6,
     md_right = 4'd7,
     md_sign5_right = 4'd8,
     md_sign8_right = 4'd9;
   
   //type alu_type
   parameter
     alu_add8 = 6'd0,
     alu_sub8 = 6'd1,
     alu_add16 = 6'd2,
     alu_sub16 = 6'd3,
     alu_adc = 6'd4,
     alu_sbc = 6'd5,
     alu_and = 6'd6,
     alu_ora = 6'd7,
     alu_eor = 6'd8,
     alu_tst = 6'd9,
     alu_inc = 6'd10,
     alu_dec = 6'd11,
     alu_clr = 6'd12,
     alu_neg = 6'd13,
     alu_com = 6'd14,
     alu_lsr16 = 6'd15,
     alu_lsl16 = 6'd16,
     alu_ror8 = 6'd17,
     alu_rol8 = 6'd18,
     alu_mul = 6'd19,
     alu_asr8 = 6'd20,
     alu_asl8 = 6'd21,
     alu_lsr8 = 6'd22,
     alu_andcc = 6'd23,
     alu_orcc = 6'd24,
     alu_sex = 6'd25,
     alu_tfr = 6'd26,
     alu_abx = 6'd27,
     alu_seif = 6'd28,
     alu_sei = 6'd29,
     alu_see = 6'd30,
     alu_cle = 6'd31,
     alu_ld8 = 6'd32,
     alu_st8 = 6'd33,
     alu_ld16 = 6'd34,
     alu_st16 = 6'd35,
     alu_lea = 6'd36,
     alu_nop = 6'd37,
     alu_daa = 6'd38;
   
   reg [7:0] 	 op_code;
   reg [7:0] 	 pre_code;
   reg [7:0] 	 acca;
   reg [7:0] 	 accb;
   reg [7:0] 	 cc;
   reg [7:0] 	 cc_out;
   reg [7:0] 	 dp;
   reg [15:0] 	 xreg;
   reg [15:0] 	 yreg;
   reg [15:0] 	 sp;
   reg [15:0] 	 up;
   reg [15:0] 	 ea;
   reg [15:0] 	 pc;
   reg [15:0] 	 md;
   reg [15:0] 	 left;
   reg [15:0] 	 right;
   reg [15:0] 	 out_alu;
   reg [2:0] 	 iv;
   reg 		 nmi_req;
   reg 		 nmi_ack;
   reg 		 nmi_enable;
   reg [7:0] 	 state;
   reg [7:0] 	 next_state;
   wire [7:0] 	 saved_state;
   reg [7:0] 	 return_state;
   reg [7:0] 	 state_stack[2:0];
   reg [1:0] 	 st_ctrl;
   reg [2:0] 	 pc_ctrl;
   reg [2:0] 	 ea_ctrl;
   reg [1:0] 	 op_ctrl;
   reg [1:0] 	 pre_ctrl;
   reg [2:0] 	 md_ctrl;
   reg [2:0] 	 acca_ctrl;
   reg [1:0] 	 accb_ctrl;
   reg [2:0] 	 ix_ctrl;
   reg [2:0] 	 iy_ctrl;
   reg [1:0] 	 cc_ctrl;
   reg [1:0] 	 dp_ctrl;
   reg [2:0] 	 sp_ctrl;
   reg [2:0] 	 up_ctrl;
   reg [3:0] 	 iv_ctrl;
   reg [3:0] 	 left_ctrl;
   reg [3:0] 	 right_ctrl;
   reg [5:0] 	 alu_ctrl;
   reg [3:0] 	 addr_ctrl;
   reg [3:0] 	 dout_ctrl;
   reg [1:0] 	 nmi_ctrl;
   reg 		 vma;
   reg [15:0] 	 addr;
   reg 		 rw;
   reg [7:0] 	 data_out;
   reg 		 ba;
   reg 		 bs;

   //----------------------------------
   //-- State machine stack
   //----------------------------------
   always @(negedge clk)
     if (hold)
       begin 
          state_stack[0] <= state_stack[0];
          state_stack[1] <= state_stack[1];
          state_stack[2] <= state_stack[2];
       end
     else
       begin
          case (st_ctrl)
            idle_st:
              begin 
                 state_stack[0] <= state_stack[0];
                 state_stack[1] <= state_stack[1];
                 state_stack[2] <= state_stack[2];
              end
            push_st:
              begin 
                 state_stack[0] <= return_state;
                 state_stack[1] <= state_stack[0];
                 state_stack[2] <= state_stack[1];
              end
            pull_st:
              begin 
                 state_stack[0] <= state_stack[1];
                 state_stack[1] <= state_stack[2];
                 state_stack[2] <= fetch_state;
              end
            default:
              begin 
                 state_stack[0] <= state_stack[0];
                 state_stack[1] <= state_stack[1];
		 state_stack[2] <= state_stack[2];
              end
          endcase
       end
   
   assign saved_state = state_stack[0];
   
   //------------------------------------
   //-- Program Counter Control
   //------------------------------------
   always @(negedge clk)
     if (hold) 
       pc <= pc;
     else 
       case (pc_ctrl)
         reset_pc:
           pc <= 16'b0000000000000000;
         load_pc:
           pc <= out_alu[15:0];
         pull_lo_pc:
           pc[7:0] <= data_in;
         pull_hi_pc:
           pc[15:8] <= data_in;
         incr_pc:
           pc <= pc + 1;
	 //latch_pc,
         default:
           pc <= pc;
       endcase
   
   //------------------------------------
   //-- Effective Address  Control
   //------------------------------------
   always @(negedge clk)
     if (hold) 
       ea <= ea;
     else 
       case (ea_ctrl)
         reset_ea:
           ea <= 16'b0000000000000000;
         fetch_first_ea:
           begin 
              ea[7:0] <= data_in;
              ea[15:8] <= dp;
           end
         fetch_next_ea:
           begin 
              ea[15:8] <= ea[7:0];
              ea[7:0] <= data_in;
           end
         load_ea:
           ea <= out_alu[15:0];
	 //latch_ea,
         default:
           ea <= ea;
       endcase
   
   //--------------------------------
   //-- Accumulator A
   //--------------------------------
   always @(negedge clk)
     if (hold) 
       acca <= acca;
     else 
       case (acca_ctrl)
         reset_acca:
           acca <= 8'b00000000;
         load_acca:
           acca <= out_alu[7:0];
         load_hi_acca:
           acca <= out_alu[15:8];
         pull_acca:
           acca <= data_in;
	 //latch_acca,
         default:
           acca <= acca;
       endcase
   
   //--------------------------------
   //-- Accumulator B
   //--------------------------------
   always @(negedge clk)
     if (hold) 
       accb <= accb;
     else 
       case (accb_ctrl)
         reset_accb:
           accb <= 8'b00000000;
         load_accb:
           accb <= out_alu[7:0];
         pull_accb:
           accb <= data_in;
	 //latch_accb,
         default:
           accb <= accb;
       endcase
   
   //--------------------------------
   //-- X Index register
   //--------------------------------
   always @(negedge clk) 
     if (hold) 
       xreg <= xreg;
     else 
       case (ix_ctrl)
         reset_ix:
           xreg <= 16'b0000000000000000;
         load_ix:
           xreg <= out_alu[15:0];
         pull_hi_ix:
           xreg[15:8] <= data_in;
         pull_lo_ix:
           xreg[7:0] <= data_in;
	 //latch_ix,
         default:
           xreg <= xreg;
       endcase
   
   //--------------------------------
   //-- Y Index register
   //--------------------------------
   always @(negedge clk) 
     if (hold) 
       yreg <= yreg;
     else 
       case (iy_ctrl)
         reset_iy:
           yreg <= 16'b0000000000000000;
         load_iy:
           yreg <= out_alu[15:0];
         pull_hi_iy:
           yreg[15:8] <= data_in;
         pull_lo_iy:
           yreg[7:0] <= data_in;
	 //latch_iy,
         default:
           yreg <= yreg;
       endcase
   
   //--------------------------------
   //-- S stack pointer
   //--------------------------------
   always @(negedge clk) 
     if (hold) 
       begin 
          sp <= sp;
          nmi_enable <= nmi_enable;
       end
     else 
       case (sp_ctrl)
         reset_sp:
           begin 
              sp <= 16'b0000000000000000;
              nmi_enable <= 1'b0;
           end
         load_sp:
           begin 
              sp <= out_alu[15:0];
              nmi_enable <= 1'b1;
           end
         pull_hi_sp:
           begin 
              sp[15:8] <= data_in;
              nmi_enable <= nmi_enable;
           end
         pull_lo_sp:
           begin 
              sp[7:0] <= data_in;
              nmi_enable <= 1'b1;
           end
	 //latch_sp,
         default:
           begin 
              sp <= sp;
              nmi_enable <= nmi_enable;
           end
       endcase
   
   //--------------------------------
   //-- U stack pointer
   //--------------------------------
   always @(negedge clk) 
     if (hold) 
       up <= up;
     else 
       case (up_ctrl)
         reset_up:
           up <= 16'b0000000000000000;
         load_up:
           up <= out_alu[15:0];
         pull_hi_up:
           up[15:8] <= data_in;
         pull_lo_up:
           up[7:0] <= data_in;
	 //latch_up,
         default:
           up <= up;
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
              md[15:8] <= { data_in[7], data_in[7], data_in[7], data_in[7],
			    data_in[7], data_in[7], data_in[7], data_in[7] };
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
         default:
           md <= md;
       endcase
   
   //----------------------------------
   //-- Condition Codes
   //----------------------------------
   
   always @(negedge clk) 
     if (hold) 
       cc <= cc;
     else 
       case (cc_ctrl)
         reset_cc:
           cc <= 8'b11010000; // set EBIT, FBIT & IBIT
         load_cc:
           cc <= cc_out;
         pull_cc:
           cc <= data_in;
	 //latch_cc,
         default:
           cc <= cc;
       endcase
   
   //----------------------------------
   //-- Direct Page register
   //----------------------------------
   
   always @(negedge clk) 
     if (hold) 
       dp <= dp;
     else 
       case (dp_ctrl)
         reset_dp:
           dp <= 8'b00000000;
         load_dp:
           dp <= out_alu[7:0];
         pull_dp:
           dp <= data_in;
	 //latch_dp,
         default:
           dp <= dp;
       endcase
   
   //----------------------------------
   //-- interrupt vector
   //----------------------------------
   
   always @(negedge clk) 
     if (hold) 
       iv <= iv;
     else 
       case (iv_ctrl)
         reset_iv:
           iv <= 3'b111;
         nmi_iv:
           iv <= 3'b110;
         swi_iv:
           iv <= 3'b101;
         irq_iv:
           iv <= 3'b100;
         firq_iv:
           iv <= 3'b011;
         swi2_iv:
           iv <= 3'b010;
         swi3_iv:
           iv <= 3'b001;
         resv_iv:
           iv <= 3'b000;
         default:
           iv <= iv;
       endcase
   
   //----------------------------------
   //-- op code register
   //----------------------------------
   
   always @(negedge clk) 
     if (hold) 
       op_code <= op_code;
     else 
       case (op_ctrl)
         reset_op:
           op_code <= 8'b00010010;
         fetch_op:
	   // fetching opcodes while entering halt state causes register corruption
           if (state != halt_state && next_state != halt_state)
             op_code <= data_in;
	 //latch_op,
         default:
           op_code <= op_code;
       endcase
   
   //----------------------------------
   //-- pre byte op code register
   //----------------------------------
   
   always @(negedge clk) 
     if (hold) 
       pre_code <= pre_code;
     else 
       case (pre_ctrl)
         reset_pre:
           pre_code <= 8'b00000000;
         fetch_pre:
           pre_code <= data_in;
         default:
           pre_code <= pre_code;
       endcase
   
   //--------------------------------
   //-- state machine
   //--------------------------------
   
   always @(negedge clk or posedge rst) 
     if (rst)
       state <= reset_state;
     else 
       begin 
          if (hold) 
            state <= state;
          else 
            state <= next_state;
       end 
   
   //------------------------------------
   //-- Nmi register
   //------------------------------------
   
   always @(negedge clk) 
     if (hold) 
       nmi_ack <= nmi_ack;
     else 
       case (nmi_ctrl)
         set_nmi:
           nmi_ack <= 1'b1;
         reset_nmi:
           nmi_ack <= 1'b0;
	 //latch_nmi,
         default:
           nmi_ack <= nmi_ack;
       endcase
   
   //------------------------------------
   //-- Detect Edge of NMI interrupt
   //------------------------------------
   
   always @(negedge clk or posedge rst) 
     if (rst)
       nmi_req <= 1'b0;
     else 
       if (nmi && nmi_ack == 1'b0 && nmi_enable)
         nmi_req <= 1'b1;
       else 
         if (nmi == 1'b0 && nmi_ack)
           nmi_req <= 1'b0;
   
   //----------------------------------
   //-- Address output multiplexer
   //----------------------------------
   
   always @(addr_ctrl or pc or ea or up or sp or iv)
     case (addr_ctrl)
       idle_ad:
         begin 
            vma  = 1'b0;
            addr = 16'b1111111111111111;
            rw   = 1'b1;
         end
       fetch_ad:
         begin 
            vma  = 1'b1;
            addr = pc;
            rw   = 1'b1;
         end
       read_ad:
         begin 
            vma  = 1'b1;
            addr = ea;
            rw   = 1'b1;
         end
       write_ad:
         begin 
            vma  = 1'b1;
            addr = ea;
            rw   = 1'b0;
         end
       pushs_ad:
         begin 
            vma  = 1'b1;
            addr = sp;
            rw   = 1'b0;
         end
       pulls_ad:
         begin 
            vma  = 1'b1;
            addr = sp;
            rw   = 1'b1;
         end
       pushu_ad:
         begin 
            vma  = 1'b1;
            addr = up;
            rw   = 1'b0;
         end
       pullu_ad:
         begin 
            vma  = 1'b1;
            addr = up;
            rw   = 1'b1;
         end
       int_hi_ad:
         begin 
            vma  = 1'b1;
            addr = { 12'b111111111111, iv, 1'b0 };
            rw   = 1'b1;
         end
       int_lo_ad:
         begin 
            vma  = 1'b1;
            addr = { 12'b111111111111, iv, 1'b1 };
            rw   = 1'b1;
         end
       default:
         begin 
            vma  = 1'b0;
            addr = 16'b1111111111111111;
            rw   = 1'b1;
         end
     endcase
   
   //--------------------------------
   //-- Data Bus output
   //--------------------------------
   always @(dout_ctrl or md or acca or accb or dp or xreg or yreg or sp or up or pc or cc)
     case (dout_ctrl)
       cc_dout:		// condition code register
         data_out = cc;
       acca_dout:	// accumulator a
         data_out = acca;
       accb_dout:	// accumulator b
         data_out = accb;
       dp_dout:		// direct page register
         data_out = dp;
       ix_lo_dout:	// X index reg
         data_out = xreg[7:0];
       ix_hi_dout:	// X index reg
         data_out = xreg[15:8];
       iy_lo_dout:	// Y index reg
         data_out = yreg[7:0];
       iy_hi_dout:	// Y index reg
         data_out = yreg[15:8];
       up_lo_dout:	// U stack pointer
         data_out = up[7:0];
       up_hi_dout:	// U stack pointer
         data_out = up[15:8];
       sp_lo_dout:	// S stack pointer
         data_out = sp[7:0];
       sp_hi_dout:	// S stack pointer
         data_out = sp[15:8];
       md_lo_dout:	// alu output
         data_out = md[7:0];
       md_hi_dout:	// alu output
         data_out = md[15:8];
       pc_lo_dout:	// low order pc
         data_out = pc[7:0];
       pc_hi_dout:	// high order pc
         data_out = pc[15:8];
       default:
         data_out = 8'b00000000;
     endcase
   
   //----------------------------------
   //-- Left Mux
   //----------------------------------
   
   always @(left_ctrl or acca or accb or cc or dp or xreg or yreg or up or sp or pc or ea or md)
     case (left_ctrl)
       cc_left:
         begin 
            left[15:8] = 8'b00000000;
            left[7:0] = cc;
         end
       acca_left:
         begin 
            left[15:8] = 8'b00000000;
            left[7:0] = acca;
         end
       accb_left:
         begin 
            left[15:8] = 8'b00000000;
            left[7:0] = accb;
         end
       dp_left:
         begin 
            left[15:8] = 8'b00000000;
            left[7:0] = dp;
         end
       accd_left:
         begin 
            left[15:8] = acca;
            left[7:0] = accb;
         end
       md_left:
         left = md;
       ix_left:
         left = xreg;
       iy_left:
         left = yreg;
       sp_left:
         left = sp;
       up_left:
         left = up;
       pc_left:
         left = pc;
       //ea_left,
       default:
         left = ea;
     endcase
   
   //----------------------------------
   //-- Right Mux
   //----------------------------------
   
   always @(right_ctrl or md or acca or accb or ea)
     case (right_ctrl)
       ea_right:
         right = ea;
       zero_right:
         right = 16'b0000000000000000;
       one_right:
         right = 16'b0000000000000001;
       two_right:
         right = 16'b0000000000000010;
       acca_right:
         if (acca[7] == 1'b0)
           right = { 8'b00000000, acca[7:0] };
         else 
           right = { 8'b11111111, acca[7:0] };

       accb_right:
         if (accb[7] == 1'b0) 
           right = { 8'b00000000, accb[7:0] };
         else 
           right = { 8'b11111111, accb[7:0] };

       accd_right:
         right = { acca, accb };
       md_sign5_right:
         if (md[4] == 1'b0) 
           right = { 11'b00000000000, md[4:0] };
         else 
           right = { 11'b11111111111, md[4:0] };
       
       md_sign8_right:
         if (md[7] == 1'b0) 
           right = { 8'b00000000, md[7:0] };
         else 
           right = { 8'b11111111, md[7:0] };

       //md_right,
       default:
         right = md;
     endcase
   
   //----------------------------------
   //-- Arithmetic Logic Unit
   //----------------------------------
   
   always @(alu_ctrl or cc or left or right or out_alu or cc_out)
     begin 
        case (alu_ctrl)
          alu_adc, alu_sbc, alu_rol8, alu_ror8:
            alu__carry_in = cc[CBIT];
          alu_asr8:
            alu__carry_in = left[7];
          default:
            alu__carry_in = 1'b0;
        endcase

        alu__valid_lo = (left[3:0] <= 9);
        alu__valid_hi = (left[7:4] <= 9);

        if (cc[CBIT] == 1'b0) 
          if (cc[HBIT])
            begin 
               if (alu__valid_hi) 
                 alu__daa_reg = 8'b00000110;
               else 
                 alu__daa_reg = 8'b01100110;
            end 
          else 
            begin 
               if (alu__valid_lo) 
                 begin 
                    if (alu__valid_hi) 
                      alu__daa_reg = 8'b00000000;
                    else 
                      alu__daa_reg = 8'b01100000;
                 end 
               else 
                 begin 
                    if (left[7:4] <= 8) 
                      alu__daa_reg = 8'b00000110;
                    else 
                      alu__daa_reg = 8'b01100110;
                 end 
            end 
        else 
          if (cc[HBIT])
            alu__daa_reg = 8'b01100110;
          else 
            begin 
               if (alu__valid_lo) 
                 alu__daa_reg = 8'b01100000;
               else 
                 alu__daa_reg = 8'b01100110;
            end 
        
        case (alu_ctrl)
          alu_add8, alu_inc, alu_add16, alu_adc, alu_mul:
            out_alu = ((left + right) + { 15'b000000000000000, alu__carry_in });
          alu_sub8,alu_dec,alu_sub16,alu_sbc:
            out_alu = ((left - right) - { 15'b000000000000000, alu__carry_in });
          alu_abx:
            out_alu = (left + {8'b00000000,right[7:0]});
          alu_and:	
            out_alu = (left & right);			// and/bit
          alu_ora:	
            out_alu = (left | right);			// or
          alu_eor:
            out_alu = (left ^ right);			// eor/xor
          alu_lsl16, alu_asl8, alu_rol8:
            out_alu = { left[14:0], alu__carry_in };	// rol8/asl8/lsl16
          alu_lsr16:
            out_alu = { alu__carry_in, left[15:1] };	// lsr16
          alu_lsr8, alu_asr8, alu_ror8:
            out_alu = {8'b00000000, alu__carry_in, left[7:1] };	// ror8/asr8/lsr8
          alu_neg:
            out_alu = right - left;			// neg (right=0)
          alu_com:
            out_alu = ~ (left);
          alu_clr,alu_ld8,alu_ld16,alu_lea:
            out_alu = right;				// clr, ld
          alu_st8,alu_st16,alu_andcc,alu_orcc,alu_tfr:
            out_alu = left;
          alu_daa:
            out_alu = left + { 8'b00000000, alu__daa_reg };
          alu_sex:
            if (left[7] == 1'b0)
              out_alu = { 8'b00000000, left[7:0] };
            else 
              out_alu = { 8'b11111111, left[7:0] };
          default:
            out_alu = left;				// nop
        endcase

	//--
	//-- carry bit
	//--
        case (alu_ctrl)
          alu_add8, alu_adc:
            cc_out[CBIT] = ((left[7] & right[7]) | (left[7] & ~(out_alu[7]))) | (right[7] & ~(out_alu[7]));
          alu_sub8,alu_sbc:
            cc_out[CBIT] = ((~(left[7]) & right[7]) | (~(left[7]) & out_alu[7])) | (right[7] & out_alu[7]);
          alu_add16:
            cc_out[CBIT] = ((left[15] & right[15]) | (left[15] & ~(out_alu[15]))) | (right[15] & ~(out_alu[15]));
          alu_sub16:
            cc_out[CBIT] = ((~(left[15]) & right[15]) | (~(left[15]) & out_alu[15])) | (right[15] & out_alu[15]);
          alu_ror8, alu_lsr16, alu_lsr8, alu_asr8:
            cc_out[CBIT] = left[0];
          alu_rol8,alu_asl8:
            cc_out[CBIT] = left[7];
          alu_lsl16:
            cc_out[CBIT] = left[15];
          alu_com:
            cc_out[CBIT] = 1'b1;
          alu_neg,alu_clr:
            cc_out[CBIT] = out_alu[7] | out_alu[6] | out_alu[5] | out_alu[4] |
			   out_alu[3] | out_alu[2] | out_alu[1] | out_alu[0];
          alu_mul:
            cc_out[CBIT] = out_alu[7];
          alu_daa:
            if (alu__daa_reg[7:4] == 4'b0110)
              cc_out[CBIT] = 1'b1;
            else 
              cc_out[CBIT] = 1'b0;

          alu_andcc:
            cc_out[CBIT] = left[CBIT] & cc[CBIT];
          alu_orcc:
            cc_out[CBIT] = left[CBIT] | cc[CBIT];
          alu_tfr:
            cc_out[CBIT] = left[CBIT];
          default:
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
	  alu_ld8, alu_st8, alu_sex, alu_daa:
            cc_out[ZBIT] = ~(out_alu[7] | out_alu[6] | out_alu[5] | out_alu[4] |
			     out_alu[3] | out_alu[2] | out_alu[1] | out_alu[0]);

          alu_add16, alu_sub16, alu_mul,
	    alu_lsl16,alu_lsr16,
	    alu_ld16,alu_st16,alu_lea:
              cc_out[ZBIT] = ~(out_alu[15] | out_alu[14] | out_alu[13] | out_alu[12] |
			       out_alu[11] | out_alu[10] | out_alu[9] | out_alu[8] | 
			       out_alu[7] | out_alu[6] | out_alu[5] | out_alu[4] |
			       out_alu[3] | out_alu[2] | out_alu[1] | out_alu[0]);
	  
          alu_andcc:
            cc_out[ZBIT] = left[ZBIT] & cc[ZBIT];
          alu_orcc:
            cc_out[ZBIT] = left[ZBIT] | cc[ZBIT];
          alu_tfr:
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
	  alu_ld8, alu_st8, alu_sex, alu_daa:
            cc_out[NBIT] = out_alu[7];
          alu_add16, alu_sub16,
	    alu_lsl16, alu_lsr16,
	    alu_ld16, alu_st16:
              cc_out[NBIT] = out_alu[15];
          alu_andcc:
            cc_out[NBIT] = (left[NBIT] & cc[NBIT]);
          alu_orcc:
            cc_out[NBIT] = (left[NBIT] | cc[NBIT]);
          alu_tfr:
            cc_out[NBIT] = left[NBIT];
          default:
            cc_out[NBIT] = cc[NBIT];
        endcase

	//--
	//-- Interrupt mask flag
	//--
        case (alu_ctrl)
          alu_andcc:
            cc_out[IBIT] = left[IBIT] & cc[IBIT];
          alu_orcc:
            cc_out[IBIT] = left[IBIT] | cc[IBIT];
          alu_tfr:
            cc_out[IBIT] = left[IBIT];
          alu_seif, alu_sei:
            cc_out[IBIT] = 1'b1;
          default:
            cc_out[IBIT] = cc[IBIT];
        endcase

	//--
	//-- Half Carry flag
	//--
        case (alu_ctrl)
          alu_add8, alu_adc:
            cc_out[HBIT] = (left[3] & right[3]) |
			   (right[3] & ~out_alu[3]) |
			   (left[3] & ~out_alu[3]);
          alu_andcc:
            cc_out[HBIT] = left[HBIT] & cc[HBIT];
          alu_orcc:
            cc_out[HBIT] = left[HBIT] | cc[HBIT];
          alu_tfr:
            cc_out[HBIT] = left[HBIT];
          default:
            cc_out[HBIT] = cc[HBIT];
        endcase

	//--
	//-- Overflow flag
	//--
        case (alu_ctrl)
          alu_add8, alu_adc:
            cc_out[VBIT] = (left[7] &    right[7] & ~out_alu[7]) |
			    ((~left[7] & ~right[7]) & out_alu[7]);
          alu_sub8, alu_sbc:
            cc_out[VBIT] = (((left[7] & ~(right[7])) & ~(out_alu[7])) |
			     ((~(left[7]) & right[7]) & out_alu[7]));
          alu_add16:
            cc_out[VBIT] = (((left[15] & right[15]) & ~(out_alu[15])) |
			     ((~(left[15]) & ~(right[15])) & out_alu[15]));
          alu_sub16:
            cc_out[VBIT] = (((left[15] & ~(right[15])) & ~(out_alu[15])) |
			     ((~(left[15]) & right[15]) & out_alu[15]));
          alu_inc:
            cc_out[VBIT] = ((~(left[7]) & left[6] & left[5] & left[4] &
			      left[3]) & left[2] & left[1] & left[0]);
          alu_dec, alu_neg:
            cc_out[VBIT] = (left[7] & ~left[6] & ~left[5] & ~left[4] &
			     ~left[3] & ~left[2] & ~left[1] & ~left[0]);
	  //-- 6809 Programming reference manual says
	  //-- V not affected by ASR, LSR and ROR
	  //-- This is different to the 6800
	  //-- John Kent 6th June 2006
	  //--	 when alu_asr8 =>
	  //--	   cc_out(VBIT) = left(0) xor left(7);
	  //--	 when alu_lsr8 | alu_lsr16 =>
	  //--	   cc_out(VBIT) = left(0);
	  //--	 when alu_ror8 =>
	  //--      cc_out(VBIT) = left(0) xor cc(CBIT);
          alu_lsl16:
            cc_out[VBIT] = left[15] ^ left[14];
          alu_rol8,alu_asl8:
            cc_out[VBIT] = left[7] ^ left[6];
          alu_daa:
            cc_out[VBIT] = left[7] ^ out_alu[7] ^ cc[CBIT];
          alu_and, alu_ora, alu_eor, alu_com, alu_clr,
	    alu_st8, alu_st16, alu_ld8, alu_ld16, alu_sex:
              cc_out[VBIT] = 1'b0;
          alu_andcc:
            cc_out[VBIT] = left[VBIT] & cc[VBIT];
          alu_orcc:
            cc_out[VBIT] = left[VBIT] | cc[VBIT];
          alu_tfr:
            cc_out[VBIT] = left[VBIT];
          default:
            cc_out[VBIT] = cc[VBIT];
        endcase

        case (alu_ctrl)
          alu_andcc:
            cc_out[FBIT] = left[FBIT] & cc[FBIT];
          alu_orcc:
            cc_out[FBIT] = left[FBIT] | cc[FBIT];
          alu_tfr:
            cc_out[FBIT] = left[FBIT];
          alu_seif:
            cc_out[FBIT] = 1'b1;
          default:
            cc_out[FBIT] = cc[FBIT];
        endcase

        case (alu_ctrl)
          alu_andcc:
            cc_out[EBIT] = left[EBIT] & cc[EBIT];
          alu_orcc:
            cc_out[EBIT] = left[EBIT] | cc[EBIT];
          alu_tfr:
            cc_out[EBIT] = left[EBIT];
          alu_see:
            cc_out[EBIT] = 1'b1;
          alu_cle:
            cc_out[EBIT] = 1'b0;
          default:
            cc_out[EBIT] = cc[EBIT];
        endcase
     end 
   
   //------------------------------------
   //-- state sequencer
   //------------------------------------
   reg cond_true;	// variable used to evaluate coditional branches

   always @(state or saved_state or
	    op_code or pre_code or
	    cc or ea or md or iv or
	    irq or firq or nmi_req or nmi_ack or halt)
     begin 
	//-- Registers preserved
        cc_ctrl = latch_cc;
        acca_ctrl = latch_acca;
        accb_ctrl = latch_accb;
        dp_ctrl = latch_dp;
        ix_ctrl = latch_ix;
        iy_ctrl = latch_iy;
        up_ctrl = latch_up;
        sp_ctrl = latch_sp;
        pc_ctrl = latch_pc;
        md_ctrl = latch_md;
        ea_ctrl = latch_ea;
        iv_ctrl = latch_iv;
        op_ctrl = latch_op;
        pre_ctrl = latch_pre;
        nmi_ctrl = latch_nmi;
	//-- ALU Idle
        left_ctrl = pc_left;
        right_ctrl = zero_right;
        alu_ctrl = alu_nop;
	//-- Bus idle
        addr_ctrl = idle_ad;
        dout_ctrl = cc_dout;
	//-- Next State Fetch
        st_ctrl = idle_st;
        return_state = fetch_state;
        next_state = fetch_state;

        case (state)
          reset_state:        //--  released from reset
            begin 
	       //-- reset the registers
               op_ctrl = reset_op;
               pre_ctrl = reset_pre;
               cc_ctrl = reset_cc;
               acca_ctrl = reset_acca;
               accb_ctrl = reset_accb;
               dp_ctrl = reset_dp;
               ix_ctrl = reset_ix;
               iy_ctrl = reset_iy;
               up_ctrl = reset_up;
               sp_ctrl = reset_sp;
               pc_ctrl = reset_pc;
               ea_ctrl = reset_ea;
               md_ctrl = reset_md;
               iv_ctrl = reset_iv;
               nmi_ctrl = reset_nmi;
               next_state = vect_hi_state;
            end

	  //--
	  //-- Jump via interrupt vector
	  //-- iv holds interrupt type
	  //-- fetch PC hi from vector location
	  //--
          vect_hi_state:
            begin 
	       //-- fetch pc low interrupt vector
               pc_ctrl = pull_hi_pc;
               addr_ctrl = int_hi_ad;
               next_state = vect_lo_state;
            end
	  //--
	  //-- jump via interrupt vector
	  //-- iv holds vector type
	  //-- fetch PC lo from vector location
	  //--
          vect_lo_state:
            begin 
               //-- fetch the vector low byte
               pc_ctrl = pull_lo_pc;
               addr_ctrl = int_lo_ad;
               next_state = fetch_state;
            end
	  //--
	  //-- Here to fetch an instruction
	  //-- PC points to opcode
	  //-- Should service interrupt requests at this point
	  //-- either from the timer
	  //-- or from the external input.
	  //--
          fetch_state:
            begin 
               //-- fetch the op code
               op_ctrl = fetch_op;
               pre_ctrl = fetch_pre;
               ea_ctrl = reset_ea;
               //-- Fetch op code
               addr_ctrl = fetch_ad;
	       //--
               case (op_code[7:6])
                 2'b10:	// acca
                   case (op_code[3:0])
                     4'b0000:	// suba
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sub8;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b0001: // cmpa
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sub8;
                          cc_ctrl = load_cc;
                       end
                     4'b0010: // sbca
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sbc;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b0011:
                       case (pre_code)
                         8'b00010000: // page 2 -- cmpd
                           begin 
                              left_ctrl = accd_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                           end
                         8'b00010001: // page 3 -- cmpu
                           begin 
                              left_ctrl = up_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                           end
                         default: // -age 1 -- subd
                           begin 
                              left_ctrl = accd_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                              acca_ctrl = load_hi_acca;
                              accb_ctrl = load_accb;
                           end
                       endcase
                     4'b0100: // anda
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_and;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b0101: // bita
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_and;
                          cc_ctrl = load_cc;
                       end
                     4'b0110: // ldaa
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_ld8;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b0111: // staa
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_st8;
                          cc_ctrl = load_cc;
                       end
                     4'b1000: // eora
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_eor;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b1001: // adca
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_adc;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b1010: // oraa
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_ora;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b1011: // adda
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_add8;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                       end
                     4'b1100:
                       case (pre_code)
                         8'b00010000: // page 2 -- cmpy
                           begin 
                              left_ctrl = iy_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                           end
                         8'b00010001: // page 3 - cmps
                           begin 
                              left_ctrl = sp_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                           end
                         default: // page 1 - cmpx
                           begin 
                              left_ctrl = ix_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_sub16;
                              cc_ctrl = load_cc;
                           end
                       endcase
                     4'b1101: // bsr / jsr
                       ;//null
                     4'b1110: // ldx
                       case (pre_code)
                         8'b00010000: // page 2 - ldy
                           begin 
                              left_ctrl = iy_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_ld16;
                              cc_ctrl = load_cc;
                              iy_ctrl = load_iy;
                           end
                         default: // page 1 - ldx
                           begin 
                              left_ctrl = ix_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_ld16;
                              cc_ctrl = load_cc;
                              ix_ctrl = load_ix;
                           end
                       endcase
                     4'b1111: // stx
                       case (pre_code)
                         8'b00010000: // page 2 - sty
                           begin 
                              left_ctrl = iy_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_st16;
                              cc_ctrl = load_cc;
                           end
                         default: // page 1 - stx
                           begin 
                              left_ctrl = ix_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_st16;
                              cc_ctrl = load_cc;
                           end
                       endcase
                     default:
                       ;//null
                   endcase
                 2'b11: // accb dual op
                   case (op_code[3:0])
                     4'b0000: // subb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sub8;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b0001: // cmpb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sub8;
                          cc_ctrl = load_cc;
                       end
                     4'b0010: // sbcb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_sbc;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b0011: // addd
                       begin 
                          left_ctrl = accd_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_add16;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_hi_acca;
                          accb_ctrl = load_accb;
                       end
                     4'b0100: // andb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_and;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b0101: // bitb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_and;
                          cc_ctrl = load_cc;
                       end
                     4'b0110: // ldab
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_ld8;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b0111: // stab
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_st8;
                          cc_ctrl = load_cc;
                       end
                     4'b1000: // eorb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_eor;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b1001: // adcb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_adc;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b1010: // orab
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_ora;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b1011: // addb
                       begin 
                          left_ctrl = accb_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_add8;
                          cc_ctrl = load_cc;
                          accb_ctrl = load_accb;
                       end
                     4'b1100: // ldd
                       begin 
                          left_ctrl = accd_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_ld16;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_hi_acca;
                          accb_ctrl = load_accb;
                       end
                     4'b1101: // std
                       begin 
                          left_ctrl = accd_left;
                          right_ctrl = md_right;
                          alu_ctrl = alu_st16;
                          cc_ctrl = load_cc;
                       end
                     4'b1110: // ldu
                       case (pre_code)
                         8'b00010000: // page 2 - lds
                           begin 
                              left_ctrl = sp_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_ld16;
                              cc_ctrl = load_cc;
                              sp_ctrl = load_sp;
                           end
                         default: // page 1 - ldu
                           begin 
                              left_ctrl = up_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_ld16;
                              cc_ctrl = load_cc;
                              up_ctrl = load_up;
                           end
                       endcase
                     4'b1111:
                       case (pre_code)
                         8'b00010000: // page 2 - sts
                           begin 
                              left_ctrl = sp_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_st16;
                              cc_ctrl = load_cc;
                           end
                         default: // page 1 - stu
                           begin 
                              left_ctrl = up_left;
                              right_ctrl = md_right;
                              alu_ctrl = alu_st16;
                              cc_ctrl = load_cc;
                           end
                       endcase
                     default:
                       ;//null
                   endcase
                 default:
                   ;//null
               endcase

               if (halt)
                 begin 
                    iv_ctrl = reset_iv;
                    next_state = halt_state;
                 end
               //-- service non maskable interrupts
               else if (nmi_req & nmi_ack == 1'b0)
                 begin 
                    iv_ctrl = nmi_iv;
                    nmi_ctrl = set_nmi;
                    next_state = int_nmiirq_state;
                 end
               //-- service maskable interrupts
               else 
                 begin 
                    begin 
		       //--
		       //-- nmi request is not cleared until nmi input goes low
		       //--
                       if (nmi_req == 1'b0 & nmi_ack)
                         nmi_ctrl = reset_nmi;

		       //--
		       //-- FIRQ & IRQ are level sensitive
		       //--
                       if (firq & cc[FBIT] == 1'b0)
                         begin 
                            iv_ctrl = firq_iv;
                            next_state = int_firq_state;
                         end
                       else
			 if (irq & cc[IBIT] == 1'b0)
                           begin 
                              iv_ctrl = irq_iv;
                              next_state = int_nmiirq_state;
                           end
                         else 
                           begin 
			      //-- Advance the PC to fetch next instruction byte
                              iv_ctrl = reset_iv;
                              pc_ctrl = incr_pc;
                              next_state = decode1_state;
                           end
                    end
                 end 
            end

	  //--
	  //-- Here to decode instruction
	  //-- and fetch next byte of intruction
	  //-- whether it be necessary or not
	  //--
          decode1_state:
            begin 
	       //-- fetch first byte of address or immediate data
               ea_ctrl = fetch_first_ea;
               md_ctrl = fetch_first_md;
               addr_ctrl = fetch_ad;
               case (op_code[7:4])
		 //--
		 //-- direct single op (2 bytes)
		 //-- 6809 => 6 cycles
		 //-- cpu09 => 5 cycles
		 //-- 1 op=(pc) / pc=pc+1
		 //-- 2 ea_hi=dp / ea_lo=(pc) / pc=pc+1
		 //-- 3 md_lo=(ea) / pc=pc
		 //-- 4 alu_left=md / md=alu_out / pc=pc
		 //-- 5 (ea)=md_lo / pc=pc
		 //--
		 //-- Exception is JMP
		 //-- 6809 => 3 cycles
		 //-- cpu09 => 3 cycles
		 //-- 1 op=(pc) / pc=pc+1
		 //-- 2 ea_hi=dp / ea_lo=(pc) / pc=pc+1
		 //-- 3 pc=ea
		 //--
                 4'b0000:
                   begin 
		      //-- advance the PC
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b1110: // jmp
                          next_state = jmp_state;
                        4'b1111: // clr
                          next_state = single_op_exec_state;
                        default:
                          next_state = single_op_read_state;
                      endcase
                   end
		 //-- acca / accb inherent instructions
                 4'b0001:
                   case (op_code[3:0])
		     //--
		     //-- Page2 pre byte
		     //-- pre=(pc) / pc=pc+1
		     //-- op=(pc) / pc=pc+1
		     //--
                     4'b0000: // page2
                       begin 
                          op_ctrl = fetch_op;
                          //-- advance pc
                          pc_ctrl = incr_pc;
                          next_state = decode2_state;
                       end

		     //--
		     //-- Page3 pre byte
		     //-- pre=(pc) / pc=pc+1
		     //-- op=(pc) / pc=pc+1
		     //--
                     4'b0001: // page 3
                       begin 
                          op_ctrl = fetch_op;
                          //-- advance pc
                          pc_ctrl = incr_pc;
                          next_state = decode3_state;
                       end

		     //--
		     //-- nop - No operation ( 1 byte )
		     //-- 6809 => 2 cycles
		     //-- cpu09 => 2 cycles
		     //-- 1 op=(pc) / pc=pc+1
		     //-- 2 decode
		     //-- 
                     4'b0010: // nop
                       next_state = fetch_state;

		     //--
		     //-- sync - halt execution until an interrupt is received
		     //-- interrupt may be NMI, IRQ or FIRQ
		     //-- program execution continues if the 
		     //-- interrupt is asserted for 3 clock cycles
		     //-- note that registers are not pushed onto the stack
		     //-- CPU09 => Interrupts need only be asserted for one clock cycle
		     //--
                     4'b0011: // sync
                       next_state = sync_state;

		     //--
		     //-- lbra //-- long branch (3 bytes)
		     //-- 6809 => 5 cycles
		     //-- cpu09 => 4 cycles
		     //-- 1 op=(pc) / pc=pc+1
		     //-- 2 md_hi=sign(pc) / md_lo=(pc) / pc=pc+1
		     //-- 3 md_hi=md_lo / md_lo=(pc) / pc=pc+1
		     //-- 4 pc=pc+md
		     //--
                     4'b0110:
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          next_state = lbranch_state;
                       end

		     //--
		     //-- lbsr - long branch to subroutine (3 bytes)
		     //-- 6809 => 9 cycles
		     //-- cpu09 => 6 cycles
		     //-- 1 op=(pc) /pc=pc+1
		     //-- 2 md_hi=sign(pc) / md_lo=(pc) / pc=pc+1 / sp=sp-1
		     //-- 3 md_hi=md_lo / md_lo=(pc) / pc=pc+1
		     //-- 4 (sp)= pc_lo / sp=sp-1 / pc=pc
		     //-- 5 (sp)=pc_hi / pc=pc
		     //-- 6 pc=pc+md
		     //--
                     4'b0111:
                       begin 
                          //-- pre decrement sp
                          left_ctrl = sp_left;
                          right_ctrl = one_right;
                          alu_ctrl = alu_sub16;
                          sp_ctrl = load_sp;
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          next_state = lbranch_state;
                       end
                     4'b1001: // daa
                       begin 
                          left_ctrl = acca_left;
                          right_ctrl = accb_right;
                          alu_ctrl = alu_daa;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_acca;
                          next_state = fetch_state;
                       end
                     4'b1010: // orcc
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          st_ctrl = push_st;
                          return_state = fetch_state;
                          next_state = orcc_state;
                       end
                     4'b1100: // andcc
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          st_ctrl = push_st;
                          return_state = fetch_state;
                          next_state = andcc_state;
                       end
                     4'b1101: // sex
                       begin 
                          //-- have sex
                          left_ctrl = accb_left;
                          right_ctrl = zero_right;
                          alu_ctrl = alu_sex;
                          cc_ctrl = load_cc;
                          acca_ctrl = load_hi_acca;
                          next_state = fetch_state;
                       end
                     4'b1110: // exg
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          next_state = exg_state;
                       end
                     4'b1111: // tfr
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          //-- call transfer as a subroutine
                          st_ctrl = push_st;
                          return_state = fetch_state;
                          next_state = tfr_state;
                       end
                     default:
                       begin 
                          //-- increment the pc
                          pc_ctrl = incr_pc;
                          next_state = fetch_state;
                       end
                   endcase

		 //--
		 //-- Short branch conditional
		 //-- 6809 => always 3 cycles
		 //-- cpu09 => always = 3 cycles
		 //-- 1 op=(pc) / pc=pc+1
		 //-- 2 md_hi=sign(pc) / md_lo=(pc) / pc=pc+1 / test cc
		 //-- 3 if cc tru pc=pc+md else pc=pc
		 //--
                 4'b0010: // branch unconditional
                   begin 
		      //-- increment the pc
                      pc_ctrl = incr_pc;
                      next_state = sbranch_state;
                   end
		 //--
		 //-- Single byte stack operators
		 //-- Do not advance PC
		 //--
                 4'b0011:
		   //--
		   //-- lea - load effective address (2+ bytes)
		   //-- 6809 => 4 cycles + addressing mode
		   //-- cpu09 => 4 cycles + addressing mode
		   //-- 1 op=(pc) / pc=pc+1
		   //-- 2 md_lo=(pc) / pc=pc+1
		   //-- 3 calculate ea
		   //-- 4 ix/iy/sp/up = ea
		   //--
                   case (op_code[3:0])
                     4'b0000, // leax
		     4'b0001, // leay
		     4'b0010, // leas
		     4'b0011: // leau
                       begin
			  //-- advance PC
                          pc_ctrl = incr_pc;
                          st_ctrl = push_st;
                          return_state = lea_state;
                          next_state = indexed_state;
                       end

		     //--
		     //-- pshs - push registers onto sp stack
		     //-- 6809 => 5 cycles + registers
		     //-- cpu09 => 3 cycles + registers
		     //--  1 op=(pc) / pc=pc+1
		     //--  2 ea_lo=(pc) / pc=pc+1 
		     //--  3 if ea(7 downto 0) != "00000000" then sp=sp-1
		     //--  4 if ea(7) = 1 (sp)=pcl, sp=sp-1
		     //--  5 if ea(7) = 1 (sp)=pch
		     //--    if ea(6 downto 0) != "0000000" then sp=sp-1
		     //--  6 if ea(6) = 1 (sp)=upl, sp=sp-1
		     //--  7 if ea(6) = 1 (sp)=uph
		     //--    if ea(5 downto 0) != "000000" then sp=sp-1
		     //--  8 if ea(5) = 1 (sp)=iyl, sp=sp-1
		     //--  9 if ea(5) = 1 (sp)=iyh
		     //--    if ea(4 downto 0) != "00000" then sp=sp-1
		     //-- 10 if ea(4) = 1 (sp)=ixl, sp=sp-1
		     //-- 11 if ea(4) = 1 (sp)=ixh
		     //--    if ea(3 downto 0) != "0000" then sp=sp-1
		     //-- 12 if ea(3) = 1 (sp)=dp
		     //--    if ea(2 downto 0) != "000" then sp=sp-1
		     //-- 13 if ea(2) = 1 (sp)=accb
		     //--    if ea(1 downto 0) != "00" then sp=sp-1
		     //-- 14 if ea(1) = 1 (sp)=acca
		     //--    if ea(0 downto 0) != "0" then sp=sp-1
		     //-- 15 if ea(0) = 1 (sp)=cc
		     //--
                     4'b0100: // pshs
                       begin 
                          //-- advance PC
                          pc_ctrl = incr_pc;
                          next_state = pshs_state;
                       end

		     //--
		     //-- puls - pull registers of sp stack
		     //-- 6809 => 5 cycles + registers
		     //-- cpu09 => 3 cycles + registers
		     //--
                     4'b0101: // puls
                       begin 
                          //-- advance PC
                          pc_ctrl = incr_pc;
                          next_state = puls_state;
                       end

		     //--
		     //-- pshu - push registers onto up stack
		     //-- 6809 => 5 cycles + registers
		     //-- cpu09 => 3 cycles + registers
		     //--
                     4'b0110: // pshu
                       begin 
                          //-- advance PC
                          pc_ctrl = incr_pc;
                          next_state = pshu_state;
                       end

		     //--
		     //-- pulu - pull registers of up stack
		     //-- 6809 => 5 cycles + registers
		     //-- cpu09 => 3 cycles + registers
		     //--
                     4'b0111: // pulu
		       begin
			  //-- advance pc
                          pc_ctrl = incr_pc;
                          next_state = pulu_state;
                       end

		     //--
		     //-- rts - return from subroutine
		     //-- 6809 => 5 cycles
		     //-- cpu09 => 4 cycles 
		     //-- 1 op=(pc) / pc=pc+1
		     //-- 2 decode op
		     //-- 3 pc_hi = (sp) / sp=sp+1
		     //-- 4 pc_lo = (sp) / sp=sp+1
		     //--
                     4'b1001:
                       begin 
                          st_ctrl = push_st;
                          return_state = fetch_state;
                          next_state = pull_return_hi_state;
                       end

		     //--
		     //-- add accb to index register
		     //-- *** Note: this is an unsigned addition.
		     //--           does not affect any condition codes
		     //-- 6809 => 3 cycles
		     //-- cpu09 => 2 cycles
		     //-- 1 op=(pc) / pc=pc+1
		     //-- 2 alu_left=ix / alu_right=accb / ix=alu_out / pc=pc
		     //--
                     4'b1010: // abx
                       begin 
                          left_ctrl = ix_left;
                          right_ctrl = accb_right;
                          alu_ctrl = alu_abx;
                          ix_ctrl = load_ix;
                          next_state = fetch_state;
                       end
                     4'b1011: // rti
                       next_state = rti_cc_state;
                     4'b1100: // cwai #$<cc_mask>
                       begin 
                          //-- pre decrement sp
                          left_ctrl = sp_left;
                          right_ctrl = one_right;
                          alu_ctrl = alu_sub16;
                          sp_ctrl = load_sp;
                          iv_ctrl = reset_iv;
                          //--	increment pc
                          pc_ctrl = incr_pc;
                          st_ctrl = push_st;
                          return_state = int_entire_state; // set entire flag
                          next_state = andcc_state;
                       end
                     4'b1101: // mul
                       next_state = mul_state;
                     4'b1111: // swi
                       begin 
                          //-- predecrement SP
                          left_ctrl = sp_left;
                          right_ctrl = one_right;
                          alu_ctrl = alu_sub16;
                          sp_ctrl = load_sp;
                          iv_ctrl = swi_iv;
                          next_state = int_entire_state;
                       end
                     default:
                       next_state = fetch_state;
                   endcase

		 //--
		 //-- Accumulator A Single operand
		 //-- source = acca, dest = acca
		 //-- Do not advance PC
		 //-- Typically 2 cycles 1 bytes
		 //-- 1 opcode fetch
		 //-- 2 post byte fetch / instruction decode
		 //-- Note that there is no post byte
		 //-- so do not advance PC in decode cycle
		 //-- Re-run opcode fetch cycle after decode
		 //-- 
                 4'b0100: // acca single op
                   begin 
                      left_ctrl = acca_left;
                      case (op_code[3:0])
                        4'b0000: // neg
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_neg;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b0011: // com
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_com;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b0100: // lsr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_lsr8;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b0110: // ror
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_ror8;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b0111: // asr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_asr8;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1000: // asl
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_asl8;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1001: // rol
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_rol8;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1010:
                          begin // dec
                             right_ctrl = one_right;
                             alu_ctrl = alu_dec;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1011: // undefined
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             acca_ctrl = latch_acca;
                             cc_ctrl = latch_cc;
                          end
                        4'b1100: // inc
                          begin 
                             right_ctrl = one_right;
                             alu_ctrl = alu_inc;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1101: // tst
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_st8;
                             acca_ctrl = latch_acca;
                             cc_ctrl = load_cc;
                          end
                        4'b1110: // jmp (not defined)
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             acca_ctrl = latch_acca;
                             cc_ctrl = latch_cc;
                          end
                        4'b1111: // clr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_clr;
                             acca_ctrl = load_acca;
                             cc_ctrl = load_cc;
                          end
                        default:
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             acca_ctrl = latch_acca;
                             cc_ctrl = latch_cc;
                          end
                      endcase
                      next_state = fetch_state;
                   end
		 //--
		 //-- Single Operand accb
		 //-- source = accb, dest = accb
		 //-- Typically 2 cycles 1 bytes
		 //-- 1 opcode fetch
		 //-- 2 post byte fetch / instruction decode
		 //-- Note that there is no post byte
		 //-- so do not advance PC in decode cycle
		 //-- Re-run opcode fetch cycle after decode
		 //--
                 4'b0101:
                   begin 
                      left_ctrl = accb_left;
                      case (op_code[3:0])
                        4'b0000: // neg
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_neg;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b0011: // com
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_com;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b0100: // lsr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_lsr8;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b0110: // ror
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_ror8;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b0111: // asr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_asr8;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1000: // asl
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_asl8;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1001: // rol
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_rol8;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1010: // dec
                          begin 
                             right_ctrl = one_right;
                             alu_ctrl = alu_dec;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1011: // undefined
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             accb_ctrl = latch_accb;
                             cc_ctrl = latch_cc;
                          end
                        4'b1100: // inc
                          begin 
                             right_ctrl = one_right;
                             alu_ctrl = alu_inc;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1101: // tst
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_st8;
                             accb_ctrl = latch_accb;
                             cc_ctrl = load_cc;
                          end
                        4'b1110: // jmp (undefined)
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             accb_ctrl = latch_accb;
                             cc_ctrl = latch_cc;
                          end
                        4'b1111: // clr
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_clr;
                             accb_ctrl = load_accb;
                             cc_ctrl = load_cc;
                          end
                        default:
                          begin 
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             accb_ctrl = latch_accb;
                             cc_ctrl = latch_cc;
                          end
                      endcase
                      next_state = fetch_state;
                   end
		 //--
		 //-- Single operand indexed
		 //-- Two byte instruction so advance PC
		 //-- EA should hold index offset
		 //--
                 4'b0110: //-- indexed single op
                   begin
		      //-- increment the pc
                      pc_ctrl = incr_pc;
                      st_ctrl = push_st;
                      case (op_code[3:0])
                        4'b1110: // jmp
                          return_state = jmp_state;
                        4'b1111: // clr
                          return_state = single_op_exec_state;
                        default:
                          return_state = single_op_read_state;
                      endcase
                      next_state = indexed_state;
                   end
		 //--
		 //-- Single operand extended addressing
		 //-- three byte instruction so advance the PC
		 //-- Low order EA holds high order address
		 //--
                 4'b0111: //-- extended single op
                   begin
		      //-- increment PC
                      pc_ctrl = incr_pc;
                      st_ctrl = push_st;
                      case (op_code[3:0])
                        4'b1110: // jmp
                          return_state = jmp_state;
                        4'b1111: // clr
                          return_state = single_op_exec_state;
                        default:
                          return_state = single_op_read_state;
                      endcase
                      next_state = extended_state;
                   end
                 4'b1000: // acca immediate
                   begin 
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // subd #
			4'b1100, // cmpx #
			4'b1110: // ldx #
                          begin 
                             st_ctrl = push_st;
                             return_state = fetch_state;
                             next_state = imm16_state;
                          end
			//--
			//-- bsr offset - Branch to subroutine (2 bytes)
			//-- 6809 => 7 cycles
			//-- cpu09 => 5 cycles
			//-- 1 op=(pc) / pc=pc+1
			//-- 2 md_hi=sign(pc) / md_lo=(pc) / sp=sp-1 / pc=pc+1
                        //-- 3 (sp)=pc_lo / sp=sp-1
                        //-- 4 (sp)=pc_hi
                        //-- 5 pc=pc+md
                        //--
                        4'b1101: // bsr
                          begin 
                             //-- pre decrement SP
                             left_ctrl = sp_left;
                             right_ctrl = one_right;
                             alu_ctrl = alu_sub16;
                             sp_ctrl = load_sp;
                             st_ctrl = push_st;
                             return_state = sbranch_state;
                             next_state = push_return_lo_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1001: // acca direct
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // subd
			4'b1100, // cmpx
			4'b1110: // ldx
                          next_state = dual_op_read16_state;
                        4'b0111: // sta direct
                          next_state = dual_op_write8_state;
                        4'b1111: // stx direct
                          begin
			     //-- idle ALU
                             left_ctrl = ix_left;
                             right_ctrl = zero_right;
                             alu_ctrl = alu_nop;
                             cc_ctrl = latch_cc;
                             sp_ctrl = latch_sp;
                             next_state = dual_op_write16_state;
                          end
			//--
			//-- jsr direct - Jump to subroutine in direct page (2 bytes)
			//-- 6809 => 7 cycles
			//-- cpu09 => 5 cycles
			//-- 1 op=(pc) / pc=pc+1
			//-- 2 ea_hi=0 / ea_lo=(pc) / sp=sp-1 / pc=pc+1
                        //-- 3 (sp)=pc_lo / sp=sp-1
                        //-- 4 (sp)=pc_hi
                        //-- 5 pc=ea
                        //--
                        4'b1101: // jsr direct
                          begin 
                             //-- pre decrement sp
                             left_ctrl = sp_left;
                             right_ctrl = one_right;
                             alu_ctrl = alu_sub16;
                             sp_ctrl = load_sp;
                             //--
                             st_ctrl = push_st;
                             return_state = jmp_state;
                             next_state = push_return_lo_state;
                          end
                        default:
                          next_state = dual_op_read8_state;
                      endcase
                   end
                 4'b1010: // acca indexed
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // subd
			4'b1100, // cmpx
			4'b1110: // ldx
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = indexed_state;
                          end
                        4'b0111: // staa, x
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write8_state;
                             next_state = indexed_state;
                          end
                        4'b1111: // stx, x
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = indexed_state;
                          end
                        4'b1101: // jsr , x
                          begin 
                             //-- DO NOT pre decrement SP
                             st_ctrl = push_st;
                             return_state = jsr_state;
                             next_state = indexed_state;
                          end
                        default:
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read8_state;
                             next_state = indexed_state;
                          end
                      endcase
                   end
                 4'b1011: // acca extended
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // subs
			4'b1100, // cmpx
			4'b1110: // ldx
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = extended_state;
                          end
                        4'b0111: // staa >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write8_state;
                             next_state = extended_state;
                          end
                        4'b1111: // stx >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = extended_state;
                          end
                        4'b1101: // jsr >extended
                          begin
			     //-- DO NOT pre decrement sp
                             st_ctrl = push_st;
                             return_state = jsr_state;
                             next_state = extended_state;
                          end
                        default:
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read8_state;
                             next_state = extended_state;
                          end
                      endcase
                   end
                 4'b1100: // accb immediate
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // addd #
			4'b1100, // ldd #
			4'b1110: // ldu #
                          begin 
                             st_ctrl = push_st;
                             return_state = fetch_state;
                             next_state = imm16_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1101: // accb direct
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // addd
			4'b1100, // ldd
			4'b1110: // ldu
                          next_state = dual_op_read16_state;
                        4'b0111: // stab direct
                          next_state = dual_op_write8_state;
                        4'b1101: // std direct
                          next_state = dual_op_write16_state;
                        4'b1111: // stu direct
                          next_state = dual_op_write16_state;
                        default:
                          next_state = dual_op_read8_state;
                      endcase
                   end
                 4'b1110: // accb indexed
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // addd
			4'b1100, // ldd
			4'b1110: // ldu
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = indexed_state;
                          end
                        4'b0111: // stab indexed
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write8_state;
                             next_state = indexed_state;
                          end
                        4'b1101: // std indexed
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = indexed_state;
                          end
                        4'b1111: // stu indexed
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = indexed_state;
                          end
                        default:
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read8_state;
                             next_state = indexed_state;
                          end
                      endcase
                   end
                 4'b1111: // accb extended
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // addd
			4'b1100, // ldd
			4'b1110: // ldu
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = extended_state;
                          end
                        4'b0111: // stab extended
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write8_state;
                             next_state = extended_state;
                          end
                        4'b1101: // std extended
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = extended_state;
                          end
                        4'b1111: // stu extended
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = extended_state;
                          end
                        default:
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read8_state;
                             next_state = extended_state;
                          end
                      endcase
                   end
                 default:
                   ;//null
               endcase
            end

	  //--
	  //-- Here to decode prefix 2 instruction
	  //-- and fetch next byte of intruction
	  //-- whether it be necessary or not
	  //--
          decode2_state:
            begin 
               //-- fetch first byte of address or immediate data
               ea_ctrl = fetch_first_ea;
               md_ctrl = fetch_first_md;
               addr_ctrl = fetch_ad;
               case (op_code[7:4])
		 //--
		 //-- lbcc -- long branch conditional
		 //-- 6809 => branch 6 cycles, no branch 5 cycles
		 //-- cpu09 => always 5 cycles
		 //-- 1 pre=(pc) / pc=pc+1
		 //-- 2 op=(pc) / pc=pc+1
		 //-- 3 md_hi=sign(pc) / md_lo=(pc) / pc=pc+1
		 //-- 4 md_hi=md_lo / md_lo=(pc) / pc=pc+1
		 //-- 5 if cond pc=pc+md else pc=pc
		 //--
                 4'b0010:
                   begin 
		      //-- increment the pc
                      pc_ctrl = incr_pc;
                      next_state = lbranch_state;
                   end

		 //--
		 //-- Single byte stack operators
		 //-- Do not advance PC
		 //--
                 4'b0011:
                   case (op_code[3:0])
                     4'b1111: // swi 2
                       begin 
                          //-- predecrement sp
                          left_ctrl = sp_left;
                          right_ctrl = one_right;
                          alu_ctrl = alu_sub16;
                          sp_ctrl = load_sp;
                          iv_ctrl = swi2_iv;
                          next_state = int_entire_state;
                       end
                     default:
                       next_state = fetch_state;
                   endcase
                 4'b1000: // acca immediate
                   begin 
		      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpd #
			4'b1100, // cmpy #
			4'b1110: // ldy #
                          begin 
                             st_ctrl = push_st;
                             return_state = fetch_state;
                             next_state = imm16_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1001: // aca direct
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpd <
			4'b1100, // cmpy <
			4'b1110: // ldy <
                          next_state = dual_op_read16_state;
                        4'b1111: // sty <
                          next_state = dual_op_write16_state;
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1010: // acca indexed
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpd ,ind
			4'b1100, // cmpy ,ind
			4'b1110: // ldy ,ind
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = indexed_state;
                          end
                        4'b1111: // sty ,ind
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = indexed_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1011: // acca extended
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpd <
			4'b1100, // cmpy <
			4'b1110: // ldy <
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = extended_state;
                          end
                        4'b1111: // sty >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = extended_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1100: // accb immediate
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // undef #
			4'b1100, // undef #
			4'b1110: // lds #
                          begin 
                             st_ctrl = push_st;
                             return_state = fetch_state;
                             next_state = imm16_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1101: // accb direct
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // undef <
			4'b1100, // undef <
			4'b1110: // lds <
                          next_state = dual_op_read16_state;
                        4'b1111: // sts <
                          next_state = dual_op_write16_state;
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1110: // accb indexed
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // undef ,ind
			4'b1100, // undef ,ind
			4'b1110: // lds ,ind
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = indexed_state;
                          end
                        4'b1111: // sts ,ind
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = indexed_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1111: // accb extended
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // undef >
			4'b1100, // undef >
			4'b1110: // lds >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = extended_state;
                          end
                        4'b1111: // sts >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_write16_state;
                             next_state = extended_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 default:
                   next_state = fetch_state;
               endcase
            end
	  //--
	  //-- Here to decode instruction
	  //-- and fetch next byte of intruction
	  //-- whether it be necessary or not
	  //--
          decode3_state:
            begin 
               ea_ctrl = fetch_first_ea;
               md_ctrl = fetch_first_md;
               addr_ctrl = fetch_ad;
               dout_ctrl = md_lo_dout;
               case (op_code[7:4])
		 //--
		 //-- Single byte stack operators
		 //-- Do not advance PC
		 //--
                 4'b0011:
                   case (op_code[3:0])
                     4'b1111: // swi3
                       begin 
                          //-- predecrement sp
                          left_ctrl = sp_left;
                          right_ctrl = one_right;
                          alu_ctrl = alu_sub16;
                          sp_ctrl = load_sp;
                          iv_ctrl = swi3_iv;
                          next_state = int_entire_state;
                       end
                     default:
                       next_state = fetch_state;
                   endcase
                 4'b1000: // acca immediate
                   begin 
		      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpu #
			4'b1100, // cmps #
			4'b1110: // undef #
                          begin 
                             st_ctrl = push_st;
                             return_state = fetch_state;
                             next_state = imm16_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1001: // acca direct
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpu <
			4'b1100, // cmps <
			4'b1110: // undef <
                          begin 
                             st_ctrl = idle_st;
                             return_state = fetch_state;
                             next_state = dual_op_read16_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1010: // acca indexed
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpu ,X
			4'b1100, // cmps ,X
			4'b1110: // undef ,X
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = indexed_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 4'b1011: // acca extended
                   begin 
                      //-- increment the pc
                      pc_ctrl = incr_pc;
                      case (op_code[3:0])
                        4'b0011, // cmpu >
			4'b1100, // cmps >
			4'b1110: // undef >
                          begin 
                             st_ctrl = push_st;
                             return_state = dual_op_read16_state;
                             next_state = extended_state;
                          end
                        default:
                          next_state = fetch_state;
                      endcase
                   end
                 default:
                   next_state = fetch_state;
               endcase
            end

	  //--
	  //-- here if ea holds low byte
	  //-- Direct
	  //-- Extended
	  //-- Indexed
	  //-- read memory location
	  //--
          single_op_read_state:
            begin 
	       //-- read memory into md
               md_ctrl = fetch_first_md;
               addr_ctrl = read_ad;
               dout_ctrl = md_lo_dout;
               next_state = single_op_exec_state;
            end
          single_op_exec_state:
            case (op_code[3:0])
              4'b0000: // neg
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_neg;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b0011: // com
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_com;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b0100: // lsr
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_lsr8;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b0110: // ror
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_ror8;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b0111: // asr
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_asr8;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b1000: // asl
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_asl8;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b1001: // rol
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_rol8;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b1010: // dec
                begin 
                   left_ctrl = md_left;
                   right_ctrl = one_right;
                   alu_ctrl = alu_dec;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b1011: // undefined
                next_state = fetch_state;
              4'b1100: // inc
                begin 
                   left_ctrl = md_left;
                   right_ctrl = one_right;
                   alu_ctrl = alu_inc;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              4'b1101: // tst
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_st8;
                   cc_ctrl = load_cc;
                   next_state = fetch_state;
                end
              4'b1110: // jmp
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_ld16;
                   pc_ctrl = load_pc;
                   next_state = fetch_state;
                end
              4'b1111: // clr
                begin 
                   left_ctrl = md_left;
                   right_ctrl = zero_right;
                   alu_ctrl = alu_clr;
                   cc_ctrl = load_cc;
                   md_ctrl = load_md;
                   next_state = single_op_write_state;
                end
              default:
                next_state = fetch_state;
            endcase
	  //--
	  //-- single operand 8 bit write
	  //-- Write low 8 bits of ALU output
	  //-- EA holds address
	  //-- MD holds data
	  //--
          single_op_write_state:
            begin 
               //-- write ALU low byte output
               addr_ctrl = write_ad;
               dout_ctrl = md_lo_dout;
               next_state = fetch_state;
            end

	  //--
	  //-- here if ea holds address of low byte
	  //-- read memory location
	  //--
          dual_op_read8_state:
            begin 
               //-- read first data byte from ea
               md_ctrl = fetch_first_md;
               addr_ctrl = read_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- Here to read a 16 bit value into MD
	  //-- pointed to by the EA register
	  //-- The first byte is read
	  //-- and the EA is incremented
	  //--
          dual_op_read16_state:
            begin 
	       //-- increment the effective address
               left_ctrl = ea_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
	       //-- read the high byte of the 16 bit data
               md_ctrl = fetch_first_md;
               addr_ctrl = read_ad;
               next_state = dual_op_read16_2_state;
            end

	  //--
	  //-- here to read the second byte
	  //-- pointed to by EA into MD
	  //--
          dual_op_read16_2_state:
            begin 
	       //-- read the low byte of the 16 bit data
               md_ctrl = fetch_next_md;
               addr_ctrl = read_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- 16 bit Write state
	  //-- EA hold address of memory to write to
	  //-- Advance the effective address in ALU
	  //-- decode op_code to determine which
	  //-- register to write
	  //--
          dual_op_write16_state:
            begin 
               //-- increment the effective address
               left_ctrl = ea_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- write the ALU hi byte at ea
               addr_ctrl = write_ad;
               if ((op_code[6] == 1'b0)) 
                 case (op_code[3:0])
                   4'b1111: // stx / sty
                     case (pre_code)
                       8'b00010000: // page 2 -- sty
                         dout_ctrl = iy_hi_dout;
                       default:  // page 1 -- stx
                         dout_ctrl = ix_hi_dout;
                     endcase
                   default:
                     dout_ctrl = md_hi_dout;
                 endcase
               else 
                 case (op_code[3:0])
                   4'b1101: // std
                     dout_ctrl = acca_dout; // acca is high byte of ACCD
                   4'b1111: // stu / sts
                     case (pre_code)
                       8'b00010000: // page 2 -- sts
                         dout_ctrl = sp_hi_dout;
                       default: // page 1 -- stu
                         dout_ctrl = up_hi_dout;
                     endcase
                   default:
                     dout_ctrl = md_hi_dout;
                 endcase

               next_state = dual_op_write8_state;
            end

	  //--
	  //-- Dual operand 8 bit write
	  //-- Write 8 bit accumulator
	  //-- or low byte of 16 bit register
	  //-- EA holds address
	  //-- decode opcode to determine
	  //-- which register to apply to the bus
	  //-- Also set the condition codes here
	  //--
          dual_op_write8_state:
            begin 
               if ((op_code[6] == 1'b0)) 
                 case (op_code[3:0])
                   4'b0111: // sta
                     dout_ctrl = acca_dout;
                   4'b1111: // stx / sty
                     case (pre_code)
                       8'b00010000: // page 2 -- sty
                         dout_ctrl = iy_lo_dout;
                       default: // page 1 -- stx
                         dout_ctrl = ix_lo_dout;
                     endcase
                   default:
                     dout_ctrl = md_lo_dout;
                 endcase
               else 
                 case (op_code[3:0])
                   4'b0111: // stb
                     dout_ctrl = accb_dout;
                   4'b1101: // std
                     dout_ctrl = accb_dout; // accb is low byte of accd
                   4'b1111: // stu / sts
                     case (pre_code)
                       8'b00010000: // pag 2 -- sts
                         dout_ctrl = sp_lo_dout;
                       default: // page 1 -- stu
                         dout_ctrl = up_lo_dout;
                     endcase
                   default:
                     dout_ctrl = md_lo_dout;
                 endcase

               //-- write ALU low byte output
               addr_ctrl = write_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- 16 bit immediate addressing mode
	  //--
          imm16_state:
            begin 
               //-- increment pc
               pc_ctrl = incr_pc;
               //-- fetch next immediate byte
               md_ctrl = fetch_next_md;
               addr_ctrl = fetch_ad;
               st_ctrl = pull_st;
               next_state = saved_state;
            end

	  //--
	  //-- md & ea holds 8 bit index offset
	  //-- calculate the effective memory address
	  //-- using the alu
	  //--
          indexed_state:
            //--
            //-- decode indexing mode
            //--
            if ((md[7] == 1'b0)) 
              begin 
                 case (md[6:5])
                   2'b00:
                     left_ctrl = ix_left;
                   2'b01:
                     left_ctrl = iy_left;
                   2'b10:
                     left_ctrl = up_left;
                   default:
                     left_ctrl = sp_left;
                 endcase
                 right_ctrl = md_sign5_right;
                 alu_ctrl = alu_add16;
                 ea_ctrl = load_ea;
                 st_ctrl = pull_st;
                 next_state = saved_state;
              end
            else 
              case (md[3:0])
                4'b0000: // ,R+
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
		     //--
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     next_state = postincr1_state;
                  end
                4'b0001: // ,R++
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     next_state = postincr2_state;
                  end
                4'b0010: // ,-R
                  begin 
                     case (md[6:5])
                       2'b00:
                         begin 
                            left_ctrl = ix_left;
                            ix_ctrl = load_ix;
                         end
                       2'b01:
                         begin 
                            left_ctrl = iy_left;
                            iy_ctrl = load_iy;
                         end
                       2'b10:
                         begin 
                            left_ctrl = up_left;
                            up_ctrl = load_up;
                         end
                       default:
                         begin 
                            left_ctrl = sp_left;
                            sp_ctrl = load_sp;
                         end
                     endcase
                     right_ctrl = one_right;
                     alu_ctrl = alu_sub16;
                     ea_ctrl = load_ea;
                     st_ctrl = pull_st;
                     next_state = saved_state;
                  end
                4'b0011: // ,--R
                  begin 
                     case (md[6:5])
                       2'b00:
                         begin 
                            left_ctrl = ix_left;
                            ix_ctrl = load_ix;
                         end
                       2'b01:
                         begin 
                            left_ctrl = iy_left;
                            iy_ctrl = load_iy;
                         end
                       2'b10:
                         begin 
                            left_ctrl = up_left;
                            up_ctrl = load_up;
                         end
                       default:
                         begin 
                            left_ctrl = sp_left;
                            sp_ctrl = load_sp;
                         end
                     endcase
                     right_ctrl = two_right;
                     alu_ctrl = alu_sub16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b0100: // ,R (zero offset)
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b0101: // ACCB,R
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = accb_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b0110: // ACCA,R
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = acca_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b0111: // undefined
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b1000: // offset8,R
                  begin 
                     md_ctrl = fetch_first_md; // pick up 8 bit offset
                     addr_ctrl = fetch_ad;
                     pc_ctrl = incr_pc;
                     next_state = index8_state;
                  end
                4'b1001: // offset16,R
                  begin 
                     md_ctrl = fetch_first_md; // pick up first byte of 16 bit offset
                     addr_ctrl = fetch_ad;
                     pc_ctrl = incr_pc;
                     next_state = index16_state;
                  end
                4'b1010: // undefined
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
		     //
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b1011: // ACCD,R
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = accd_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                4'b1100: // offset8,PC
                  begin
		     // fetch 8 bit offset
                     md_ctrl = fetch_first_md;
                     addr_ctrl = fetch_ad;
                     pc_ctrl = incr_pc;
                     next_state = pcrel8_state;
                  end
                4'b1101: // offset16,PC
                  begin
		     // fetch offset
                     md_ctrl = fetch_first_md;
                     addr_ctrl = fetch_ad;
                     pc_ctrl = incr_pc;
                     next_state = pcrel16_state;
                  end
                4'b1110: // undefined
                  begin 
                     case (md[6:5])
                       2'b00:
                         left_ctrl = ix_left;
                       2'b01:
                         left_ctrl = iy_left;
                       2'b10:
                         left_ctrl = up_left;
                       default:
                         left_ctrl = sp_left;
                     endcase
                     right_ctrl = zero_right;
                     alu_ctrl = alu_add16;
                     ea_ctrl = load_ea;
                     if ((md[4] == 1'b0)) 
                       begin 
                          st_ctrl = pull_st;
                          next_state = saved_state;
                       end
                     else 
                       next_state = indirect_state;

                     
                  end
                //4'b1111: // [,address]
                  default:
                    begin 
		       //-- advance PC to pick up address
                       md_ctrl = fetch_first_md;
                       addr_ctrl = fetch_ad;
                       pc_ctrl = incr_pc;
                       next_state = indexaddr_state;
                    end
              endcase

          
	  //-- load index register with ea plus one
          postincr1_state:
            begin 
               left_ctrl = ea_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               case (md[6:5])
                 2'b00:
                   ix_ctrl = load_ix;
                 2'b01:
                   iy_ctrl = load_iy;
                 2'b10:
                   up_ctrl = load_up;
                 default:
                   sp_ctrl = load_sp;
               endcase
               //-- return to previous state
               if ((md[4] == 1'b0)) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end

	  //-- load index register with ea plus two
          postincr2_state:
            begin 
               //-- increment register by two (address)
               left_ctrl = ea_left;
               right_ctrl = two_right;
               alu_ctrl = alu_add16;
               case (md[6:5])
                 2'b00:
                   ix_ctrl = load_ix;
                 2'b01:
                   iy_ctrl = load_iy;
                 2'b10:
                   up_ctrl = load_up;
                 default:
                   sp_ctrl = load_sp;
               endcase
               //-- return to previous state
               if ((md[4] == 1'b0)) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end
	  //--
	  //-- ea = index register + md (8 bit signed offset)
	  //-- ea holds post byte
	  //--
          index8_state:
            begin 
               case (ea[6:5])
                 2'b00:
                   left_ctrl = ix_left;
                 2'b01:
                   left_ctrl = iy_left;
                 2'b10:
                   left_ctrl = up_left;
                 default:
                   left_ctrl = sp_left;
               endcase
               //-- ea = index reg + md
               right_ctrl = md_sign8_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- return to previous state
               if (ea[4] == 1'b0) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end

	  //-- fetch low byte of 16 bit indexed offset
          index16_state:
            begin 
               //-- advance pc
               pc_ctrl = incr_pc;
               //-- fetch low byte
               md_ctrl = fetch_next_md;
               addr_ctrl = fetch_ad;
               next_state = index16_2_state;
            end

	  //-- ea = index register + md (16 bit offset)
	  //-- ea holds post byte
          index16_2_state:
            begin 
               case (ea[6:5])
                 2'b00:
                   left_ctrl = ix_left;
                 2'b01:
                   left_ctrl = iy_left;
                 2'b10:
                   left_ctrl = up_left;
                 default:
                   left_ctrl = sp_left;
               endcase
               //-- ea = index reg + md
               right_ctrl = md_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- return to previous state
               if (ea[4] == 1'b0) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end
	  //--
	  //-- pc relative with 8 bit signed offest
	  //-- md holds signed offset
	  //--
          pcrel8_state:
            begin 
               //-- ea = pc + signed md
               left_ctrl = pc_left;
               right_ctrl = md_sign8_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- return to previous state
               if (ea[4] == 1'b0) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end

	  //-- pc relative addressing with 16 bit offset
	  //-- pick up the low byte of the offset in md
	  //-- advance the pc
          pcrel16_state:
            begin 
               //-- advance pc
               pc_ctrl = incr_pc;
               //-- fetch low byte
               md_ctrl = fetch_next_md;
               addr_ctrl = fetch_ad;
               next_state = pcrel16_2_state;
            end

	  //-- pc relative with16 bit signed offest
	  //-- md holds signed offset
          pcrel16_2_state:
            begin 
               //-- ea = pc +  md
               left_ctrl = pc_left;
               right_ctrl = md_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- return to previous state
               if (ea[4] == 1'b0) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end

	  //-- indexed to address
	  //-- pick up the low byte of the address
	  //-- advance the pc
          indexaddr_state:
            begin 
               //-- advance pc
               pc_ctrl = incr_pc;
               //-- fetch low byte
               md_ctrl = fetch_next_md;
               addr_ctrl = fetch_ad;
               next_state = indexaddr2_state;
            end

	  //-- indexed to absolute address
	  //-- md holds address
	  //-- ea hold indexing mode byte
          indexaddr2_state:
            begin 
               //-- ea = md
               left_ctrl = pc_left;
               right_ctrl = md_right;
               alu_ctrl = alu_ld16;
               ea_ctrl = load_ea;
               //-- return to previous state
               if (ea[4] == 1'b0) 
                 begin 
                    st_ctrl = pull_st;
                    next_state = saved_state;
                 end
               else 
                 next_state = indirect_state;

               
            end

	  //--
	  //-- load md with high byte of indirect address
	  //-- pointed to by ea
	  //-- increment ea
	  //--
          indirect_state:
            begin 
               //-- increment ea
               left_ctrl = ea_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               ea_ctrl = load_ea;
               //-- fetch high byte
               md_ctrl = fetch_first_md;
               addr_ctrl = read_ad;
               next_state = indirect2_state;
            end
	  //--
	  //-- load md with low byte of indirect address
	  //-- pointed to by ea
	  //-- ea has previously been incremented
	  //--
          indirect2_state:
            begin 
               //-- fetch high byte
               md_ctrl = fetch_next_md;
               addr_ctrl = read_ad;
               dout_ctrl = md_lo_dout;
               next_state = indirect3_state;
            end
	  //--
	  //-- complete idirect addressing
	  //-- by loading ea with md
	  //--
          indirect3_state:
            begin 
               //-- load ea with md
               left_ctrl = ea_left;
               right_ctrl = md_right;
               alu_ctrl = alu_ld16;
               ea_ctrl = load_ea;
               //-- return to previous state
               st_ctrl = pull_st;
               next_state = saved_state;
            end

	  //--
	  //-- ea holds the low byte of the absolute address
	  //-- Move ea low byte into ea high byte
	  //-- load new ea low byte to for absolute 16 bit address
	  //-- advance the program counter
	  //--
          extended_state: // fetch ea low byte
            begin 
               //-- increment pc
               pc_ctrl = incr_pc;
	       //-- fetch next effective address bytes
               ea_ctrl = fetch_next_ea;
               addr_ctrl = fetch_ad;
               //-- return to previous state
               st_ctrl = pull_st;
               next_state = saved_state;
            end

          lea_state: // here on load effective address
            begin 
               //-- load index register with effective address
               left_ctrl = pc_left;
               right_ctrl = ea_right;
               alu_ctrl = alu_lea;
               case (op_code[3:0])
                 4'b0000: // leax
                   begin 
                      cc_ctrl = load_cc;
                      ix_ctrl = load_ix;
                   end
                 4'b0001: // leay
                   begin 
                      cc_ctrl = load_cc;
                      iy_ctrl = load_iy;
                   end
                 4'b0010: // leas
                   sp_ctrl = load_sp;
                 4'b0011: // leau
                   up_ctrl = load_up;
                 default:
                   ;//null
               endcase
               next_state = fetch_state;
            end

	  //--
	  //-- jump to subroutine
	  //-- sp=sp-1
	  //-- call push_return_lo_state to save pc
	  //-- return to jmp_state
	  //--
          jsr_state:
            begin 
	       //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
	       //-- call push_return_state
               st_ctrl = push_st;
               return_state = jmp_state;
               next_state = push_return_lo_state;
            end

	  //--
	  //-- Load pc with ea
	  //-- (JMP)
	  //--
          jmp_state:
            begin 
	       //-- load PC with effective address
               left_ctrl = pc_left;
               right_ctrl = ea_right;
               alu_ctrl = alu_ld16;
               pc_ctrl = load_pc;
               next_state = fetch_state;
            end

	  //--
	  //-- long branch or branch to subroutine
	  //-- pick up next md byte
	  //-- md_hi = md_lo
	  //-- md_lo = (pc)
	  //-- pc=pc+1
	  //-- if a lbsr push return address
	  //-- continue to sbranch_state
	  //-- to evaluate conditional branches
	  //--
          lbranch_state:
            begin 
               pc_ctrl = incr_pc;
	       //-- fetch the next byte into md_lo
               md_ctrl = fetch_next_md;
               addr_ctrl = fetch_ad;
	       //-- if lbsr - push return address
	       //-- then continue on to short branch
               if ((op_code == 8'b00010111)) 
                 begin 
                    st_ctrl = push_st;
                    return_state = sbranch_state;
                    next_state = push_return_lo_state;
                 end
               else 
                 next_state = sbranch_state;

               
            end

	  //--
	  //-- here to execute conditional branch
	  //-- short conditional branch md = signed 8 bit offset
	  //-- long branch md = 16 bit offset
	  //-- 
          sbranch_state:
            begin 
               left_ctrl = pc_left;
               right_ctrl = md_right;
               alu_ctrl = alu_add16;
	       //-- Test condition for branch
               if ((op_code[7:4] == 4'b0010)) // conditional branch
                 case (op_code[3:0])
                   4'b0000: // bra
                     cond_true = 1'b1;
                   4'b0001: // brn
                     cond_true = 1'b0;
                   4'b0010: // bhi
                     cond_true = ((cc[CBIT] | cc[ZBIT]) == 1'b0);
                   4'b0011: // bls
                     cond_true = ((cc[CBIT] | cc[ZBIT]) == 1'b1);
                   4'b0100: // bcc/bhs
                     cond_true = (cc[CBIT] == 1'b0);
                   4'b0101: // bcs/blo
                     cond_true = (cc[CBIT] == 1'b1);
                   4'b0110: // bne
                     cond_true = (cc[ZBIT] == 1'b0);
                   4'b0111: // beq
                     cond_true = (cc[ZBIT] == 1'b1);
                   4'b1000: // bvc
                     cond_true = (cc[VBIT] == 1'b0);
                   4'b1001: // bvs
                     cond_true = (cc[VBIT] == 1'b1);
                   4'b1010: // bpl
                     cond_true = (cc[NBIT] == 1'b0);
                   4'b1011: // bmi
                     cond_true = (cc[NBIT] == 1'b1);
                   4'b1100: // bge
                     cond_true = ((cc[NBIT] ^ cc[VBIT]) == 1'b0);
                   4'b1101: // blt
                     cond_true = ((cc[NBIT] ^ cc[VBIT]) == 1'b1);
                   4'b1110: // bgt
                     cond_true = ((cc[ZBIT] | (cc[NBIT] ^ cc[VBIT])) == 1'b0);
                   4'b1111: // ble
                     cond_true = ((cc[ZBIT] | (cc[NBIT] ^ cc[VBIT])) == 1'b1);
                   default:
                     ;//null
                 endcase
               else 
                 cond_true = 1'b1; // lbra, lbsr, bsr

               if (cond_true) 
                 pc_ctrl = load_pc;

               next_state = fetch_state;
            end

	  //--
	  //-- push return address onto the S stack
	  //--
	  //-- (sp) = pc_lo
	  //-- sp = sp - 1
	  //--
          push_return_lo_state:
            begin 
               //-- decrement the sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write PC low
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_lo_dout;
               next_state = push_return_hi_state;
            end

	  //--
	  //-- push program counter hi byte onto the stack
	  //-- (sp) = pc_hi
	  //-- sp = sp
	  //-- return to originating state
	  //--
          push_return_hi_state:
            begin 
               //-- write pc hi bytes
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_hi_dout;
               st_ctrl = pull_st;
               next_state = saved_state;
            end

          pull_return_hi_state:
            begin 
               //-- increment the sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read pc hi
               pc_ctrl = pull_hi_pc;
               addr_ctrl = pulls_ad;
               next_state = pull_return_lo_state;
            end

          pull_return_lo_state:
            begin 
               //-- increment the SP
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read pc low
               pc_ctrl = pull_lo_pc;
               addr_ctrl = pulls_ad;
               dout_ctrl = pc_lo_dout;
	       //--
               st_ctrl = pull_st;
               next_state = saved_state;
            end
          andcc_state:
            //-- AND CC with md
            begin 
               left_ctrl = md_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_andcc;
               cc_ctrl = load_cc;
	       //--
               st_ctrl = pull_st;
               next_state = saved_state;
            end
          orcc_state:
            //-- OR CC with md
            begin 
               left_ctrl = md_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_orcc;
               cc_ctrl = load_cc;
	       //--
               st_ctrl = pull_st;
               next_state = saved_state;
            end
          tfr_state:
            begin 
               //-- select source register
               case (md[7:4])
                 4'b0000:
                   left_ctrl = accd_left;
                 4'b0001:
                   left_ctrl = ix_left;
                 4'b0010:
                   left_ctrl = iy_left;
                 4'b0011:
                   left_ctrl = up_left;
                 4'b0100:
                   left_ctrl = sp_left;
                 4'b0101:
                   left_ctrl = pc_left;
                 4'b1000:
                   left_ctrl = acca_left;
                 4'b1001:
                   left_ctrl = accb_left;
                 4'b1010:
                   left_ctrl = cc_left;
                 4'b1011:
                   left_ctrl = dp_left;
                 default:
                   left_ctrl = md_left;
               endcase
               right_ctrl = zero_right;
               alu_ctrl = alu_tfr;
               //-- select destination register
               case (md[3:0])
                 4'b0000: // accd
                   begin 
                      acca_ctrl = load_hi_acca;
                      accb_ctrl = load_accb;
                   end
                 4'b0001: // ix
                   ix_ctrl = load_ix;
                 4'b0010: // iy
                   iy_ctrl = load_iy;
                 4'b0011: // up
                   up_ctrl = load_up;
                 4'b0100: // sp
                   sp_ctrl = load_sp;
                 4'b0101: // pc
                   pc_ctrl = load_pc;
                 4'b1000: // acca
                   acca_ctrl = load_acca;
                 4'b1001: // accb
                   accb_ctrl = load_accb;
                 4'b1010: // cc
                   cc_ctrl = load_cc;
                 4'b1011: // dp
                   dp_ctrl = load_dp;
                 default:
                   ;//null
               endcase
	       //--
               st_ctrl = pull_st;
               next_state = saved_state;
            end

          exg_state:
            begin 
               //-- save destination register
               case (md[3:0])
                 4'b0000:
                   left_ctrl = accd_left;
                 4'b0001:
                   left_ctrl = ix_left;
                 4'b0010:
                   left_ctrl = iy_left;
                 4'b0011:
                   left_ctrl = up_left;
                 4'b0100:
                   left_ctrl = sp_left;
                 4'b0101:
                   left_ctrl = pc_left;
                 4'b1000:
                   left_ctrl = acca_left;
                 4'b1001:
                   left_ctrl = accb_left;
                 4'b1010:
                   left_ctrl = cc_left;
                 4'b1011:
                   left_ctrl = dp_left;
                 default:
                   left_ctrl = md_left;
               endcase
               right_ctrl = zero_right;
               alu_ctrl = alu_tfr;
               ea_ctrl = load_ea;
               //-- call tranfer microcode
               st_ctrl = push_st;
               return_state = exg1_state;
               next_state = tfr_state;
            end

          exg1_state:
            begin 
               //-- restore destination
               left_ctrl = ea_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_tfr;
               //-- save as source register
               case (md[7:4])
                 4'b0000: // accd
                   begin 
                      acca_ctrl = load_hi_acca;
                      accb_ctrl = load_accb;
                   end
                 4'b0001: // ix
                   ix_ctrl = load_ix;
                 4'b0010: // iy
                   iy_ctrl = load_iy;
                 4'b0011: // up
                   up_ctrl = load_up;
                 4'b0100: // sp
                   sp_ctrl = load_sp;
                 4'b0101: // pc
                   pc_ctrl = load_pc;
                 4'b1000: // acca
                   acca_ctrl = load_acca;
                 4'b1001: // accb
                   accb_ctrl = load_accb;
                 4'b1010: // cc
                   cc_ctrl = load_cc;
                 4'b1011: // dp
                   dp_ctrl = load_dp;
                 default:
                   ;//null
               endcase
               next_state = fetch_state;
            end

          mul_state:
            begin 
               //-- move acca to md
               left_ctrl = acca_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_st16;
               md_ctrl = load_md;
               next_state = mulea_state;
            end

          mulea_state:
            begin 
               //-- move accb to ea
               left_ctrl = accb_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_st16;
               ea_ctrl = load_ea;
               next_state = muld_state;
            end

          muld_state:
            begin 
               //-- clear accd
               left_ctrl = acca_left;
               right_ctrl = zero_right;
               alu_ctrl = alu_ld8;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               next_state = mul0_state;
            end

          mul0_state:
            begin 
               //-- if bit 0 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[0])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul1_state;
            end

          mul1_state:
            begin 
               //-- if bit 1 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[1]) 
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul2_state;
            end

          mul2_state:
            begin 
               //-- if bit 2 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[2])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul3_state;
            end

          mul3_state:
            begin 
               //-- if bit 3 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[3])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul4_state;
            end

          mul4_state:
            begin 
               //-- if bit 4 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[4])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul5_state;
            end

          mul5_state:
            begin 
               //-- if bit 5 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[5])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul6_state;
            end

          mul6_state:
            begin 
               //-- if bit 6 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[6])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = mul7_state;
            end

          mul7_state:
            begin 
               //-- if bit 7 of ea set, add accd to md
               left_ctrl = accd_left;
               if (ea[7])
                 right_ctrl = md_right;
               else 
                 right_ctrl = zero_right;

               alu_ctrl = alu_mul;
               cc_ctrl = load_cc;
               acca_ctrl = load_hi_acca;
               accb_ctrl = load_accb;
               md_ctrl = shiftl_md;
               next_state = fetch_state;
            end

	  //--
	  //-- Enter here on pushs
	  //-- ea holds post byte
	  //--
          pshs_state:
            begin 
               //-- decrement sp if any registers to be pushed
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               //-- idle	address
               addr_ctrl = idle_ad;
               dout_ctrl = cc_dout;
               if ((ea[7:0] == 8'b00000000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               if (ea[7]) 
                 next_state = pshs_pcl_state;
               else if (ea[6]) 
                 next_state = pshs_upl_state;
               else if (ea[5]) 
                 next_state = pshs_iyl_state;
               else if (ea[4]) 
                 next_state = pshs_ixl_state;
               else if (ea[3]) 
                 next_state = pshs_dp_state;
               else if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_pcl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write pc low
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_lo_dout;
               next_state = pshs_pch_state;
            end

          pshs_pch_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[6:0] == 7'b0000000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write pc hi
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_hi_dout;
               if (ea[6]) 
                 next_state = pshs_upl_state;
               else if (ea[5]) 
                 next_state = pshs_iyl_state;
               else if (ea[4]) 
                 next_state = pshs_ixl_state;
               else if (ea[3]) 
                 next_state = pshs_dp_state;
               else if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end


          pshs_upl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write pc low
               addr_ctrl = pushs_ad;
               dout_ctrl = up_lo_dout;
               next_state = pshs_uph_state;
            end

          pshs_uph_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[5:0] == 6'b000000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write pc hi
               addr_ctrl = pushs_ad;
               dout_ctrl = up_hi_dout;
               if (ea[5]) 
                 next_state = pshs_iyl_state;
               else if (ea[4]) 
                 next_state = pshs_ixl_state;
               else if (ea[3]) 
                 next_state = pshs_dp_state;
               else if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_iyl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write iy low
               addr_ctrl = pushs_ad;
               dout_ctrl = iy_lo_dout;
               next_state = pshs_iyh_state;
            end

          pshs_iyh_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[4:0] == 5'b00000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write iy hi
               addr_ctrl = pushs_ad;
               dout_ctrl = iy_hi_dout;
               if (ea[4]) 
                 next_state = pshs_ixl_state;
               else if (ea[3]) 
                 next_state = pshs_dp_state;
               else if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshs_ixl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write ix low
               addr_ctrl = pushs_ad;
               dout_ctrl = ix_lo_dout;
               next_state = pshs_ixh_state;
            end

          pshs_ixh_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[3:0] == 4'b0000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write ix hi
               addr_ctrl = pushs_ad;
               dout_ctrl = ix_hi_dout;
               if (ea[3]) 
                 next_state = pshs_dp_state;
               else if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_dp_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[2:0] == 3'b000)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write dp
               addr_ctrl = pushs_ad;
               dout_ctrl = dp_dout;
               if (ea[2]) 
                 next_state = pshs_accb_state;
               else if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_accb_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[1:0] == 2'b00)) 
                 sp_ctrl = latch_sp;
               else 
                 sp_ctrl = load_sp;

               //-- write accb
               addr_ctrl = pushs_ad;
               dout_ctrl = accb_dout;
               if (ea[1]) 
                 next_state = pshs_acca_state;
               else if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_acca_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if (ea[0]) 
                 sp_ctrl = load_sp;
               else 
                 sp_ctrl = latch_sp;

               //-- write acca
               addr_ctrl = pushs_ad;
               dout_ctrl = acca_dout;
               if (ea[0]) 
                 next_state = pshs_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshs_cc_state:
            begin 
               //-- idle sp
               //-- write cc
               addr_ctrl = pushs_ad;
               dout_ctrl = cc_dout;
               next_state = fetch_state;
            end

	  //--
	  //-- enter here on PULS
	  //-- ea hold register mask
	  //--
          puls_state:
            if (ea[0]) 
              next_state = puls_cc_state;
            else if (ea[1]) 
              next_state = puls_acca_state;
            else if (ea[2]) 
              next_state = puls_accb_state;
            else if (ea[3]) 
              next_state = puls_dp_state;
            else if (ea[4]) 
              next_state = puls_ixh_state;
            else if (ea[5]) 
              next_state = puls_iyh_state;
            else if (ea[6]) 
              next_state = puls_uph_state;
            else if (ea[7]) 
              next_state = puls_pch_state;
            else 
              next_state = fetch_state;

          puls_cc_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read cc
               cc_ctrl = pull_cc;
               addr_ctrl = pulls_ad;
               if (ea[1]) 
                 next_state = puls_acca_state;
               else if (ea[2]) 
                 next_state = puls_accb_state;
               else if (ea[3]) 
                 next_state = puls_dp_state;
               else if (ea[4]) 
                 next_state = puls_ixh_state;
               else if (ea[5]) 
                 next_state = puls_iyh_state;
               else if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;

               
            end

          puls_acca_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read acca
               acca_ctrl = pull_acca;
               addr_ctrl = pulls_ad;
               if (ea[2]) 
                 next_state = puls_accb_state;
               else if (ea[3]) 
                 next_state = puls_dp_state;
               else if (ea[4]) 
                 next_state = puls_ixh_state;
               else if (ea[5]) 
                 next_state = puls_iyh_state;
               else if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;
            end

          puls_accb_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read accb
               accb_ctrl = pull_accb;
               addr_ctrl = pulls_ad;
               if (ea[3]) 
                 next_state = puls_dp_state;
               else if (ea[4]) 
                 next_state = puls_ixh_state;
               else if (ea[5]) 
                 next_state = puls_iyh_state;
               else if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;
            end

          puls_dp_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read dp
               dp_ctrl = pull_dp;
               addr_ctrl = pulls_ad;
               if (ea[4]) 
                 next_state = puls_ixh_state;
               else if (ea[5]) 
                 next_state = puls_iyh_state;
               else if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;

               
            end

          puls_ixh_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
	       //-- pull ix hi
               ix_ctrl = pull_hi_ix;
               addr_ctrl = pulls_ad;
               next_state = puls_ixl_state;
            end

          puls_ixl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read ix low
               ix_ctrl = pull_lo_ix;
               addr_ctrl = pulls_ad;
               if (ea[5]) 
                 next_state = puls_iyh_state;
               else if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;

               
            end

          puls_iyh_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- pull iy hi
               iy_ctrl = pull_hi_iy;
               addr_ctrl = pulls_ad;
               next_state = puls_iyl_state;
            end

          puls_iyl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read iy low
               iy_ctrl = pull_lo_iy;
               addr_ctrl = pulls_ad;
               if (ea[6]) 
                 next_state = puls_uph_state;
               else if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;

               
            end

          puls_uph_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- pull up hi
               up_ctrl = pull_hi_up;
               addr_ctrl = pulls_ad;
               next_state = puls_upl_state;
            end

          puls_upl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read up low
               up_ctrl = pull_lo_up;
               addr_ctrl = pulls_ad;
               if (ea[7]) 
                 next_state = puls_pch_state;
               else 
                 next_state = fetch_state;

               
            end

          puls_pch_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
	       //-- pull pc hi
               pc_ctrl = pull_hi_pc;
               addr_ctrl = pulls_ad;
               next_state = puls_pcl_state;
            end

          puls_pcl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read pc low
               pc_ctrl = pull_lo_pc;
               addr_ctrl = pulls_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- Enter here on pshu
	  //-- ea holds post byte
	  //--
          pshu_state:
            begin 
               //-- decrement up if any registers to be pushed
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[7:0] == 8'b00000000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write idle bus
               if (ea[7]) 
                 next_state = pshu_pcl_state;
               else if (ea[6]) 
                 next_state = pshu_spl_state;
               else if (ea[5]) 
                 next_state = pshu_iyl_state;
               else if (ea[4]) 
                 next_state = pshu_ixl_state;
               else if (ea[3]) 
                 next_state = pshu_dp_state;
               else if (ea[2]) 
                 next_state = pshu_accb_state;
               else if (ea[1]) 
                 next_state = pshu_acca_state;
               else if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end
	  //--
	  //-- push PC onto U stack
	  //--
          pshu_pcl_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               up_ctrl = load_up;
               //-- write pc low
               addr_ctrl = pushu_ad;
               dout_ctrl = pc_lo_dout;
               next_state = pshu_pch_state;
            end

          pshu_pch_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[6:0] == 7'b0000000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write pc hi
               addr_ctrl = pushu_ad;
               dout_ctrl = pc_hi_dout;
               if (ea[6]) 
                 next_state = pshu_spl_state;
               else if (ea[5]) 
                 next_state = pshu_iyl_state;
               else if (ea[4]) 
                 next_state = pshu_ixl_state;
               else if (ea[3]) 
                 next_state = pshu_dp_state;
               else if (ea[2]) 
                 next_state = pshu_accb_state;
               else if (ea[1]) 
                 next_state = pshu_acca_state;
               else if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshu_spl_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               up_ctrl = load_up;
               //-- write sp low
               addr_ctrl = pushu_ad;
               dout_ctrl = sp_lo_dout;
               next_state = pshu_sph_state;
            end

          pshu_sph_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[5:0] == 6'b000000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write sp hi
               addr_ctrl = pushu_ad;
               dout_ctrl = sp_hi_dout;
               if (ea[5]) 
                 next_state = pshu_iyl_state;
               else if (ea[4]) 
                 next_state = pshu_ixl_state;
               else if (ea[3]) 
                 next_state = pshu_dp_state;
               else if (ea[2]) 
                 next_state = pshu_accb_state;
               else if (ea[1]) 
                 next_state = pshu_acca_state;
               else if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshu_iyl_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               up_ctrl = load_up;
               //-- write iy low
               addr_ctrl = pushu_ad;
               dout_ctrl = iy_lo_dout;
               next_state = pshu_iyh_state;
            end

          pshu_iyh_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[4:0] == 5'b00000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write iy hi
               addr_ctrl = pushu_ad;
               dout_ctrl = iy_hi_dout;
               if (ea[4]) 
                 next_state = pshu_ixl_state;
               else if (ea[3]) 
                 next_state = pshu_dp_state;
               else if (ea[2]) 
                 next_state = pshu_accb_state;
               else if (ea[1]) 
                 next_state = pshu_acca_state;
               else if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshu_ixl_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               up_ctrl = load_up;
               //-- write ix low
               addr_ctrl = pushu_ad;
               dout_ctrl = ix_lo_dout;
               next_state = pshu_ixh_state;
            end

          pshu_ixh_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[3:0] == 4'b0000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write ix hi
               addr_ctrl = pushu_ad;
               dout_ctrl = ix_hi_dout;
               if (ea[3]) 
                 next_state = pshu_dp_state;
               else if (ea[2]) 
                 next_state = pshu_accb_state;
               else if (ea[1]) 
                 next_state = pshu_acca_state;
               else if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;

               
            end

          pshu_dp_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[2:0] == 3'b000)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write dp
               addr_ctrl = pushu_ad;
               dout_ctrl = dp_dout;
               if (ea[2])
                 next_state = pshu_accb_state;
               else if (ea[1])
                 next_state = pshu_acca_state;
               else if (ea[0])
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshu_accb_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[1:0] == 2'b00)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write accb
               addr_ctrl = pushu_ad;
               dout_ctrl = accb_dout;
               if (ea[1])
                 next_state = pshu_acca_state;
               else if (ea[0])
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end

          pshu_acca_state:
            begin 
               //-- decrement up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               if ((ea[0] == 1'b0)) 
                 up_ctrl = latch_up;
               else 
                 up_ctrl = load_up;

               //-- write acca
               addr_ctrl = pushu_ad;
               dout_ctrl = acca_dout;
               if (ea[0]) 
                 next_state = pshu_cc_state;
               else 
                 next_state = fetch_state;
            end
          pshu_cc_state:
            begin 
               //-- idle up
               //-- write cc
               addr_ctrl = pushu_ad;
               dout_ctrl = cc_dout;
               next_state = fetch_state;
            end

	  //--
	  //-- enter here on PULU
	  //-- ea hold register mask
	  //--
          pulu_state:
            //-- idle UP
            //-- idle bus
            if (ea[0]) 
              next_state = pulu_cc_state;
            else if (ea[1]) 
              next_state = pulu_acca_state;
            else if (ea[2]) 
              next_state = pulu_accb_state;
            else if (ea[3]) 
              next_state = pulu_dp_state;
            else if (ea[4]) 
              next_state = pulu_ixh_state;
            else if (ea[5]) 
              next_state = pulu_iyh_state;
            else if (ea[6]) 
              next_state = pulu_sph_state;
            else if (ea[7]) 
              next_state = pulu_pch_state;
            else 
              next_state = fetch_state;
          
          pulu_cc_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read cc
               cc_ctrl = pull_cc;
               addr_ctrl = pullu_ad;
               if (ea[1]) 
                 next_state = pulu_acca_state;
               else if (ea[2]) 
                 next_state = pulu_accb_state;
               else if (ea[3]) 
                 next_state = pulu_dp_state;
               else if (ea[4]) 
                 next_state = pulu_ixh_state;
               else if (ea[5]) 
                 next_state = pulu_iyh_state;
               else if (ea[6]) 
                 next_state = pulu_sph_state;
               else if (ea[7]) 
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_acca_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read acca
               acca_ctrl = pull_acca;
               addr_ctrl = pullu_ad;
               if (ea[2]) 
                 next_state = pulu_accb_state;
               else if (ea[3]) 
                 next_state = pulu_dp_state;
               else if (ea[4]) 
                 next_state = pulu_ixh_state;
               else if (ea[5]) 
                 next_state = pulu_iyh_state;
               else if (ea[6]) 
                 next_state = pulu_sph_state;
               else if (ea[7]) 
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_accb_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read accb
               accb_ctrl = pull_accb;
               addr_ctrl = pullu_ad;
               if (ea[3])
                 next_state = pulu_dp_state;
               else if (ea[4])
                 next_state = pulu_ixh_state;
               else if (ea[5])
                 next_state = pulu_iyh_state;
               else if (ea[6])
                 next_state = pulu_sph_state;
               else if (ea[7])
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_dp_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read dp
               dp_ctrl = pull_dp;
               addr_ctrl = pullu_ad;
               if (ea[4])
                 next_state = pulu_ixh_state;
               else if (ea[5])
                 next_state = pulu_iyh_state;
               else if (ea[6])
                 next_state = pulu_sph_state;
               else if (ea[7])
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_ixh_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read ix hi
               ix_ctrl = pull_hi_ix;
               addr_ctrl = pullu_ad;
               next_state = pulu_ixl_state;
            end

          pulu_ixl_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read ix low
               ix_ctrl = pull_lo_ix;
               addr_ctrl = pullu_ad;
               if (ea[5])
                 next_state = pulu_iyh_state;
               else if (ea[6])
                 next_state = pulu_sph_state;
               else if (ea[7])
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_iyh_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read iy hi
               iy_ctrl = pull_hi_iy;
               addr_ctrl = pullu_ad;
               next_state = pulu_iyl_state;
            end

          pulu_iyl_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read iy low
               iy_ctrl = pull_lo_iy;
               addr_ctrl = pullu_ad;
               if (ea[6])
                 next_state = pulu_sph_state;
               else if (ea[7])
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_sph_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read sp hi
               sp_ctrl = pull_hi_sp;
               addr_ctrl = pullu_ad;
               next_state = pulu_spl_state;
            end

          pulu_spl_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read sp low
               sp_ctrl = pull_lo_sp;
               addr_ctrl = pullu_ad;
               if (ea[7])
                 next_state = pulu_pch_state;
               else 
                 next_state = fetch_state;
            end

          pulu_pch_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- pull pc hi
               pc_ctrl = pull_hi_pc;
               addr_ctrl = pullu_ad;
               next_state = pulu_pcl_state;
            end

          pulu_pcl_state:
            begin 
               //-- increment up
               left_ctrl = up_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               up_ctrl = load_up;
               //-- read pc low
               pc_ctrl = pull_lo_pc;
               addr_ctrl = pullu_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- pop the Condition codes
	  //--
          rti_cc_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read cc
               cc_ctrl = pull_cc;
               addr_ctrl = pulls_ad;
               next_state = rti_entire_state;
            end

	  //--
	  //-- Added RTI cycle 11th July 2006 John Kent.
	  //-- test the "Entire" Flag
	  //-- that has just been popped off the stack
	  //--
          rti_entire_state:
            //--
            //-- The Entire flag must be recovered from the stack
            //-- before testing.
            //--
            if (cc[EBIT])
              next_state = rti_acca_state;
            else 
              next_state = rti_pch_state;
          
          rti_acca_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read acca
               acca_ctrl = pull_acca;
               addr_ctrl = pulls_ad;
               next_state = rti_accb_state;
            end

          rti_accb_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read accb
               accb_ctrl = pull_accb;
               addr_ctrl = pulls_ad;
               next_state = rti_dp_state;
            end

          rti_dp_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read dp
               dp_ctrl = pull_dp;
               addr_ctrl = pulls_ad;
               next_state = rti_ixh_state;
            end

          rti_ixh_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read ix hi
               ix_ctrl = pull_hi_ix;
               addr_ctrl = pulls_ad;
               next_state = rti_ixl_state;
            end

          rti_ixl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read ix low
               ix_ctrl = pull_lo_ix;
               addr_ctrl = pulls_ad;
               next_state = rti_iyh_state;
            end

          rti_iyh_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read iy hi
               iy_ctrl = pull_hi_iy;
               addr_ctrl = pulls_ad;
               next_state = rti_iyl_state;
            end

          rti_iyl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read iy low
               iy_ctrl = pull_lo_iy;
               addr_ctrl = pulls_ad;
               next_state = rti_uph_state;
            end

          rti_uph_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read up hi
               up_ctrl = pull_hi_up;
               addr_ctrl = pulls_ad;
               next_state = rti_upl_state;
            end

          rti_upl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- read up low
               up_ctrl = pull_lo_up;
               addr_ctrl = pulls_ad;
               next_state = rti_pch_state;
            end

          rti_pch_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- pull pc hi
               pc_ctrl = pull_hi_pc;
               addr_ctrl = pulls_ad;
               next_state = rti_pcl_state;
            end

          rti_pcl_state:
            begin 
               //-- increment sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_add16;
               sp_ctrl = load_sp;
               //-- pull pc low
               pc_ctrl = pull_lo_pc;
               addr_ctrl = pulls_ad;
               next_state = fetch_state;
            end

	  //--
	  //-- here on IRQ or NMI interrupt
	  //-- pre decrement the sp
	  //-- Idle bus cycle
	  //--
          int_nmiirq_state:
            begin 
	       //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               next_state = int_entire_state;
            end

	  //--
	  //-- set Entire Flag on SWI, SWI2, SWI3 and CWAI, IRQ and NMI
	  //-- clear Entire Flag on FIRQ
	  //-- before stacking all registers
	  //--
          int_entire_state:
            begin 
	       //-- set entire flag
               alu_ctrl = alu_see;
               cc_ctrl = load_cc;
               next_state = int_pcl_state;
            end

	  //--
	  //-- here on FIRQ interrupt
	  //-- pre decrement the sp
	  //-- Idle bus cycle
	  //--
          int_firq_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               next_state = int_fast_state;
            end

	  //--
	  //-- clear Entire Flag on FIRQ
	  //-- before stacking all registers
	  //--
          int_fast_state:
            begin 
               //-- clear entire flag
               alu_ctrl = alu_cle;
               cc_ctrl = load_cc;
               next_state = int_pcl_state;
            end

          int_pcl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write pc low
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_lo_dout;
               next_state = int_pch_state;
            end
          int_pch_state:
            begin 
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write pc hi
               addr_ctrl = pushs_ad;
               dout_ctrl = pc_hi_dout;
               if (cc[EBIT])
                 next_state = int_upl_state;
               else 
                 next_state = int_cc_state;
            end

          int_upl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write up low
               addr_ctrl = pushs_ad;
               dout_ctrl = up_lo_dout;
               next_state = int_uph_state;
            end

          int_uph_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write up hi
               addr_ctrl = pushs_ad;
               dout_ctrl = up_hi_dout;
               next_state = int_iyl_state;
            end

          int_iyl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write iy low
               addr_ctrl = pushs_ad;
               dout_ctrl = iy_lo_dout;
               next_state = int_iyh_state;
            end

          int_iyh_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write iy hi
               addr_ctrl = pushs_ad;
               dout_ctrl = iy_hi_dout;
               next_state = int_ixl_state;
            end

          int_ixl_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write ix low
               addr_ctrl = pushs_ad;
               dout_ctrl = ix_lo_dout;
               next_state = int_ixh_state;
            end

          int_ixh_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write ix hi
               addr_ctrl = pushs_ad;
               dout_ctrl = ix_hi_dout;
               next_state = int_dp_state;
            end

          int_dp_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write dp
               addr_ctrl = pushs_ad;
               dout_ctrl = dp_dout;
               next_state = int_accb_state;
            end

          int_accb_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write accb
               addr_ctrl = pushs_ad;
               dout_ctrl = accb_dout;
               next_state = int_acca_state;
            end

          int_acca_state:
            begin 
               //-- decrement sp
               left_ctrl = sp_left;
               right_ctrl = one_right;
               alu_ctrl = alu_sub16;
               sp_ctrl = load_sp;
               //-- write acca
               addr_ctrl = pushs_ad;
               dout_ctrl = acca_dout;
               next_state = int_cc_state;
            end

          int_cc_state:
            begin 
               //-- write cc
               addr_ctrl = pushs_ad;
               dout_ctrl = cc_dout;
               case (iv)
                 NMI_VEC:
                   next_state = int_maskif_state;
                 SWI_VEC:
                   next_state = int_maskif_state;
                 FIRQ_VEC:
                   next_state = int_maskif_state;
                 IRQ_VEC:
                   next_state = int_maski_state;
                 SWI2_VEC:
                   next_state = vect_hi_state;
                 SWI3_VEC:
                   next_state = vect_hi_state;
                 default:
                   if (op_code == 8'b00111100)  // CWAI
                     next_state = int_cwai_state;
                   else 
                     next_state = rti_cc_state; // spurious interrupt, do an RTI
               endcase
            end

	  //--
	  //-- wait here for an inteerupt
	  //--
          int_cwai_state:
            if (nmi_req && nmi_ack == 1'b0)
              begin 
                 iv_ctrl = nmi_iv;
                 nmi_ctrl = set_nmi;
                 next_state = int_maskif_state;
              end
            else 
              begin 
		 //--
		 //-- nmi request is not cleared until nmi input goes low
                 //--
                 if (nmi_req == 1'b0 && nmi_ack)
                   nmi_ctrl = reset_nmi;

		 //--
		 //-- FIRQ is level sensitive
		 //--
                 if (firq && cc[FBIT] == 1'b0)
                   begin 
                      iv_ctrl = firq_iv;
                      next_state = int_maskif_state;
                   end
                 else
		   //--
		   //-- IRQ is level sensitive
		   //--
		   if (irq & cc[IBIT] == 1'b0)
                     begin 
                        iv_ctrl = irq_iv;
                        next_state = int_maski_state;
                     end
                   else 
                     begin 
                        iv_ctrl = reset_iv;
                        next_state = int_cwai_state;
                     end
              end 
          
          int_maski_state:
            begin 
               alu_ctrl = alu_sei;
               cc_ctrl = load_cc;
               next_state = vect_hi_state;
            end

          int_maskif_state:
            begin 
               alu_ctrl = alu_seif;
               cc_ctrl = load_cc;
               next_state = vect_hi_state;
            end

	  //--
	  //-- According to the 6809 programming manual:
	  //-- If an interrupt is received and is masked 
	  //-- or lasts for less than three cycles, the PC 
	  //-- will advance to the next instruction.
	  //-- If an interrupt is unmasked and lasts
	  //-- for more than three cycles, an interrupt
	  //-- will be generated.
	  //-- Note that I don't wait 3 clock cycles.
	  //-- John Kent 11th July 2006
	  //--
          sync_state:
            if (nmi_req && nmi_ack == 1'b0)
              begin 
                 iv_ctrl = nmi_iv;
                 nmi_ctrl = set_nmi;
                 next_state = int_nmiirq_state;
              end
            else 
              begin 
		 //--
		 //-- nmi request is not cleared until nmi input goes low
                 //--
                 if (nmi_req == 1'b0 && nmi_ack)
                   begin 
                      iv_ctrl = reset_iv;
                      nmi_ctrl = reset_nmi;
                   end

		 //--
		 //-- FIRQ is level sensitive
		 //--
                 if (firq)
                   begin 
                      if ((cc[FBIT] == 1'b0)) 
                        begin 
                           iv_ctrl = firq_iv;
                           next_state = int_firq_state;
                        end
                      else 
                        begin 
                           iv_ctrl = reset_iv;
                           next_state = fetch_state;
                        end

                      
                   end 
                 else
		   //--
		   //-- IRQ is level sensitive
		   //--
		   if (irq)
                     begin 
                        if ((cc[IBIT] == 1'b0)) 
                          begin 
                             iv_ctrl = irq_iv;
                             next_state = int_nmiirq_state;
                          end
                        else 
                          begin 
                             iv_ctrl = reset_iv;
                             next_state = fetch_state;
                          end
                     end 
                   else 
                     begin 
                        iv_ctrl = reset_iv;
                        next_state = sync_state;
                     end
              end 
          
          halt_state:
            if (halt)
              next_state = halt_state;
            else 
              next_state = fetch_state;

          default: // halt on undefined states
            next_state = error_state;
        endcase
     end 

   assign halted = state == halt_state;

   // generate BA & BS signals
   always @(negedge clk or posedge rst)
     if (rst)
       begin
	  ba <= 1'b0;
	  bs <= 1'b0;
       end
     else
       begin
          case (next_state)
            // halt ack
            halt_state:
	      begin
		 ba <= 1'b1;
		 bs <= 1'b1;
	      end
            // sync ack
            sync_state:
	      begin
		 ba <= 1'b1;
		 bs <= 1'b0;
	      end
            // irq/rst ack
            reset_state, int_maski_state, vect_hi_state:
	      begin
		 ba <= 1'b0;
		 bs <= 1'b1;
	      end
            // normal
	    default:
	      begin
		 ba <= 1'b0;
		 bs <= 1'b0;
	      end
          endcase
       end

   assign ba_out = ba;
   assign bs_out = bs;
   
endmodule
