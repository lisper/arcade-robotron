// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Primary design header
//
// This header should be included by all source files instantiating the design.
// The class here is then constructed to instantiate the design.
// See the Verilator manual for examples.

#ifndef _Vrobotron_verilator_H_
#define _Vrobotron_verilator_H_

#include "verilated.h"
class Vrobotron_verilator__Syms;
class VerilatedVcd;

//----------

VL_MODULE(Vrobotron_verilator) {
  public:
    // CELLS
    // Public to allow access to /*verilator_public*/ items;
    // otherwise the application code can consider these internals.
    
    // PORTS
    // The application code writes and reads these signals to
    // propagate new values into/out from the Verilated model.
    
    // LOCAL SIGNALS
    // Internals; generally not touched by application code
    VL_SIG8(v__DOT__clk25,0,0);
    VL_SIG8(v__DOT__clk12,0,0);
    VL_SIG8(v__DOT__cpu_reset,0,0);
    VL_SIG8(v__DOT__uut__DOT__reset,0,0);
    VL_SIG8(v__DOT__uut__DOT__clock_e,0,0);
    VL_SIG8(v__DOT__CLK,0,0);
    VL_SIG8(v__DOT__RESET_N,0,0);
    VL_SIG8(v__DOT__NMI_N,0,0);
    VL_SIG8(v__DOT__FIRQ_N,0,0);
    VL_SIG8(v__DOT__IRQ_N,0,0);
    VL_SIG8(v__DOT__HALT_N,0,0);
    VL_SIG8(v__DOT__LIC,0,0);
    VL_SIG8(v__DOT__AVMA,0,0);
    VL_SIG8(v__DOT__BUSY,0,0);
    VL_SIG8(v__DOT__RamWait,0,0);
    VL_SIG8(v__DOT__FlashStSts,0,0);
    VL_SIG8(v__DOT__SW,7,0);
    VL_SIG8(v__DOT__BTN,3,0);
    VL_SIG8(v__DOT__ja,7,0);
    VL_SIG8(v__DOT__jb,7,0);
    VL_SIG8(v__DOT__dac,7,0);
    VL_SIG8(v__DOT__cpu_vma,0,0);
    VL_SIG8(v__DOT__cpu_rw,0,0);
    VL_SIG8(v__DOT__uut__DOT__reset_counter,7,0);
    VL_SIG8(v__DOT__uut__DOT__clock_50m_0,0,0);
    VL_SIG8(v__DOT__uut__DOT__clock_50m_fb,0,0);
    VL_SIG8(v__DOT__uut__DOT__clock_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__video_blank,0,0);
    VL_SIG8(v__DOT__uut__DOT__vga_red,2,0);
    VL_SIG8(v__DOT__uut__DOT__vga_green,2,0);
    VL_SIG8(v__DOT__uut__DOT__vga_blue,2,0);
    VL_SIG8(v__DOT__uut__DOT__write,0,0);
    VL_SIG8(v__DOT__uut__DOT__read,0,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_data_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_data_out,7,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_bus_status,0,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_bus_available,0,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_read,0,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_write,0,0);
    VL_SIG8(v__DOT__uut__DOT__mpu_halted,0,0);
    VL_SIG8(v__DOT__uut__DOT__memory_data_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__memory_data_out,7,0);
    VL_SIG8(v__DOT__uut__DOT__memory_output_enable,0,0);
    VL_SIG8(v__DOT__uut__DOT__memory_write,0,0);
    VL_SIG8(v__DOT__uut__DOT__flash_enable,0,0);
    VL_SIG8(v__DOT__uut__DOT__ram_enable,0,0);
    VL_SIG8(v__DOT__uut__DOT__ram_lower_enable,0,0);
    VL_SIG8(v__DOT__uut__DOT__ram_upper_enable,0,0);
    VL_SIG8(v__DOT__uut__DOT__e_rom,0,0);
    VL_SIG8(v__DOT__uut__DOT__screen_control,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__ram_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia_rs,1,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia_cs,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia_write,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia_data_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia_pa_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_led_digit,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia_rs,1,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia_cs,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia_write,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia_data_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia_pa_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_ic3_y,4,1);
    VL_SIG8(v__DOT__uut__DOT__widget_ic4_y,4,1);
    VL_SIG8(v__DOT__uut__DOT__blt_rs,2,0);
    VL_SIG8(v__DOT__uut__DOT__blt_reg_cs,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt_reg_data_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__blt_blt_ack,0,0);
    VL_SIG8(v__DOT__uut__DOT__pixel_nibbles,7,0);
    VL_SIG8(v__DOT__uut__DOT__pixel_byte_l,7,0);
    VL_SIG8(v__DOT__uut__DOT__pixel_byte_h,7,0);
    VL_SIG8(v__DOT__uut__DOT__r_advance,1,0);
    VL_SIG8(v__DOT__uut__DOT__r_advance_video_count,0,0);
    VL_SIG8(v__DOT__uut__DOT__r_clear_video_count,0,0);
    VL_SIG8(v__DOT__uut__DOT__old_HAND,0,0);
    VL_SIG8(v__DOT__uut__DOT__old_PB,5,0);
    VL_SIG8(v__DOT__uut__DOT__old_BTN,3,0);
    VL_SIG8(v__DOT__uut__DOT__old_rom_pia_pa_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__old_widget_pia_pa_in,7,0);
    VL_SIG8(v__DOT__uut__DOT__r_hSync,0,0);
    VL_SIG8(v__DOT__uut__DOT__r_vSync,0,0);
    VL_SIG8(v__DOT__uut__DOT__r_vblank,0,0);
    VL_SIG8(v__DOT__uut__DOT__r_hblank,0,0);
    VL_SIG8(v__DOT__uut__DOT__n_hSync,0,0);
    VL_SIG8(v__DOT__uut__DOT__n_vSync,0,0);
    VL_SIG8(v__DOT__uut__DOT__hoffset,3,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__span_src,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__span_dst,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__synchronize_e,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__zero_write_suppress,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__constant_substitution,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__shift_right,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__suppress_lower,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__suppress_upper,0,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__constant_value,7,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__state,1,0);
    VL_SIG8(v__DOT__uut__DOT__blt__DOT__blt_src_data,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca1_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca2_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb1_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb2_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__output_a,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ddr_a,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cr_a_4,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cr_a_3,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__output_a_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca1_edge,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ca2_out_value,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__output_b,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__ddr_b,7,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cr_b_4,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cr_b_3,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__output_b_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb1_edge,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en,0,0);
    VL_SIG8(v__DOT__uut__DOT__rom_pia__DOT__cb2_out_value,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca1_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca2_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb1_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb2_q,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__output_a,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ddr_a,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cr_a_4,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cr_a_3,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__output_a_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca1_edge,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ca2_out_value,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__output_b,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__ddr_b,7,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cr_b_4,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cr_b_3,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__output_b_access,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb1_edge,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en,0,0);
    VL_SIG8(v__DOT__uut__DOT__widget_pia__DOT__cb2_out_value,0,0);
    VL_SIG8(v__DOT__cpu__DOT__alu___05Fvalid_lo,0,0);
    VL_SIG8(v__DOT__cpu__DOT__alu___05Fvalid_hi,0,0);
    VL_SIG8(v__DOT__cpu__DOT__alu___05Fcarry_in,0,0);
    VL_SIG8(v__DOT__cpu__DOT__alu___05Fdaa_reg,7,0);
    VL_SIG8(v__DOT__cpu__DOT__op_code,7,0);
    VL_SIG8(v__DOT__cpu__DOT__pre_code,7,0);
    VL_SIG8(v__DOT__cpu__DOT__acca,7,0);
    VL_SIG8(v__DOT__cpu__DOT__accb,7,0);
    VL_SIG8(v__DOT__cpu__DOT__cc,7,0);
    VL_SIG8(v__DOT__cpu__DOT__cc_out,7,0);
    VL_SIG8(v__DOT__cpu__DOT__dp,7,0);
    VL_SIG8(v__DOT__cpu__DOT__iv,2,0);
    VL_SIG8(v__DOT__cpu__DOT__nmi_req,0,0);
    VL_SIG8(v__DOT__cpu__DOT__nmi_ack,0,0);
    VL_SIG8(v__DOT__cpu__DOT__nmi_enable,0,0);
    VL_SIG8(v__DOT__cpu__DOT__state,7,0);
    VL_SIG8(v__DOT__cpu__DOT__next_state,7,0);
    VL_SIG8(v__DOT__cpu__DOT__saved_state,7,0);
    VL_SIG8(v__DOT__cpu__DOT__return_state,7,0);
    VL_SIG8(v__DOT__cpu__DOT__st_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__pc_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__ea_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__op_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__pre_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__md_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__acca_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__accb_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__ix_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__iy_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__cc_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__dp_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__sp_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__up_ctrl,2,0);
    VL_SIG8(v__DOT__cpu__DOT__iv_ctrl,3,0);
    VL_SIG8(v__DOT__cpu__DOT__left_ctrl,3,0);
    VL_SIG8(v__DOT__cpu__DOT__right_ctrl,3,0);
    VL_SIG8(v__DOT__cpu__DOT__alu_ctrl,5,0);
    VL_SIG8(v__DOT__cpu__DOT__addr_ctrl,3,0);
    VL_SIG8(v__DOT__cpu__DOT__dout_ctrl,3,0);
    VL_SIG8(v__DOT__cpu__DOT__nmi_ctrl,1,0);
    VL_SIG8(v__DOT__cpu__DOT__ba,0,0);
    VL_SIG8(v__DOT__cpu__DOT__bs,0,0);
    VL_SIG8(v__DOT__cpu__DOT__cond_true,0,0);
    VL_SIG8(v__DOT__mem__DOT__rom_data,7,0);
    VL_SIG16(v__DOT__MemDB_in,15,0);
    VL_SIG16(v__DOT__MemDB_out,15,0);
    VL_SIG16(v__DOT__cpu_addr,15,0);
    VL_SIG16(v__DOT__uut__DOT__clock_12_phase,11,0);
    VL_SIG16(v__DOT__uut__DOT__video_count,14,0);
    VL_SIG16(v__DOT__uut__DOT__video_count_next,14,0);
    VL_SIG16(v__DOT__uut__DOT__video_address,13,0);
    VL_SIG16(v__DOT__uut__DOT__led_counter,15,0);
    VL_SIG16(v__DOT__uut__DOT__address,15,0);
    VL_SIG16(v__DOT__uut__DOT__mpu_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__memory_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__debug_blt_source_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__debug_last_mpu_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__r_hCounter,11,0);
    VL_SIG16(v__DOT__uut__DOT__r_vCounter,11,0);
    VL_SIG16(v__DOT__uut__DOT__n_hCounter,11,0);
    VL_SIG16(v__DOT__uut__DOT__n_vCounter,11,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__src_base,15,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__dst_base,15,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__width,8,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__height,8,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__src_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__dst_address,15,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__x_count,8,0);
    VL_SIG16(v__DOT__uut__DOT__blt__DOT__y_count,8,0);
    VL_SIG16(v__DOT__uut__DOT__lb__DOT__r_data,8,0);
    VL_SIG16(v__DOT__cpu__DOT__xreg,15,0);
    VL_SIG16(v__DOT__cpu__DOT__yreg,15,0);
    VL_SIG16(v__DOT__cpu__DOT__sp,15,0);
    VL_SIG16(v__DOT__cpu__DOT__up,15,0);
    VL_SIG16(v__DOT__cpu__DOT__ea,15,0);
    VL_SIG16(v__DOT__cpu__DOT__pc,15,0);
    VL_SIG16(v__DOT__cpu__DOT__md,15,0);
    VL_SIG16(v__DOT__cpu__DOT__left,15,0);
    VL_SIG16(v__DOT__cpu__DOT__right,15,0);
    VL_SIG16(v__DOT__cpu__DOT__out_alu,15,0);
    VL_SIG16(v__DOT__mem__DOT__ram_out,15,0);
    VL_SIG(v__DOT__mem__DOT__i,31,0);
    //char	__VpadToAlign276[4];
    VL_SIG8(v__DOT__uut__DOT__color_table[16],7,0);
    VL_SIG16(v__DOT__uut__DOT__lb__DOT__line[2048],8,0);
    VL_SIG8(v__DOT__cpu__DOT__state_stack[3],7,0);
    //char	__VpadToAlign4395[5];
    VL_SIG8(v__DOT__mem__DOT__ramh[53248],7,0);
    VL_SIG8(v__DOT__mem__DOT__raml[53248],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom1[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom2[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom3[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom4[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom5[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom6[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom7[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom8[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__rom9[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__roma[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__romb[4096],7,0);
    VL_SIG8(v__DOT__mem__DOT__romc[4096],7,0);
    
    // LOCAL VARIABLES
    // Internals; generally not touched by application code
    static VL_ST_SIG8(__Vtable1_v__DOT__uut__DOT__hoffset[4096],3,0);
    static VL_ST_SIG8(__Vtable2_v__DOT__uut__DOT____Vcellinp__horizontal_decoder__data[512],7,0);
    static VL_ST_SIG8(__Vtable3_v__DOT__uut__DOT____Vcellinp__vertical_decoder__data[512],7,0);
    static VL_ST_SIG8(__Vtable4_v__DOT__cpu__DOT__iv[128],2,0);
    static VL_ST_SIG8(__Vtable5_v__DOT__cpu__DOT__ba[512],0,0);
    static VL_ST_SIG8(__Vtable5_v__DOT__cpu__DOT__bs[512],0,0);
    VL_SIG8(v__DOT__uut__DOT____Vcellinp__horizontal_decoder__data,7,0);
    VL_SIG8(v__DOT__uut__DOT____Vcellinp__vertical_decoder__data,7,0);
    VL_SIG8(v__DOT__mem__DOT____Vlvbound1,7,0);
    VL_SIG8(v__DOT__mem__DOT____Vlvbound2,7,0);
    VL_SIG8(v__DOT__mem__DOT____Vlvbound3,7,0);
    VL_SIG8(v__DOT__mem__DOT____Vlvbound4,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__pixel_byte_l,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__pixel_byte_h,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__pixel_nibbles,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__video_blank,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt_reg_cs,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt_blt_ack,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia_cs,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia_write,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia_cs,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia_write,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt_rs,2,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt_reg_data_in,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia_rs,1,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia_data_in,7,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia_rs,1,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia_data_in,7,0);
    VL_SIG8(__Vdlyvset__v__DOT__uut__DOT__color_table__v0,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__r_advance,1,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt__DOT__state,1,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt__DOT__span_src,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__blt__DOT__span_dst,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia__DOT__output_a_access,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__rom_pia__DOT__output_b_access,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia__DOT__output_a_access,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__widget_pia__DOT__output_b_access,0,0);
    VL_SIG8(__Vdly__v__DOT__uut__DOT__reset_counter,7,0);
    VL_SIG8(__Vdlyvset__v__DOT__uut__DOT__lb__DOT__line__v0,0,0);
    VL_SIG8(__Vdly__v__DOT__cpu__DOT__acca,7,0);
    VL_SIG8(__Vdly__v__DOT__cpu__DOT__accb,7,0);
    VL_SIG8(__Vdly__v__DOT__cpu__DOT__cc,7,0);
    VL_SIG8(__Vdly__v__DOT__cpu__DOT__dp,7,0);
    VL_SIG8(__VinpClk__TOP__v__DOT__clk12,0,0);
    VL_SIG8(__VinpClk__TOP__v__DOT__uut__DOT__reset,0,0);
    VL_SIG8(__VinpClk__TOP__v__DOT__clk25,0,0);
    VL_SIG8(__VinpClk__TOP__v__DOT__cpu_reset,0,0);
    VL_SIG8(__VinpClk__TOP__v__DOT__uut__DOT__clock_e,0,0);
    VL_SIG8(__Vclklast__TOP____VinpClk__TOP__v__DOT__clk12,0,0);
    VL_SIG8(__Vclklast__TOP____VinpClk__TOP__v__DOT__uut__DOT__reset,0,0);
    VL_SIG8(__Vclklast__TOP____VinpClk__TOP__v__DOT__clk25,0,0);
    VL_SIG8(__Vclklast__TOP____VinpClk__TOP__v__DOT__cpu_reset,0,0);
    VL_SIG8(__Vclklast__TOP____VinpClk__TOP__v__DOT__uut__DOT__clock_e,0,0);
    VL_SIG8(__Vchglast__TOP__v__DOT__clk25,0,0);
    VL_SIG8(__Vchglast__TOP__v__DOT__clk12,0,0);
    VL_SIG8(__Vchglast__TOP__v__DOT__cpu_reset,0,0);
    VL_SIG8(__Vchglast__TOP__v__DOT__uut__DOT__reset,0,0);
    VL_SIG8(__Vchglast__TOP__v__DOT__uut__DOT__clock_e,0,0);
    VL_SIG16(__Vtableidx1,11,0);
    VL_SIG16(__Vtableidx2,8,0);
    VL_SIG16(__Vtableidx3,8,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__clock_12_phase,11,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__video_count,14,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__src_base,15,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__dst_base,15,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__width,8,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__height,8,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__y_count,8,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__x_count,8,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__src_address,15,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__blt__DOT__dst_address,15,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__r_hCounter,11,0);
    VL_SIG16(__Vdly__v__DOT__uut__DOT__r_vCounter,11,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__pc,15,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__xreg,15,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__yreg,15,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__sp,15,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__up,15,0);
    VL_SIG16(__Vdly__v__DOT__cpu__DOT__md,15,0);
    //char	__VpadToAlign160146[2];
    VL_SIG(__Vm_traceActivity,31,0);
    
    // INTERNAL VARIABLES
    // Internals; generally not touched by application code
    //char	__VpadToAlign160156[4];
    Vrobotron_verilator__Syms*	__VlSymsp;		// Symbol table
    
    // PARAMETERS
    // Parameters marked /*verilator public*/ for use by application code
    
    // CONSTRUCTORS
  private:
    Vrobotron_verilator& operator= (const Vrobotron_verilator&);	///< Copying not allowed
    Vrobotron_verilator(const Vrobotron_verilator&);	///< Copying not allowed
  public:
    /// Construct the model; called by application code
    /// The special name  may be used to make a wrapper with a
    /// single model invisible WRT DPI scope names.
    Vrobotron_verilator(const char* name="TOP");
    /// Destroy the model; called (often implicitly) by application code
    ~Vrobotron_verilator();
    /// Trace signals in the model; called by application code
    void trace (VerilatedVcdC* tfp, int levels, int options=0);
    
    // USER METHODS
    
    // API METHODS
    /// Evaluate the model.  Application must call when inputs change.
    void eval();
    /// Simulation complete, run final blocks.  Application must call on completion.
    void final();
    
    // INTERNAL METHODS
  private:
    static void _eval_initial_loop(Vrobotron_verilator__Syms* __restrict vlSymsp);
  public:
    void __Vconfigure(Vrobotron_verilator__Syms* symsp, bool first);
    void	__Vdpiimwrap_v__DOT__dpi_vga_display_TOP(IData vsync, IData hsync, IData pixel);
    void	__Vdpiimwrap_v__DOT__dpi_vga_init_TOP(IData h, IData v);
  private:
    static IData	_change_request(Vrobotron_verilator__Syms* __restrict vlSymsp);
  public:
    static void	_eval(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_eval_initial(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_eval_settle(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_initial__TOP(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__14(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__20(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_multiclk__TOP__22(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__10(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__12(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__15(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__16(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__17(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__18(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__2(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__3(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__4(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__5(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__6(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__7(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__8(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_sequent__TOP__9(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_settle__TOP__1(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_settle__TOP__11(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_settle__TOP__13(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_settle__TOP__19(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	_settle__TOP__21(Vrobotron_verilator__Syms* __restrict vlSymsp);
    static void	traceChgThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__10(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__11(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__12(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__13(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__14(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__15(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__16(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__17(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__18(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__19(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__2(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__20(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__21(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__22(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__3(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__4(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__5(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__6(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__7(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__8(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceChgThis__9(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceFullThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceFullThis__1(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceInitThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void	traceInitThis__1(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code);
    static void traceInit (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceFull (VerilatedVcd* vcdp, void* userthis, uint32_t code);
    static void traceChg  (VerilatedVcd* vcdp, void* userthis, uint32_t code);
} VL_ATTR_ALIGNED(64);

#endif  /*guard*/
