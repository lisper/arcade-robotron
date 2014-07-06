// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vrobotron_verilator__Syms.h"


//======================

void Vrobotron_verilator::trace (VerilatedVcdC* tfp, int, int) {
    tfp->spTrace()->addCallback (&Vrobotron_verilator::traceInit, &Vrobotron_verilator::traceFull, &Vrobotron_verilator::traceChg, this);
}
void Vrobotron_verilator::traceInit(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->open()
    Vrobotron_verilator* t=(Vrobotron_verilator*)userthis;
    Vrobotron_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    if (!Verilated::calcUnusedSigs()) vl_fatal(__FILE__,__LINE__,__FILE__,"Turning on wave traces requires Verilated::traceEverOn(true) call before time 0.");
    vcdp->scopeEscape(' ');
    t->traceInitThis (vlSymsp, vcdp, code);
    vcdp->scopeEscape('.');
}
void Vrobotron_verilator::traceFull(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vrobotron_verilator* t=(Vrobotron_verilator*)userthis;
    Vrobotron_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    t->traceFullThis (vlSymsp, vcdp, code);
}

//======================


void Vrobotron_verilator::traceInitThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    vcdp->module(vlSymsp->name()); // Setup signal names
    // Body
    {
	vlTOPp->traceInitThis__1(vlSymsp, vcdp, code);
    }
}

void Vrobotron_verilator::traceFullThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vlTOPp->traceFullThis__1(vlSymsp, vcdp, code);
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0;
}

void Vrobotron_verilator::traceInitThis__1(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->declBit  (c+330,"v CLK",-1);
	vcdp->declBit  (c+331,"v clk25",-1);
	vcdp->declBit  (c+332,"v clk12",-1);
	vcdp->declBus  (c+44,"v A",-1,15,0);
	vcdp->declBus  (c+36,"v D_IN",-1,7,0);
	vcdp->declBus  (c+120,"v D_OUT",-1,7,0);
	vcdp->declBit  (c+104,"v RESET_N",-1);
	vcdp->declBit  (c+105,"v NMI_N",-1);
	vcdp->declBit  (c+106,"v FIRQ_N",-1);
	vcdp->declBit  (c+107,"v IRQ_N",-1);
	vcdp->declBit  (c+108,"v HALT_N",-1);
	vcdp->declBit  (c+333,"v LIC",-1);
	vcdp->declBit  (c+334,"v AVMA",-1);
	vcdp->declBit  (c+45,"v R_W_N",-1);
	vcdp->declBit  (c+335,"v TSC",-1);
	vcdp->declBit  (c+328,"v BA",-1);
	vcdp->declBit  (c+329,"v BS",-1);
	vcdp->declBit  (c+336,"v BUSY",-1);
	vcdp->declBit  (c+83,"v E",-1);
	vcdp->declBit  (c+84,"v Q",-1);
	vcdp->declBit  (c+121,"v MemOE",-1);
	vcdp->declBit  (c+122,"v MemWR",-1);
	vcdp->declBit  (c+335,"v RamAdv",-1);
	vcdp->declBit  (c+123,"v RamCS",-1);
	vcdp->declBit  (c+332,"v RamClk",-1);
	vcdp->declBit  (c+335,"v RamCRE",-1);
	vcdp->declBit  (c+124,"v RamLB",-1);
	vcdp->declBit  (c+125,"v RamUB",-1);
	vcdp->declBit  (c+337,"v RamWait",-1);
	vcdp->declBit  (c+338,"v FlashRp",-1);
	vcdp->declBit  (c+126,"v FlashCS",-1);
	vcdp->declBit  (c+339,"v FlashStSts",-1);
	vcdp->declBus  (c+127,"v MemAdr",-1,23,1);
	vcdp->declBus  (c+34,"v MemDB_in",-1,15,0);
	vcdp->declBus  (c+3,"v MemDB_out",-1,15,0);
	vcdp->declBus  (c+89,"v SEG",-1,6,0);
	vcdp->declBit  (c+338,"v DP",-1);
	vcdp->declBus  (c+85,"v AN",-1,3,0);
	vcdp->declBus  (c+32,"v LED",-1,7,0);
	vcdp->declBus  (c+340,"v SW",-1,7,0);
	vcdp->declBus  (c+341,"v BTN",-1,3,0);
	vcdp->declBus  (c+113,"v vgaRed",-1,2,0);
	vcdp->declBus  (c+114,"v vgaGreen",-1,2,0);
	vcdp->declBus  (c+115,"v vgaBlue",-1,2,0);
	vcdp->declBit  (c+128,"v Hsync",-1);
	vcdp->declBit  (c+129,"v Vsync",-1);
	vcdp->declBit  (c+130,"v Blank",-1);
	vcdp->declBus  (c+342,"v ja",-1,7,0);
	vcdp->declBus  (c+343,"v jb",-1,7,0);
	vcdp->declBit  (c+131,"v hand",-1);
	vcdp->declBus  (c+132,"v pb",-1,5,0);
	vcdp->declBus  (c+344,"v dac",-1,7,0);
	vcdp->declBit  (c+83,"v cpu_clk",-1);
	vcdp->declBit  (c+39,"v cpu_reset",-1);
	vcdp->declBit  (c+46,"v cpu_vma",-1);
	vcdp->declBus  (c+44,"v cpu_addr",-1,15,0);
	vcdp->declBit  (c+45,"v cpu_rw",-1);
	vcdp->declBus  (c+120,"v cpu_data_in",-1,7,0);
	vcdp->declBus  (c+36,"v cpu_data_out",-1,7,0);
	vcdp->declBit  (c+109,"v cpu_irq",-1);
	vcdp->declBit  (c+110,"v cpu_firq",-1);
	vcdp->declBit  (c+111,"v cpu_nmi",-1);
	vcdp->declBit  (c+112,"v cpu_halt",-1);
	vcdp->declBit  (c+335,"v cpu_hold",-1);
	vcdp->declBit  (c+118,"v cpu_halted",-1);
	vcdp->declBit  (c+328,"v cpu_ba",-1);
	vcdp->declBit  (c+329,"v cpu_bs",-1);
	vcdp->declBit  (c+331,"v pixclk",-1);
	vcdp->declBus  (c+116,"v pxd",-1,31,0);
	vcdp->declBus  (c+133,"v hs",-1,31,0);
	vcdp->declBus  (c+134,"v vs",-1,31,0);
	vcdp->declBit  (c+330,"v uut CLK",-1);
	vcdp->declBit  (c+332,"v uut cpu_clk_in",-1);
	vcdp->declBit  (c+331,"v uut vga_clk_in",-1);
	vcdp->declBus  (c+44,"v uut A",-1,15,0);
	vcdp->declBus  (c+36,"v uut D_IN",-1,7,0);
	vcdp->declBus  (c+120,"v uut D_OUT",-1,7,0);
	vcdp->declBit  (c+104,"v uut RESET_N",-1);
	vcdp->declBit  (c+105,"v uut NMI_N",-1);
	vcdp->declBit  (c+106,"v uut FIRQ_N",-1);
	vcdp->declBit  (c+107,"v uut IRQ_N",-1);
	vcdp->declBit  (c+333,"v uut LIC",-1);
	vcdp->declBit  (c+334,"v uut AVMA",-1);
	vcdp->declBit  (c+45,"v uut R_W_N",-1);
	vcdp->declBit  (c+335,"v uut TSC",-1);
	vcdp->declBit  (c+108,"v uut HALT_N",-1);
	vcdp->declBit  (c+328,"v uut BA",-1);
	vcdp->declBit  (c+329,"v uut BS",-1);
	vcdp->declBit  (c+336,"v uut BUSY",-1);
	vcdp->declBit  (c+83,"v uut E",-1);
	vcdp->declBit  (c+84,"v uut Q",-1);
	vcdp->declBit  (c+121,"v uut MemOE",-1);
	vcdp->declBit  (c+122,"v uut MemWR",-1);
	vcdp->declBit  (c+335,"v uut RamAdv",-1);
	vcdp->declBit  (c+123,"v uut RamCS",-1);
	vcdp->declBit  (c+332,"v uut RamClk",-1);
	vcdp->declBit  (c+335,"v uut RamCRE",-1);
	vcdp->declBit  (c+124,"v uut RamLB",-1);
	vcdp->declBit  (c+125,"v uut RamUB",-1);
	vcdp->declBit  (c+337,"v uut RamWait",-1);
	vcdp->declBit  (c+338,"v uut FlashRp",-1);
	vcdp->declBit  (c+126,"v uut FlashCS",-1);
	vcdp->declBit  (c+339,"v uut FlashStSts",-1);
	vcdp->declBus  (c+127,"v uut MemAdr",-1,23,1);
	vcdp->declBus  (c+34,"v uut MemDB_in",-1,15,0);
	vcdp->declBus  (c+3,"v uut MemDB_out",-1,15,0);
	vcdp->declBus  (c+89,"v uut SEG",-1,6,0);
	vcdp->declBit  (c+338,"v uut DP",-1);
	vcdp->declBus  (c+85,"v uut AN",-1,3,0);
	vcdp->declBus  (c+32,"v uut LED",-1,7,0);
	vcdp->declBus  (c+340,"v uut SW",-1,7,0);
	vcdp->declBus  (c+341,"v uut BTN",-1,3,0);
	vcdp->declBus  (c+113,"v uut vgaRed",-1,2,0);
	vcdp->declBus  (c+114,"v uut vgaGreen",-1,2,0);
	vcdp->declBus  (c+115,"v uut vgaBlue",-1,2,0);
	vcdp->declBit  (c+128,"v uut Hsync",-1);
	vcdp->declBit  (c+129,"v uut Vsync",-1);
	vcdp->declBit  (c+130,"v uut Blank",-1);
	vcdp->declBus  (c+342,"v uut JA",-1,7,0);
	vcdp->declBus  (c+343,"v uut JB",-1,7,0);
	vcdp->declBit  (c+131,"v uut hand_out",-1);
	vcdp->declBus  (c+132,"v uut pb_out",-1,5,0);
	vcdp->declBit  (c+345,"v uut reset_request",-1);
	vcdp->declBus  (c+37,"v uut reset_counter",-1,7,0);
	vcdp->declBit  (c+38,"v uut reset",-1);
	vcdp->declBit  (c+330,"v uut clock_50m",-1);
	vcdp->declBit  (c+346,"v uut clock_50m_0",-1);
	vcdp->declBit  (c+347,"v uut clock_50m_fb",-1);
	vcdp->declBit  (c+332,"v uut clock",-1);
	vcdp->declBus  (c+135,"v uut clock_12_phase",-1,11,0);
	vcdp->declBit  (c+136,"v uut clock_q_set",-1);
	vcdp->declBit  (c+137,"v uut clock_q_clear",-1);
	vcdp->declBit  (c+84,"v uut clock_q",-1);
	vcdp->declBit  (c+138,"v uut clock_e_set",-1);
	vcdp->declBit  (c+139,"v uut clock_e_clear",-1);
	vcdp->declBit  (c+83,"v uut clock_e",-1);
	vcdp->declBus  (c+140,"v uut video_count",-1,14,0);
	vcdp->declBus  (c+4,"v uut video_count_next",-1,14,0);
	vcdp->declBus  (c+5,"v uut video_address_or_mask",-1,13,0);
	vcdp->declBus  (c+141,"v uut video_address",-1,13,0);
	vcdp->declBit  (c+142,"v uut count_240",-1);
	vcdp->declBit  (c+143,"v uut irq_4ms",-1);
	vcdp->declBit  (c+144,"v uut horizontal_sync",-1);
	vcdp->declBit  (c+145,"v uut vertical_sync",-1);
	vcdp->declBit  (c+146,"v uut video_blank",-1);
	vcdp->declBus  (c+147,"v uut vga_red",-1,2,0);
	vcdp->declBus  (c+148,"v uut vga_green",-1,2,0);
	vcdp->declBus  (c+149,"v uut vga_blue",-1,2,0);
	vcdp->declBus  (c+150,"v uut led_bcd_in",-1,15,0);
	vcdp->declBus  (c+90,"v uut led_bcd_in_digit",-1,3,0);
	vcdp->declBus  (c+86,"v uut led_counter",-1,15,0);
	vcdp->declBus  (c+87,"v uut led_digit_index",-1,1,0);
	vcdp->declBus  (c+89,"v uut led_segment",-1,6,0);
	vcdp->declBit  (c+338,"v uut led_dp",-1);
	vcdp->declBus  (c+85,"v uut led_anode",-1,3,0);
	vcdp->declBus  (c+6,"v uut address",-1,15,0);
	vcdp->declBit  (c+7,"v uut write",-1);
	vcdp->declBit  (c+8,"v uut read",-1);
	vcdp->declBus  (c+151,"v uut mpu_address",-1,15,0);
	vcdp->declBus  (c+152,"v uut mpu_data_in",-1,7,0);
	vcdp->declBus  (c+120,"v uut mpu_data_out",-1,7,0);
	vcdp->declBit  (c+153,"v uut mpu_bus_status",-1);
	vcdp->declBit  (c+154,"v uut mpu_bus_available",-1);
	vcdp->declBit  (c+155,"v uut mpu_read",-1);
	vcdp->declBit  (c+156,"v uut mpu_write",-1);
	vcdp->declBit  (c+38,"v uut mpu_reset",-1);
	vcdp->declBit  (c+157,"v uut mpu_halt",-1);
	vcdp->declBit  (c+158,"v uut mpu_halted",-1);
	vcdp->declBit  (c+159,"v uut mpu_irq",-1);
	vcdp->declBit  (c+335,"v uut mpu_firq",-1);
	vcdp->declBit  (c+335,"v uut mpu_nmi",-1);
	vcdp->declBus  (c+160,"v uut memory_address",-1,15,0);
	vcdp->declBus  (c+35,"v uut memory_data_in",-1,7,0);
	vcdp->declBus  (c+161,"v uut memory_data_out",-1,7,0);
	vcdp->declBit  (c+162,"v uut memory_output_enable",-1);
	vcdp->declBit  (c+163,"v uut memory_write",-1);
	vcdp->declBit  (c+164,"v uut flash_enable",-1);
	vcdp->declBit  (c+165,"v uut ram_enable",-1);
	vcdp->declBit  (c+166,"v uut ram_lower_enable",-1);
	vcdp->declBit  (c+167,"v uut ram_upper_enable",-1);
	vcdp->declBit  (c+168,"v uut e_rom",-1);
	vcdp->declBit  (c+169,"v uut screen_control",-1);
	vcdp->declBit  (c+40,"v uut rom_access",-1);
	vcdp->declBit  (c+41,"v uut ram_access",-1);
	vcdp->declBit  (c+9,"v uut color_table_access",-1);
	vcdp->declBit  (c+10,"v uut widget_pia_access",-1);
	vcdp->declBit  (c+11,"v uut rom_pia_access",-1);
	vcdp->declBit  (c+12,"v uut blt_register_access",-1);
	vcdp->declBit  (c+13,"v uut video_counter_access",-1);
	vcdp->declBit  (c+14,"v uut watchdog_access",-1);
	vcdp->declBit  (c+15,"v uut control_access",-1);
	vcdp->declBit  (c+16,"v uut cmos_access",-1);
	vcdp->declBus  (c+170,"v uut video_counter_value",-1,7,0);
	vcdp->declBit  (c+131,"v uut HAND",-1);
	vcdp->declBit  (c+348,"v uut SLAM",-1);
	vcdp->declBit  (c+335,"v uut R_COIN",-1);
	vcdp->declBit  (c+349,"v uut C_COIN",-1);
	vcdp->declBit  (c+335,"v uut L_COIN",-1);
	vcdp->declBit  (c+350,"v uut H_S_RESET",-1);
	vcdp->declBit  (c+351,"v uut ADVANCE",-1);
	vcdp->declBit  (c+352,"v uut AUTO_UP",-1);
	vcdp->declBus  (c+132,"v uut PB",-1,5,0);
	vcdp->declBus  (c+171,"v uut rom_pia_rs",-1,1,0);
	vcdp->declBit  (c+172,"v uut rom_pia_cs",-1);
	vcdp->declBit  (c+173,"v uut rom_pia_write",-1);
	vcdp->declBus  (c+174,"v uut rom_pia_data_in",-1,7,0);
	vcdp->declBus  (c+17,"v uut rom_pia_data_out",-1,7,0);
	vcdp->declBit  (c+175,"v uut rom_pia_ca2_out",-1);
	vcdp->declBit  (c+176,"v uut rom_pia_ca2_dir",-1);
	vcdp->declBit  (c+177,"v uut rom_pia_irq_a",-1);
	vcdp->declBus  (c+18,"v uut rom_pia_pa_in",-1,7,0);
	vcdp->declBus  (c+178,"v uut rom_pia_pa_out",-1,7,0);
	vcdp->declBus  (c+179,"v uut rom_pia_pa_dir",-1,7,0);
	vcdp->declBit  (c+180,"v uut rom_pia_cb2_out",-1);
	vcdp->declBit  (c+181,"v uut rom_pia_cb2_dir",-1);
	vcdp->declBit  (c+182,"v uut rom_pia_irq_b",-1);
	vcdp->declBus  (c+353,"v uut rom_pia_pb_in",-1,7,0);
	vcdp->declBus  (c+183,"v uut rom_pia_pb_out",-1,7,0);
	vcdp->declBus  (c+184,"v uut rom_pia_pb_dir",-1,7,0);
	vcdp->declBus  (c+19,"v uut rom_led_digit",-1,7,0);
	vcdp->declBit  (c+354,"v uut MOVE_UP_1",-1);
	vcdp->declBit  (c+355,"v uut MOVE_DOWN_1",-1);
	vcdp->declBit  (c+356,"v uut MOVE_LEFT_1",-1);
	vcdp->declBit  (c+357,"v uut MOVE_RIGHT_1",-1);
	vcdp->declBit  (c+358,"v uut PLAYER_1_START",-1);
	vcdp->declBit  (c+359,"v uut PLAYER_2_START",-1);
	vcdp->declBit  (c+360,"v uut FIRE_UP_1",-1);
	vcdp->declBit  (c+361,"v uut FIRE_DOWN_1",-1);
	vcdp->declBit  (c+362,"v uut FIRE_RIGHT_1",-1);
	vcdp->declBit  (c+363,"v uut FIRE_LEFT_1",-1);
	vcdp->declBit  (c+364,"v uut MOVE_UP_2",-1);
	vcdp->declBit  (c+365,"v uut MOVE_DOWN_2",-1);
	vcdp->declBit  (c+366,"v uut MOVE_LEFT_2",-1);
	vcdp->declBit  (c+367,"v uut MOVE_RIGHT_2",-1);
	vcdp->declBit  (c+368,"v uut FIRE_RIGHT_2",-1);
	vcdp->declBit  (c+369,"v uut FIRE_UP_2",-1);
	vcdp->declBit  (c+370,"v uut FIRE_DOWN_2",-1);
	vcdp->declBit  (c+371,"v uut FIRE_LEFT_2",-1);
	vcdp->declBit  (c+338,"v uut board_interface_w1",-1);
	vcdp->declBus  (c+185,"v uut widget_pia_rs",-1,1,0);
	vcdp->declBit  (c+186,"v uut widget_pia_cs",-1);
	vcdp->declBit  (c+187,"v uut widget_pia_write",-1);
	vcdp->declBus  (c+188,"v uut widget_pia_data_in",-1,7,0);
	vcdp->declBus  (c+33,"v uut widget_pia_data_out",-1,7,0);
	vcdp->declBit  (c+189,"v uut widget_pia_ca2_out",-1);
	vcdp->declBit  (c+190,"v uut widget_pia_ca2_dir",-1);
	vcdp->declBit  (c+191,"v uut widget_pia_irq_a",-1);
	vcdp->declBus  (c+42,"v uut widget_pia_pa_in",-1,7,0);
	vcdp->declBus  (c+192,"v uut widget_pia_pa_out",-1,7,0);
	vcdp->declBus  (c+193,"v uut widget_pia_pa_dir",-1,7,0);
	vcdp->declBit  (c+194,"v uut widget_pia_input_select",-1);
	vcdp->declBit  (c+194,"v uut widget_pia_cb2_out",-1);
	vcdp->declBit  (c+195,"v uut widget_pia_cb2_dir",-1);
	vcdp->declBit  (c+196,"v uut widget_pia_irq_b",-1);
	vcdp->declBus  (c+20,"v uut widget_pia_pb_in",-1,7,0);
	vcdp->declBus  (c+197,"v uut widget_pia_pb_out",-1,7,0);
	vcdp->declBus  (c+198,"v uut widget_pia_pb_dir",-1,7,0);
	vcdp->declBus  (c+372,"v uut widget_ic3_a",-1,4,1);
	vcdp->declBus  (c+373,"v uut widget_ic3_b",-1,4,1);
	vcdp->declBus  (c+21,"v uut widget_ic3_y",-1,4,1);
	vcdp->declBus  (c+374,"v uut widget_ic4_a",-1,4,1);
	vcdp->declBus  (c+375,"v uut widget_ic4_b",-1,4,1);
	vcdp->declBus  (c+22,"v uut widget_ic4_y",-1,4,1);
	vcdp->declBus  (c+199,"v uut blt_rs",-1,2,0);
	vcdp->declBit  (c+200,"v uut blt_reg_cs",-1);
	vcdp->declBus  (c+201,"v uut blt_reg_data_in",-1,7,0);
	vcdp->declBit  (c+157,"v uut blt_halt",-1);
	vcdp->declBit  (c+158,"v uut blt_halt_ack",-1);
	vcdp->declBit  (c+202,"v uut blt_read",-1);
	vcdp->declBit  (c+203,"v uut blt_write",-1);
	vcdp->declBit  (c+204,"v uut blt_blt_ack",-1);
	vcdp->declBus  (c+205,"v uut blt_address_out",-1,15,0);
	vcdp->declBus  (c+35,"v uut blt_data_in",-1,7,0);
	vcdp->declBus  (c+206,"v uut blt_data_out",-1,7,0);
	vcdp->declBit  (c+207,"v uut blt_en_lower",-1);
	vcdp->declBit  (c+208,"v uut blt_en_upper",-1);
	{int i; for (i=0; i<16; i++) {
		vcdp->declBus  (c+209+i*1,"v uut color_table",(i+0),7,0);}}
	vcdp->declBus  (c+225,"v uut pixel_nibbles",-1,7,0);
	vcdp->declBus  (c+226,"v uut pixel_byte_l",-1,7,0);
	vcdp->declBus  (c+227,"v uut pixel_byte_h",-1,7,0);
	vcdp->declBus  (c+23,"v uut decoder_4_in",-1,8,0);
	vcdp->declBus  (c+43,"v uut pseudo_address",-1,15,8);
	vcdp->declBus  (c+228,"v uut decoder_6_in",-1,8,0);
	vcdp->declBus  (c+24,"v uut video_prom_address",-1,13,6);
	vcdp->declBus  (c+150,"v uut debug_blt_source_address",-1,15,0);
	vcdp->declBus  (c+229,"v uut debug_last_mpu_address",-1,15,0);
	vcdp->declBus  (c+230,"v uut r_advance",-1,1,0);
	vcdp->declBit  (c+231,"v uut advance_video_count",-1);
	vcdp->declBit  (c+232,"v uut r_advance_video_count",-1);
	vcdp->declBit  (c+233,"v uut r_clear_video_count",-1);
	vcdp->declBit  (c+234,"v uut clear_video_count",-1);
	vcdp->declBit  (c+79,"v uut old_HAND",-1);
	vcdp->declBus  (c+80,"v uut old_PB",-1,5,0);
	vcdp->declBus  (c+81,"v uut old_BTN",-1,3,0);
	vcdp->declBus  (c+82,"v uut old_rom_pia_pa_in",-1,7,0);
	vcdp->declBus  (c+88,"v uut old_widget_pia_pa_in",-1,7,0);
	vcdp->declBit  (c+332,"v uut pixclk",-1);
	vcdp->declBus  (c+235,"v uut r_hCounter",-1,11,0);
	vcdp->declBus  (c+236,"v uut r_vCounter",-1,11,0);
	vcdp->declBus  (c+25,"v uut n_hCounter",-1,11,0);
	vcdp->declBus  (c+26,"v uut n_vCounter",-1,11,0);
	vcdp->declBit  (c+128,"v uut r_hSync",-1);
	vcdp->declBit  (c+129,"v uut r_vSync",-1);
	vcdp->declBit  (c+234,"v uut r_vblank",-1);
	vcdp->declBit  (c+237,"v uut r_hblank",-1);
	vcdp->declBit  (c+27,"v uut n_hSync",-1);
	vcdp->declBit  (c+28,"v uut n_vSync",-1);
	vcdp->declBit  (c+238,"v uut n_vblank",-1);
	vcdp->declBit  (c+239,"v uut n_hblank",-1);
	vcdp->declBus  (c+113,"v uut vga_red_lb",-1,2,0);
	vcdp->declBus  (c+114,"v uut vga_green_lb",-1,2,0);
	vcdp->declBus  (c+115,"v uut vga_blue_lb",-1,2,0);
	vcdp->declBus  (c+29,"v uut hoffset",-1,3,0);
	vcdp->declBus  (c+23,"v uut horizontal_decoder address",-1,8,0);
	vcdp->declBus  (c+43,"v uut horizontal_decoder data",-1,7,0);
	vcdp->declBus  (c+228,"v uut vertical_decoder address",-1,8,0);
	vcdp->declBus  (c+24,"v uut vertical_decoder data",-1,7,0);
	vcdp->declBit  (c+332,"v uut blt clk",-1);
	vcdp->declBit  (c+38,"v uut blt reset",-1);
	vcdp->declBit  (c+139,"v uut blt e_sync",-1);
	vcdp->declBit  (c+200,"v uut blt reg_cs",-1);
	vcdp->declBus  (c+201,"v uut blt reg_data_in",-1,7,0);
	vcdp->declBus  (c+199,"v uut blt rs",-1,2,0);
	vcdp->declBit  (c+157,"v uut blt halt",-1);
	vcdp->declBit  (c+158,"v uut blt halt_ack",-1);
	vcdp->declBit  (c+204,"v uut blt blt_ack",-1);
	vcdp->declBit  (c+202,"v uut blt read",-1);
	vcdp->declBit  (c+203,"v uut blt write",-1);
	vcdp->declBus  (c+205,"v uut blt blt_address_out",-1,15,0);
	vcdp->declBus  (c+35,"v uut blt blt_data_in",-1,7,0);
	vcdp->declBus  (c+206,"v uut blt blt_data_out",-1,7,0);
	vcdp->declBit  (c+208,"v uut blt en_upper",-1);
	vcdp->declBit  (c+207,"v uut blt en_lower",-1);
	vcdp->declBit  (c+240,"v uut blt span_src",-1);
	vcdp->declBit  (c+241,"v uut blt span_dst",-1);
	vcdp->declBit  (c+242,"v uut blt synchronize_e",-1);
	vcdp->declBit  (c+243,"v uut blt zero_write_suppress",-1);
	vcdp->declBit  (c+244,"v uut blt constant_substitution",-1);
	vcdp->declBit  (c+245,"v uut blt shift_right",-1);
	vcdp->declBit  (c+246,"v uut blt suppress_lower",-1);
	vcdp->declBit  (c+247,"v uut blt suppress_upper",-1);
	vcdp->declBus  (c+248,"v uut blt constant_value",-1,7,0);
	vcdp->declBus  (c+249,"v uut blt src_base",-1,15,0);
	vcdp->declBus  (c+250,"v uut blt dst_base",-1,15,0);
	vcdp->declBus  (c+251,"v uut blt width",-1,8,0);
	vcdp->declBus  (c+252,"v uut blt height",-1,8,0);
	vcdp->declBus  (c+253,"v uut blt state",-1,1,0);
	vcdp->declBus  (c+254,"v uut blt blt_src_data",-1,7,0);
	vcdp->declBus  (c+255,"v uut blt src_address",-1,15,0);
	vcdp->declBus  (c+256,"v uut blt dst_address",-1,15,0);
	vcdp->declBus  (c+257,"v uut blt x_count",-1,8,0);
	vcdp->declBus  (c+258,"v uut blt x_count_next",-1,8,0);
	vcdp->declBus  (c+259,"v uut blt y_count",-1,8,0);
	vcdp->declBus  (c+260,"v uut blt y_count_next",-1,8,0);
	vcdp->declBit  (c+38,"v uut rom_pia reset",-1);
	vcdp->declBit  (c+332,"v uut rom_pia clock",-1);
	vcdp->declBit  (c+139,"v uut rom_pia e_sync",-1);
	vcdp->declBus  (c+171,"v uut rom_pia rs",-1,1,0);
	vcdp->declBit  (c+172,"v uut rom_pia cs",-1);
	vcdp->declBit  (c+173,"v uut rom_pia write",-1);
	vcdp->declBus  (c+174,"v uut rom_pia data_in",-1,7,0);
	vcdp->declBus  (c+17,"v uut rom_pia data_out",-1,7,0);
	vcdp->declBit  (c+142,"v uut rom_pia ca1",-1);
	vcdp->declBit  (c+175,"v uut rom_pia ca2_out",-1);
	vcdp->declBit  (c+176,"v uut rom_pia ca2_dir",-1);
	vcdp->declBit  (c+177,"v uut rom_pia irq_a",-1);
	vcdp->declBus  (c+18,"v uut rom_pia pa_in",-1,7,0);
	vcdp->declBus  (c+178,"v uut rom_pia pa_out",-1,7,0);
	vcdp->declBus  (c+179,"v uut rom_pia pa_dir",-1,7,0);
	vcdp->declBit  (c+143,"v uut rom_pia cb1",-1);
	vcdp->declBit  (c+180,"v uut rom_pia cb2_out",-1);
	vcdp->declBit  (c+181,"v uut rom_pia cb2_dir",-1);
	vcdp->declBit  (c+182,"v uut rom_pia irq_b",-1);
	vcdp->declBus  (c+183,"v uut rom_pia pb_out",-1,7,0);
	vcdp->declBus  (c+184,"v uut rom_pia pb_dir",-1,7,0);
	vcdp->declBit  (c+338,"v uut rom_pia ca2_in",-1);
	vcdp->declBit  (c+338,"v uut rom_pia cb2_in",-1);
	vcdp->declBus  (c+353,"v uut rom_pia pb_in",-1,7,0);
	vcdp->declBit  (c+261,"v uut rom_pia read",-1);
	vcdp->declBit  (c+262,"v uut rom_pia ca1_q",-1);
	vcdp->declBit  (c+263,"v uut rom_pia ca2_q",-1);
	vcdp->declBit  (c+264,"v uut rom_pia cb1_q",-1);
	vcdp->declBit  (c+265,"v uut rom_pia cb2_q",-1);
	vcdp->declBus  (c+178,"v uut rom_pia output_a",-1,7,0);
	vcdp->declBus  (c+179,"v uut rom_pia ddr_a",-1,7,0);
	vcdp->declBus  (c+266,"v uut rom_pia cr_a",-1,7,0);
	vcdp->declBit  (c+267,"v uut rom_pia irqa_1_intf",-1);
	vcdp->declBit  (c+268,"v uut rom_pia irqa_2_intf",-1);
	vcdp->declBit  (c+176,"v uut rom_pia ca2_is_output",-1);
	vcdp->declBit  (c+269,"v uut rom_pia cr_a_4",-1);
	vcdp->declBit  (c+270,"v uut rom_pia cr_a_3",-1);
	vcdp->declBit  (c+271,"v uut rom_pia output_a_access",-1);
	vcdp->declBit  (c+272,"v uut rom_pia ca1_edge",-1);
	vcdp->declBit  (c+269,"v uut rom_pia ca2_edge",-1);
	vcdp->declBit  (c+273,"v uut rom_pia ca1_int_en",-1);
	vcdp->declBit  (c+274,"v uut rom_pia ca2_int_en",-1);
	vcdp->declBit  (c+275,"v uut rom_pia ca2_in_gated",-1);
	vcdp->declBit  (c+175,"v uut rom_pia ca2_out_value",-1);
	vcdp->declBus  (c+183,"v uut rom_pia output_b",-1,7,0);
	vcdp->declBus  (c+184,"v uut rom_pia ddr_b",-1,7,0);
	vcdp->declBus  (c+276,"v uut rom_pia cr_b",-1,7,0);
	vcdp->declBit  (c+277,"v uut rom_pia irqb_1_intf",-1);
	vcdp->declBit  (c+278,"v uut rom_pia irqb_2_intf",-1);
	vcdp->declBit  (c+181,"v uut rom_pia cb2_is_output",-1);
	vcdp->declBit  (c+279,"v uut rom_pia cr_b_4",-1);
	vcdp->declBit  (c+280,"v uut rom_pia cr_b_3",-1);
	vcdp->declBit  (c+281,"v uut rom_pia output_b_access",-1);
	vcdp->declBit  (c+282,"v uut rom_pia cb1_edge",-1);
	vcdp->declBit  (c+279,"v uut rom_pia cb2_edge",-1);
	vcdp->declBit  (c+283,"v uut rom_pia cb1_int_en",-1);
	vcdp->declBit  (c+284,"v uut rom_pia cb2_int_en",-1);
	vcdp->declBit  (c+285,"v uut rom_pia cb2_in_gated",-1);
	vcdp->declBit  (c+180,"v uut rom_pia cb2_out_value",-1);
	vcdp->declBit  (c+38,"v uut widget_pia reset",-1);
	vcdp->declBit  (c+332,"v uut widget_pia clock",-1);
	vcdp->declBit  (c+139,"v uut widget_pia e_sync",-1);
	vcdp->declBus  (c+185,"v uut widget_pia rs",-1,1,0);
	vcdp->declBit  (c+186,"v uut widget_pia cs",-1);
	vcdp->declBit  (c+187,"v uut widget_pia write",-1);
	vcdp->declBus  (c+188,"v uut widget_pia data_in",-1,7,0);
	vcdp->declBus  (c+33,"v uut widget_pia data_out",-1,7,0);
	vcdp->declBit  (c+189,"v uut widget_pia ca2_out",-1);
	vcdp->declBit  (c+190,"v uut widget_pia ca2_dir",-1);
	vcdp->declBit  (c+191,"v uut widget_pia irq_a",-1);
	vcdp->declBus  (c+42,"v uut widget_pia pa_in",-1,7,0);
	vcdp->declBus  (c+192,"v uut widget_pia pa_out",-1,7,0);
	vcdp->declBus  (c+193,"v uut widget_pia pa_dir",-1,7,0);
	vcdp->declBit  (c+194,"v uut widget_pia cb2_out",-1);
	vcdp->declBit  (c+195,"v uut widget_pia cb2_dir",-1);
	vcdp->declBit  (c+196,"v uut widget_pia irq_b",-1);
	vcdp->declBus  (c+20,"v uut widget_pia pb_in",-1,7,0);
	vcdp->declBus  (c+197,"v uut widget_pia pb_out",-1,7,0);
	vcdp->declBus  (c+198,"v uut widget_pia pb_dir",-1,7,0);
	vcdp->declBit  (c+335,"v uut widget_pia ca1",-1);
	vcdp->declBit  (c+335,"v uut widget_pia ca2_in",-1);
	vcdp->declBit  (c+335,"v uut widget_pia cb1",-1);
	vcdp->declBit  (c+338,"v uut widget_pia cb2_in",-1);
	vcdp->declBit  (c+286,"v uut widget_pia read",-1);
	vcdp->declBit  (c+287,"v uut widget_pia ca1_q",-1);
	vcdp->declBit  (c+288,"v uut widget_pia ca2_q",-1);
	vcdp->declBit  (c+289,"v uut widget_pia cb1_q",-1);
	vcdp->declBit  (c+290,"v uut widget_pia cb2_q",-1);
	vcdp->declBus  (c+192,"v uut widget_pia output_a",-1,7,0);
	vcdp->declBus  (c+193,"v uut widget_pia ddr_a",-1,7,0);
	vcdp->declBus  (c+291,"v uut widget_pia cr_a",-1,7,0);
	vcdp->declBit  (c+292,"v uut widget_pia irqa_1_intf",-1);
	vcdp->declBit  (c+293,"v uut widget_pia irqa_2_intf",-1);
	vcdp->declBit  (c+190,"v uut widget_pia ca2_is_output",-1);
	vcdp->declBit  (c+294,"v uut widget_pia cr_a_4",-1);
	vcdp->declBit  (c+295,"v uut widget_pia cr_a_3",-1);
	vcdp->declBit  (c+296,"v uut widget_pia output_a_access",-1);
	vcdp->declBit  (c+297,"v uut widget_pia ca1_edge",-1);
	vcdp->declBit  (c+294,"v uut widget_pia ca2_edge",-1);
	vcdp->declBit  (c+298,"v uut widget_pia ca1_int_en",-1);
	vcdp->declBit  (c+299,"v uut widget_pia ca2_int_en",-1);
	vcdp->declBit  (c+335,"v uut widget_pia ca2_in_gated",-1);
	vcdp->declBit  (c+189,"v uut widget_pia ca2_out_value",-1);
	vcdp->declBus  (c+197,"v uut widget_pia output_b",-1,7,0);
	vcdp->declBus  (c+198,"v uut widget_pia ddr_b",-1,7,0);
	vcdp->declBus  (c+300,"v uut widget_pia cr_b",-1,7,0);
	vcdp->declBit  (c+301,"v uut widget_pia irqb_1_intf",-1);
	vcdp->declBit  (c+302,"v uut widget_pia irqb_2_intf",-1);
	vcdp->declBit  (c+195,"v uut widget_pia cb2_is_output",-1);
	vcdp->declBit  (c+303,"v uut widget_pia cr_b_4",-1);
	vcdp->declBit  (c+304,"v uut widget_pia cr_b_3",-1);
	vcdp->declBit  (c+305,"v uut widget_pia output_b_access",-1);
	vcdp->declBit  (c+306,"v uut widget_pia cb1_edge",-1);
	vcdp->declBit  (c+303,"v uut widget_pia cb2_edge",-1);
	vcdp->declBit  (c+307,"v uut widget_pia cb1_int_en",-1);
	vcdp->declBit  (c+308,"v uut widget_pia cb2_int_en",-1);
	vcdp->declBit  (c+309,"v uut widget_pia cb2_in_gated",-1);
	vcdp->declBit  (c+194,"v uut widget_pia cb2_out_value",-1);
	vcdp->declBus  (c+90,"v uut bcd_demux in",-1,3,0);
	vcdp->declBus  (c+89,"v uut bcd_demux out",-1,6,0);
	vcdp->declBit  (c+332,"v uut lb pixclk",-1);
	vcdp->declBit  (c+38,"v uut lb reset",-1);
	vcdp->declBus  (c+235,"v uut lb hcount_2",-1,11,0);
	vcdp->declBus  (c+236,"v uut lb vcount_2",-1,11,0);
	vcdp->declBit  (c+128,"v uut lb hsync_2",-1);
	vcdp->declBit  (c+129,"v uut lb vsync_2",-1);
	vcdp->declBus  (c+113,"v uut lb red_2",-1,2,0);
	vcdp->declBus  (c+114,"v uut lb grn_2",-1,2,0);
	vcdp->declBus  (c+115,"v uut lb blu_2",-1,2,0);
	vcdp->declBus  (c+310,"v uut lb hcount_1",-1,11,0);
	vcdp->declBus  (c+311,"v uut lb vcount_1",-1,11,0);
	vcdp->declBit  (c+144,"v uut lb hsync_1",-1);
	vcdp->declBit  (c+145,"v uut lb vsync_1",-1);
	vcdp->declBus  (c+147,"v uut lb red_1",-1,2,0);
	vcdp->declBus  (c+148,"v uut lb grn_1",-1,2,0);
	vcdp->declBus  (c+149,"v uut lb blu_1",-1,2,0);
	vcdp->declBus  (c+29,"v uut lb hoffset_1",-1,3,0);
	// Tracing: v uut lb line // Ignored: Wide memory > 32 ents at ../robotron_cpu/line_buffer.v:29
	vcdp->declBus  (c+30,"v uut lb w_addr",-1,10,0);
	vcdp->declBus  (c+312,"v uut lb r_addr",-1,10,0);
	vcdp->declBit  (c+313,"v uut lb oline",-1);
	vcdp->declBit  (c+314,"v uut lb iline",-1);
	vcdp->declBus  (c+315,"v uut lb w_data",-1,8,0);
	vcdp->declBus  (c+117,"v uut lb r_data",-1,8,0);
	vcdp->declBit  (c+335,"v uut lb border",-1);
	vcdp->declBus  (c+316,"v uut lb hcountx12",-1,9,0);
	vcdp->declBus  (c+317,"v uut lb hcountx4",-1,9,0);
	vcdp->declBus  (c+31,"v uut lb hcountx12po",-1,9,0);
	vcdp->declBit  (c+83,"v cpu clk",-1);
	vcdp->declBit  (c+39,"v cpu rst",-1);
	vcdp->declBit  (c+46,"v cpu vma",-1);
	vcdp->declBus  (c+44,"v cpu addr",-1,15,0);
	vcdp->declBit  (c+45,"v cpu rw",-1);
	vcdp->declBus  (c+36,"v cpu data_out",-1,7,0);
	vcdp->declBus  (c+120,"v cpu data_in",-1,7,0);
	vcdp->declBit  (c+109,"v cpu irq",-1);
	vcdp->declBit  (c+110,"v cpu firq",-1);
	vcdp->declBit  (c+111,"v cpu nmi",-1);
	vcdp->declBit  (c+112,"v cpu halt",-1);
	vcdp->declBit  (c+328,"v cpu ba_out",-1);
	vcdp->declBit  (c+329,"v cpu bs_out",-1);
	vcdp->declBit  (c+118,"v cpu halted",-1);
	vcdp->declBit  (c+335,"v cpu hold",-1);
	vcdp->declBit  (c+47,"v cpu alu__valid_lo",-1);
	vcdp->declBit  (c+48,"v cpu alu__valid_hi",-1);
	vcdp->declBit  (c+49,"v cpu alu__carry_in",-1);
	vcdp->declBus  (c+50,"v cpu alu__daa_reg",-1,7,0);
	vcdp->declBus  (c+95,"v cpu op_code",-1,7,0);
	vcdp->declBus  (c+96,"v cpu pre_code",-1,7,0);
	vcdp->declBus  (c+318,"v cpu acca",-1,7,0);
	vcdp->declBus  (c+319,"v cpu accb",-1,7,0);
	vcdp->declBus  (c+320,"v cpu cc",-1,7,0);
	vcdp->declBus  (c+51,"v cpu cc_out",-1,7,0);
	vcdp->declBus  (c+321,"v cpu dp",-1,7,0);
	vcdp->declBus  (c+322,"v cpu xreg",-1,15,0);
	vcdp->declBus  (c+323,"v cpu yreg",-1,15,0);
	vcdp->declBus  (c+324,"v cpu sp",-1,15,0);
	vcdp->declBus  (c+325,"v cpu up",-1,15,0);
	vcdp->declBus  (c+97,"v cpu ea",-1,15,0);
	vcdp->declBus  (c+326,"v cpu pc",-1,15,0);
	vcdp->declBus  (c+327,"v cpu md",-1,15,0);
	vcdp->declBus  (c+52,"v cpu left",-1,15,0);
	vcdp->declBus  (c+53,"v cpu right",-1,15,0);
	vcdp->declBus  (c+54,"v cpu out_alu",-1,15,0);
	vcdp->declBus  (c+98,"v cpu iv",-1,2,0);
	vcdp->declBit  (c+94,"v cpu nmi_req",-1);
	vcdp->declBit  (c+99,"v cpu nmi_ack",-1);
	vcdp->declBit  (c+100,"v cpu nmi_enable",-1);
	vcdp->declBus  (c+119,"v cpu state",-1,7,0);
	vcdp->declBus  (c+55,"v cpu next_state",-1,7,0);
	vcdp->declBus  (c+2,"v cpu saved_state",-1,7,0);
	vcdp->declBus  (c+56,"v cpu return_state",-1,7,0);
	{int i; for (i=0; i<3; i++) {
		vcdp->declBus  (c+101+i*1,"v cpu state_stack",(i+0),7,0);}}
	vcdp->declBus  (c+57,"v cpu st_ctrl",-1,1,0);
	vcdp->declBus  (c+58,"v cpu pc_ctrl",-1,2,0);
	vcdp->declBus  (c+59,"v cpu ea_ctrl",-1,2,0);
	vcdp->declBus  (c+60,"v cpu op_ctrl",-1,1,0);
	vcdp->declBus  (c+61,"v cpu pre_ctrl",-1,1,0);
	vcdp->declBus  (c+62,"v cpu md_ctrl",-1,2,0);
	vcdp->declBus  (c+63,"v cpu acca_ctrl",-1,2,0);
	vcdp->declBus  (c+64,"v cpu accb_ctrl",-1,1,0);
	vcdp->declBus  (c+65,"v cpu ix_ctrl",-1,2,0);
	vcdp->declBus  (c+66,"v cpu iy_ctrl",-1,2,0);
	vcdp->declBus  (c+67,"v cpu cc_ctrl",-1,1,0);
	vcdp->declBus  (c+68,"v cpu dp_ctrl",-1,1,0);
	vcdp->declBus  (c+69,"v cpu sp_ctrl",-1,2,0);
	vcdp->declBus  (c+70,"v cpu up_ctrl",-1,2,0);
	vcdp->declBus  (c+71,"v cpu iv_ctrl",-1,3,0);
	vcdp->declBus  (c+72,"v cpu left_ctrl",-1,3,0);
	vcdp->declBus  (c+73,"v cpu right_ctrl",-1,3,0);
	vcdp->declBus  (c+74,"v cpu alu_ctrl",-1,5,0);
	vcdp->declBus  (c+75,"v cpu addr_ctrl",-1,3,0);
	vcdp->declBus  (c+76,"v cpu dout_ctrl",-1,3,0);
	vcdp->declBus  (c+77,"v cpu nmi_ctrl",-1,1,0);
	vcdp->declBit  (c+328,"v cpu ba",-1);
	vcdp->declBit  (c+329,"v cpu bs",-1);
	vcdp->declBit  (c+78,"v cpu cond_true",-1);
	vcdp->declBit  (c+332,"v mem clk",-1);
	vcdp->declBit  (c+39,"v mem reset",-1);
	vcdp->declBit  (c+121,"v mem MemOE",-1);
	vcdp->declBit  (c+122,"v mem MemWR",-1);
	vcdp->declBus  (c+127,"v mem MemAdr",-1,23,1);
	vcdp->declBus  (c+3,"v mem MemDB_in",-1,15,0);
	vcdp->declBus  (c+34,"v mem MemDB_out",-1,15,0);
	vcdp->declBit  (c+123,"v mem RamCS",-1);
	vcdp->declBit  (c+124,"v mem RamLB",-1);
	vcdp->declBit  (c+125,"v mem RamUB",-1);
	vcdp->declBit  (c+126,"v mem FlashCS",-1);
	// Tracing: v mem ramh // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:25
	// Tracing: v mem raml // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:26
	// Tracing: v mem rom1 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:28
	// Tracing: v mem rom2 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:29
	// Tracing: v mem rom3 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:30
	// Tracing: v mem rom4 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:31
	// Tracing: v mem rom5 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:32
	// Tracing: v mem rom6 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:33
	// Tracing: v mem rom7 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:34
	// Tracing: v mem rom8 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:35
	// Tracing: v mem rom9 // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:36
	// Tracing: v mem roma // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:37
	// Tracing: v mem romb // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:38
	// Tracing: v mem romc // Ignored: Wide memory > 32 ents at ../robotron_cpu/robotron_mem.v:39
	vcdp->declBus  (c+91,"v mem ram_out",-1,15,0);
	vcdp->declBus  (c+92,"v mem rom_out",-1,15,0);
	vcdp->declBus  (c+93,"v mem rom_data",-1,7,0);
	vcdp->declBus  (c+1,"v mem i",-1,31,0);
    }
}

void Vrobotron_verilator::traceFullThis__1(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->fullBus  (c+1,(vlTOPp->v__DOT__mem__DOT__i),32);
	vcdp->fullBus  (c+2,(vlTOPp->v__DOT__cpu__DOT__saved_state),8);
	vcdp->fullBus  (c+4,(vlTOPp->v__DOT__uut__DOT__video_count_next),15);
	vcdp->fullBus  (c+5,(((0x4000 & (IData)(vlTOPp->v__DOT__uut__DOT__video_count_next))
			       ? 0x3f00 : 0)),14);
	vcdp->fullBus  (c+6,(vlTOPp->v__DOT__uut__DOT__address),16);
	vcdp->fullBit  (c+7,(vlTOPp->v__DOT__uut__DOT__write));
	vcdp->fullBit  (c+8,(vlTOPp->v__DOT__uut__DOT__read));
	vcdp->fullBit  (c+9,((0xc000 == (0xfc00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+10,((0xc804 == (0xff0c & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+11,((0xc80c == (0xff0c & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+12,((0xca00 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+13,((0xcb00 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+14,((0xcbfe == (0xfffe & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+15,((0xc900 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBit  (c+16,((0xcc00 == (0xfe00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->fullBus  (c+17,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access))
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_pa_in)
			        : (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
				    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access)))
				    ? (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_a)
				    : ((1 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs))
				        ? (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
					    << 7) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
					     << 6) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output) 
						<< 5) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_4) 
						   << 4) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
						      << 3) 
						     | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access) 
							 << 2) 
							| (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_edge) 
							    << 1) 
							   | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en))))))))
				        : (((2 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
					    & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access))
					    ? 1 : (
						   ((2 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
						    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access)))
						    ? (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_b)
						    : 
						   ((3 
						     == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs))
						     ? 
						    (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
						      << 7) 
						     | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
							 << 6) 
							| (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output) 
							    << 5) 
							   | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_4) 
							       << 4) 
							      | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
								  << 3) 
								 | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access) 
								     << 2) 
								    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_edge) 
									<< 1) 
								       | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en))))))))
						     : 0))))))),8);
	vcdp->fullBus  (c+18,(vlTOPp->v__DOT__uut__DOT__rom_pia_pa_in),8);
	vcdp->fullBus  (c+19,(vlTOPp->v__DOT__uut__DOT__rom_led_digit),8);
	vcdp->fullBus  (c+20,(((2 & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
				     >> 2)) | (1 & 
					       ((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
						>> 2)))),8);
	vcdp->fullBus  (c+21,(vlTOPp->v__DOT__uut__DOT__widget_ic3_y),4);
	vcdp->fullBus  (c+22,(vlTOPp->v__DOT__uut__DOT__widget_ic4_y),4);
	vcdp->fullBus  (c+23,((((IData)(vlTOPp->v__DOT__uut__DOT__screen_control) 
				<< 8) | (0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__address) 
						 >> 8)))),9);
	vcdp->fullBus  (c+24,(vlTOPp->v__DOT__uut__DOT____Vcellinp__vertical_decoder__data),8);
	vcdp->fullBus  (c+25,(vlTOPp->v__DOT__uut__DOT__n_hCounter),12);
	vcdp->fullBus  (c+26,(vlTOPp->v__DOT__uut__DOT__n_vCounter),12);
	vcdp->fullBit  (c+27,(vlTOPp->v__DOT__uut__DOT__n_hSync));
	vcdp->fullBit  (c+28,(vlTOPp->v__DOT__uut__DOT__n_vSync));
	vcdp->fullBus  (c+29,(vlTOPp->v__DOT__uut__DOT__hoffset),4);
	vcdp->fullBus  (c+30,(((0x400 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter)) 
					 << 0xa)) | 
			       (0x3ff & ((((0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2)) 
					   + (0x7c 
					      & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						 << 2))) 
					  + (0x7c & 
					     ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      << 2))) 
					 + (IData)(vlTOPp->v__DOT__uut__DOT__hoffset))))),11);
	vcdp->fullBus  (c+31,((0x3ff & ((((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						   << 2)) 
					  + (0x7c & 
					     ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      << 2))) 
					 + (0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2))) 
					+ (IData)(vlTOPp->v__DOT__uut__DOT__hoffset)))),10);
	vcdp->fullBus  (c+3,(vlTOPp->v__DOT__MemDB_out),16);
	vcdp->fullBus  (c+32,(((((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en)) 
				  | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
					& (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output))))) 
				 | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				     & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en)) 
				    | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
				       & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
					  & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))))) 
				<< 7) | (((0 != (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state)) 
					  << 6) | (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__mpu_halted) 
						    << 5) 
						   | (((IData)(vlTOPp->v__DOT__uut__DOT__ram_access) 
						       << 4) 
						      | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_access) 
							  << 3) 
							 | (((0xc80c 
							      == 
							      (0xff0c 
							       & (IData)(vlTOPp->v__DOT__uut__DOT__address))) 
							     << 2) 
							    | (((0xc804 
								 == 
								 (0xff0c 
								  & (IData)(vlTOPp->v__DOT__uut__DOT__address))) 
								<< 1) 
							       | (0xca00 
								  == 
								  (0xff00 
								   & (IData)(vlTOPp->v__DOT__uut__DOT__address))))))))))),8);
	vcdp->fullBus  (c+33,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access))
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_pa_in)
			        : (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
				    & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access)))
				    ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_a)
				    : ((1 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs))
				        ? (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
					    << 7) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
					     << 6) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output) 
						<< 5) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_4) 
						   << 4) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
						      << 3) 
						     | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access) 
							 << 2) 
							| (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_edge) 
							    << 1) 
							   | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en))))))))
				        : (((2 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
					    & (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access))
					    ? ((2 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
						 >> 2)) 
					       | (1 
						  & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
						     >> 2)))
					    : (((2 
						 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
						& (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access)))
					        ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_b)
					        : (
						   (3 
						    == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs))
						    ? 
						   (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf) 
						     << 7) 
						    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf) 
							<< 6) 
						       | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output) 
							   << 5) 
							  | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_4) 
							      << 4) 
							     | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
								 << 3) 
								| (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access) 
								    << 2) 
								   | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_edge) 
								       << 1) 
								      | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en))))))))
						    : 0))))))),8);
	vcdp->fullBus  (c+35,(vlTOPp->v__DOT__uut__DOT__memory_data_in),8);
	vcdp->fullBus  (c+34,(vlTOPp->v__DOT__MemDB_in),16);
	vcdp->fullBus  (c+36,((0xff & ((8 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
				        ? ((4 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					    ? ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					        ? (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__md) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__md))
					        : (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__pc) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__pc)))
					    : ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					        ? (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__sp) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__sp))
					        : (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__up) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__up))))
				        : ((4 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					    ? ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					        ? (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__yreg) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__yreg))
					        : (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? 
						   ((IData)(vlTOPp->v__DOT__cpu__DOT__xreg) 
						    >> 8)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__xreg)))
					    : ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					        ? (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? (IData)(vlTOPp->v__DOT__cpu__DOT__dp)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__accb))
					        : (
						   (1 
						    & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						    ? (IData)(vlTOPp->v__DOT__cpu__DOT__acca)
						    : (IData)(vlTOPp->v__DOT__cpu__DOT__cc))))))),8);
	vcdp->fullBus  (c+37,(vlTOPp->v__DOT__uut__DOT__reset_counter),8);
	vcdp->fullBit  (c+38,(vlTOPp->v__DOT__uut__DOT__reset));
	vcdp->fullBit  (c+40,(vlTOPp->v__DOT__uut__DOT__rom_access));
	vcdp->fullBit  (c+41,(vlTOPp->v__DOT__uut__DOT__ram_access));
	vcdp->fullBus  (c+42,(vlTOPp->v__DOT__uut__DOT__widget_pia_pa_in),8);
	vcdp->fullBus  (c+43,(vlTOPp->v__DOT__uut__DOT____Vcellinp__horizontal_decoder__data),8);
	vcdp->fullBit  (c+39,(vlTOPp->v__DOT__cpu_reset));
	vcdp->fullBit  (c+46,(vlTOPp->v__DOT__cpu_vma));
	vcdp->fullBus  (c+44,(vlTOPp->v__DOT__cpu_addr),16);
	vcdp->fullBit  (c+45,(vlTOPp->v__DOT__cpu_rw));
	vcdp->fullBit  (c+47,(vlTOPp->v__DOT__cpu__DOT__alu___05Fvalid_lo));
	vcdp->fullBit  (c+48,(vlTOPp->v__DOT__cpu__DOT__alu___05Fvalid_hi));
	vcdp->fullBit  (c+49,(vlTOPp->v__DOT__cpu__DOT__alu___05Fcarry_in));
	vcdp->fullBus  (c+50,(vlTOPp->v__DOT__cpu__DOT__alu___05Fdaa_reg),8);
	vcdp->fullBus  (c+51,(vlTOPp->v__DOT__cpu__DOT__cc_out),8);
	vcdp->fullBus  (c+52,(vlTOPp->v__DOT__cpu__DOT__left),16);
	vcdp->fullBus  (c+53,(vlTOPp->v__DOT__cpu__DOT__right),16);
	vcdp->fullBus  (c+54,(vlTOPp->v__DOT__cpu__DOT__out_alu),16);
	vcdp->fullBus  (c+55,(vlTOPp->v__DOT__cpu__DOT__next_state),8);
	vcdp->fullBus  (c+56,(vlTOPp->v__DOT__cpu__DOT__return_state),8);
	vcdp->fullBus  (c+57,(vlTOPp->v__DOT__cpu__DOT__st_ctrl),2);
	vcdp->fullBus  (c+58,(vlTOPp->v__DOT__cpu__DOT__pc_ctrl),3);
	vcdp->fullBus  (c+59,(vlTOPp->v__DOT__cpu__DOT__ea_ctrl),3);
	vcdp->fullBus  (c+60,(vlTOPp->v__DOT__cpu__DOT__op_ctrl),2);
	vcdp->fullBus  (c+61,(vlTOPp->v__DOT__cpu__DOT__pre_ctrl),2);
	vcdp->fullBus  (c+62,(vlTOPp->v__DOT__cpu__DOT__md_ctrl),3);
	vcdp->fullBus  (c+63,(vlTOPp->v__DOT__cpu__DOT__acca_ctrl),3);
	vcdp->fullBus  (c+64,(vlTOPp->v__DOT__cpu__DOT__accb_ctrl),2);
	vcdp->fullBus  (c+65,(vlTOPp->v__DOT__cpu__DOT__ix_ctrl),3);
	vcdp->fullBus  (c+66,(vlTOPp->v__DOT__cpu__DOT__iy_ctrl),3);
	vcdp->fullBus  (c+67,(vlTOPp->v__DOT__cpu__DOT__cc_ctrl),2);
	vcdp->fullBus  (c+68,(vlTOPp->v__DOT__cpu__DOT__dp_ctrl),2);
	vcdp->fullBus  (c+69,(vlTOPp->v__DOT__cpu__DOT__sp_ctrl),3);
	vcdp->fullBus  (c+70,(vlTOPp->v__DOT__cpu__DOT__up_ctrl),3);
	vcdp->fullBus  (c+71,(vlTOPp->v__DOT__cpu__DOT__iv_ctrl),4);
	vcdp->fullBus  (c+72,(vlTOPp->v__DOT__cpu__DOT__left_ctrl),4);
	vcdp->fullBus  (c+73,(vlTOPp->v__DOT__cpu__DOT__right_ctrl),4);
	vcdp->fullBus  (c+74,(vlTOPp->v__DOT__cpu__DOT__alu_ctrl),6);
	vcdp->fullBus  (c+75,(vlTOPp->v__DOT__cpu__DOT__addr_ctrl),4);
	vcdp->fullBus  (c+76,(vlTOPp->v__DOT__cpu__DOT__dout_ctrl),4);
	vcdp->fullBus  (c+77,(vlTOPp->v__DOT__cpu__DOT__nmi_ctrl),2);
	vcdp->fullBit  (c+78,(vlTOPp->v__DOT__cpu__DOT__cond_true));
	vcdp->fullBit  (c+79,(vlTOPp->v__DOT__uut__DOT__old_HAND));
	vcdp->fullBus  (c+80,(vlTOPp->v__DOT__uut__DOT__old_PB),6);
	vcdp->fullBus  (c+81,(vlTOPp->v__DOT__uut__DOT__old_BTN),4);
	vcdp->fullBus  (c+82,(vlTOPp->v__DOT__uut__DOT__old_rom_pia_pa_in),8);
	vcdp->fullBit  (c+84,(vlTOPp->v__DOT__uut__DOT__clock_q));
	vcdp->fullBus  (c+86,(vlTOPp->v__DOT__uut__DOT__led_counter),16);
	vcdp->fullBus  (c+87,((3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
				    >> 0xe))),2);
	vcdp->fullBus  (c+85,(((0 == (3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
					   >> 0xe)))
			        ? 0xe : ((1 == (3 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						 >> 0xe)))
					  ? 0xd : (
						   (2 
						    == 
						    (3 
						     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							>> 0xe)))
						    ? 0xb
						    : 
						   ((3 
						     == 
						     (3 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							 >> 0xe)))
						     ? 7
						     : 0xf))))),4);
	vcdp->fullBus  (c+88,(vlTOPp->v__DOT__uut__DOT__old_widget_pia_pa_in),8);
	vcdp->fullBit  (c+83,(vlTOPp->v__DOT__uut__DOT__clock_e));
	vcdp->fullBus  (c+90,((0xf & ((0 == (3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						  >> 0xe)))
				       ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
				       : ((1 == (3 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						    >> 0xe)))
					   ? ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
					      >> 4)
					   : ((2 == 
					       (3 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						 >> 0xe)))
					       ? ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						  >> 8)
					       : ((3 
						   == 
						   (3 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						       >> 0xe)))
						   ? 
						  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						   >> 0xc)
						   : 0)))))),4);
	vcdp->fullBus  (c+89,(((1 == (0xf & ((0 == 
					      (3 & 
					       ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						>> 0xe)))
					      ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
					      : ((1 
						  == 
						  (3 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						      >> 0xe)))
						  ? 
						 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						  >> 4)
						  : 
						 ((2 
						   == 
						   (3 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						       >> 0xe)))
						   ? 
						  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						   >> 8)
						   : 
						  ((3 
						    == 
						    (3 
						     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							>> 0xe)))
						    ? 
						   ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						    >> 0xc)
						    : 0))))))
			        ? 0x79 : ((2 == (0xf 
						 & ((0 
						     == 
						     (3 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							 >> 0xe)))
						     ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						     : 
						    ((1 
						      == 
						      (3 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							  >> 0xe)))
						      ? 
						     ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						      >> 4)
						      : 
						     ((2 
						       == 
						       (3 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							   >> 0xe)))
						       ? 
						      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						       >> 8)
						       : 
						      ((3 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? 
						       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							>> 0xc)
						        : 0))))))
					   ? 0x24 : 
					  ((3 == (0xf 
						  & ((0 
						      == 
						      (3 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							  >> 0xe)))
						      ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						      : 
						     ((1 
						       == 
						       (3 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							   >> 0xe)))
						       ? 
						      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						       >> 4)
						       : 
						      ((2 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? 
						       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							>> 8)
						        : 
						       ((3 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? 
							((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							 >> 0xc)
							 : 0))))))
					    ? 0x30 : 
					   ((4 == (0xf 
						   & ((0 
						       == 
						       (3 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							   >> 0xe)))
						       ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						       : 
						      ((1 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? 
						       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							>> 4)
						        : 
						       ((2 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? 
							((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							 >> 8)
							 : 
							((3 
							  == 
							  (3 
							   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							      >> 0xe)))
							  ? 
							 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							  >> 0xc)
							  : 0))))))
					     ? 0x19
					     : ((5 
						 == 
						 (0xf 
						  & ((0 
						      == 
						      (3 
						       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							  >> 0xe)))
						      ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						      : 
						     ((1 
						       == 
						       (3 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							   >> 0xe)))
						       ? 
						      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						       >> 4)
						       : 
						      ((2 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? 
						       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							>> 8)
						        : 
						       ((3 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? 
							((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							 >> 0xc)
							 : 0))))))
						 ? 0x12
						 : 
						((6 
						  == 
						  (0xf 
						   & ((0 
						       == 
						       (3 
							& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							   >> 0xe)))
						       ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						       : 
						      ((1 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? 
						       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							>> 4)
						        : 
						       ((2 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? 
							((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							 >> 8)
							 : 
							((3 
							  == 
							  (3 
							   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							      >> 0xe)))
							  ? 
							 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							  >> 0xc)
							  : 0))))))
						  ? 2
						  : 
						 ((7 
						   == 
						   (0xf 
						    & ((0 
							== 
							(3 
							 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							    >> 0xe)))
						        ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
						        : 
						       ((1 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? 
							((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							 >> 4)
							 : 
							((2 
							  == 
							  (3 
							   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							      >> 0xe)))
							  ? 
							 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							  >> 8)
							  : 
							 ((3 
							   == 
							   (3 
							    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							       >> 0xe)))
							   ? 
							  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							   >> 0xc)
							   : 0))))))
						   ? 0x78
						   : 
						  ((8 
						    == 
						    (0xf 
						     & ((0 
							 == 
							 (3 
							  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							     >> 0xe)))
							 ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							 : 
							((1 
							  == 
							  (3 
							   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							      >> 0xe)))
							  ? 
							 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							  >> 4)
							  : 
							 ((2 
							   == 
							   (3 
							    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							       >> 0xe)))
							   ? 
							  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							   >> 8)
							   : 
							  ((3 
							    == 
							    (3 
							     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								>> 0xe)))
							    ? 
							   ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							    >> 0xc)
							    : 0))))))
						    ? 0
						    : 
						   ((9 
						     == 
						     (0xf 
						      & ((0 
							  == 
							  (3 
							   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							      >> 0xe)))
							  ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							  : 
							 ((1 
							   == 
							   (3 
							    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							       >> 0xe)))
							   ? 
							  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							   >> 4)
							   : 
							  ((2 
							    == 
							    (3 
							     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								>> 0xe)))
							    ? 
							   ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							    >> 8)
							    : 
							   ((3 
							     == 
							     (3 
							      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								 >> 0xe)))
							     ? 
							    ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							     >> 0xc)
							     : 0))))))
						     ? 0x10
						     : 
						    ((0xa 
						      == 
						      (0xf 
						       & ((0 
							   == 
							   (3 
							    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
							       >> 0xe)))
							   ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							   : 
							  ((1 
							    == 
							    (3 
							     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								>> 0xe)))
							    ? 
							   ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							    >> 4)
							    : 
							   ((2 
							     == 
							     (3 
							      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								 >> 0xe)))
							     ? 
							    ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							     >> 8)
							     : 
							    ((3 
							      == 
							      (3 
							       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								  >> 0xe)))
							      ? 
							     ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							      >> 0xc)
							      : 0))))))
						      ? 8
						      : 
						     ((0xb 
						       == 
						       (0xf 
							& ((0 
							    == 
							    (3 
							     & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								>> 0xe)))
							    ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							    : 
							   ((1 
							     == 
							     (3 
							      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								 >> 0xe)))
							     ? 
							    ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							     >> 4)
							     : 
							    ((2 
							      == 
							      (3 
							       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								  >> 0xe)))
							      ? 
							     ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							      >> 8)
							      : 
							     ((3 
							       == 
							       (3 
								& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								   >> 0xe)))
							       ? 
							      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							       >> 0xc)
							       : 0))))))
						       ? 3
						       : 
						      ((0xc 
							== 
							(0xf 
							 & ((0 
							     == 
							     (3 
							      & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								 >> 0xe)))
							     ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							     : 
							    ((1 
							      == 
							      (3 
							       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								  >> 0xe)))
							      ? 
							     ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							      >> 4)
							      : 
							     ((2 
							       == 
							       (3 
								& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								   >> 0xe)))
							       ? 
							      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							       >> 8)
							       : 
							      ((3 
								== 
								(3 
								 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								    >> 0xe)))
							        ? 
							       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								>> 0xc)
							        : 0))))))
						        ? 0x46
						        : 
						       ((0xd 
							 == 
							 (0xf 
							  & ((0 
							      == 
							      (3 
							       & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								  >> 0xe)))
							      ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							      : 
							     ((1 
							       == 
							       (3 
								& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								   >> 0xe)))
							       ? 
							      ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
							       >> 4)
							       : 
							      ((2 
								== 
								(3 
								 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								    >> 0xe)))
							        ? 
							       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								>> 8)
							        : 
							       ((3 
								 == 
								 (3 
								  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								     >> 0xe)))
								 ? 
								((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								 >> 0xc)
								 : 0))))))
							 ? 0x21
							 : 
							((0xe 
							  == 
							  (0xf 
							   & ((0 
							       == 
							       (3 
								& ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								   >> 0xe)))
							       ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							       : 
							      ((1 
								== 
								(3 
								 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								    >> 0xe)))
							        ? 
							       ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								>> 4)
							        : 
							       ((2 
								 == 
								 (3 
								  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								     >> 0xe)))
								 ? 
								((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								 >> 8)
								 : 
								((3 
								  == 
								  (3 
								   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								      >> 0xe)))
								  ? 
								 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								  >> 0xc)
								  : 0))))))
							  ? 6
							  : 
							 ((0xf 
							   == 
							   (0xf 
							    & ((0 
								== 
								(3 
								 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								    >> 0xe)))
							        ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
							        : 
							       ((1 
								 == 
								 (3 
								  & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								     >> 0xe)))
								 ? 
								((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								 >> 4)
								 : 
								((2 
								  == 
								  (3 
								   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								      >> 0xe)))
								  ? 
								 ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								  >> 8)
								  : 
								 ((3 
								   == 
								   (3 
								    & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
								       >> 0xe)))
								   ? 
								  ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
								   >> 0xc)
								   : 0))))))
							   ? 0xe
							   : 0x40)))))))))))))))),7);
	vcdp->fullBus  (c+91,(vlTOPp->v__DOT__mem__DOT__ram_out),16);
	vcdp->fullBus  (c+92,(((0xf00 & ((IData)(vlTOPp->v__DOT__mem__DOT__rom_data) 
					 << 4)) | (0xf 
						   & (IData)(vlTOPp->v__DOT__mem__DOT__rom_data)))),16);
	vcdp->fullBus  (c+93,(vlTOPp->v__DOT__mem__DOT__rom_data),8);
	vcdp->fullBit  (c+94,(vlTOPp->v__DOT__cpu__DOT__nmi_req));
	vcdp->fullBus  (c+95,(vlTOPp->v__DOT__cpu__DOT__op_code),8);
	vcdp->fullBus  (c+96,(vlTOPp->v__DOT__cpu__DOT__pre_code),8);
	vcdp->fullBus  (c+97,(vlTOPp->v__DOT__cpu__DOT__ea),16);
	vcdp->fullBus  (c+98,(vlTOPp->v__DOT__cpu__DOT__iv),3);
	vcdp->fullBit  (c+99,(vlTOPp->v__DOT__cpu__DOT__nmi_ack));
	vcdp->fullBit  (c+100,(vlTOPp->v__DOT__cpu__DOT__nmi_enable));
	vcdp->fullBus  (c+101,(vlTOPp->v__DOT__cpu__DOT__state_stack[0]),8);
	vcdp->fullBus  (c+102,(vlTOPp->v__DOT__cpu__DOT__state_stack[1]),8);
	vcdp->fullBus  (c+103,(vlTOPp->v__DOT__cpu__DOT__state_stack[2]),8);
	vcdp->fullBit  (c+104,(vlTOPp->v__DOT__RESET_N));
	vcdp->fullBit  (c+105,(vlTOPp->v__DOT__NMI_N));
	vcdp->fullBit  (c+106,(vlTOPp->v__DOT__FIRQ_N));
	vcdp->fullBit  (c+107,(vlTOPp->v__DOT__IRQ_N));
	vcdp->fullBit  (c+108,(vlTOPp->v__DOT__HALT_N));
	vcdp->fullBit  (c+109,((1 & (~ (IData)(vlTOPp->v__DOT__IRQ_N)))));
	vcdp->fullBit  (c+110,((1 & (~ (IData)(vlTOPp->v__DOT__FIRQ_N)))));
	vcdp->fullBit  (c+111,((1 & (~ (IData)(vlTOPp->v__DOT__NMI_N)))));
	vcdp->fullBit  (c+112,((1 & (~ (IData)(vlTOPp->v__DOT__HALT_N)))));
	vcdp->fullBus  (c+116,(((0xe0 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
					 << 5)) | (
						   (0x18 
						    & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
						       >> 1)) 
						   | (7 
						      & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
							 >> 6))))),32);
	vcdp->fullBus  (c+113,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
				     >> 6))),3);
	vcdp->fullBus  (c+114,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
				     >> 3))),3);
	vcdp->fullBus  (c+115,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data))),3);
	vcdp->fullBus  (c+117,(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data),9);
	vcdp->fullBit  (c+118,((0x20 == (IData)(vlTOPp->v__DOT__cpu__DOT__state))));
	vcdp->fullBus  (c+119,(vlTOPp->v__DOT__cpu__DOT__state),8);
	vcdp->fullBit  (c+130,(((IData)(vlTOPp->v__DOT__uut__DOT__r_hblank) 
				| (IData)(vlTOPp->v__DOT__uut__DOT__r_vblank))));
	vcdp->fullBus  (c+133,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_hSync)))),32);
	vcdp->fullBus  (c+134,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vSync)))),32);
	vcdp->fullBus  (c+135,(vlTOPp->v__DOT__uut__DOT__clock_12_phase),12);
	vcdp->fullBit  (c+136,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				     >> 2))));
	vcdp->fullBit  (c+137,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				     >> 8))));
	vcdp->fullBit  (c+138,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				     >> 5))));
	vcdp->fullBus  (c+140,(vlTOPp->v__DOT__uut__DOT__video_count),15);
	vcdp->fullBus  (c+141,(vlTOPp->v__DOT__uut__DOT__video_address),14);
	vcdp->fullBit  (c+142,((0xf == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					       >> 0xa)))));
	vcdp->fullBit  (c+143,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
				     >> 0xb))));
	vcdp->fullBit  (c+144,((0xe == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					       >> 1)))));
	vcdp->fullBit  (c+145,((0x1f == (0x1f & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						 >> 9)))));
	vcdp->fullBit  (c+146,(vlTOPp->v__DOT__uut__DOT__video_blank));
	vcdp->fullBus  (c+147,(vlTOPp->v__DOT__uut__DOT__vga_red),3);
	vcdp->fullBus  (c+148,(vlTOPp->v__DOT__uut__DOT__vga_green),3);
	vcdp->fullBus  (c+149,(vlTOPp->v__DOT__uut__DOT__vga_blue),3);
	vcdp->fullBus  (c+150,(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address),16);
	vcdp->fullBus  (c+151,(vlTOPp->v__DOT__uut__DOT__mpu_address),16);
	vcdp->fullBus  (c+152,(vlTOPp->v__DOT__uut__DOT__mpu_data_in),8);
	vcdp->fullBit  (c+153,(vlTOPp->v__DOT__uut__DOT__mpu_bus_status));
	vcdp->fullBit  (c+154,(vlTOPp->v__DOT__uut__DOT__mpu_bus_available));
	vcdp->fullBit  (c+155,(vlTOPp->v__DOT__uut__DOT__mpu_read));
	vcdp->fullBit  (c+156,(vlTOPp->v__DOT__uut__DOT__mpu_write));
	vcdp->fullBit  (c+159,(((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				  & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en)) 
				 | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
				    & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
				       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output))))) 
				| (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				    & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en)) 
				   | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
				      & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
					 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output))))))));
	vcdp->fullBus  (c+160,(vlTOPp->v__DOT__uut__DOT__memory_address),16);
	vcdp->fullBus  (c+161,(vlTOPp->v__DOT__uut__DOT__memory_data_out),8);
	vcdp->fullBit  (c+162,(vlTOPp->v__DOT__uut__DOT__memory_output_enable));
	vcdp->fullBit  (c+163,(vlTOPp->v__DOT__uut__DOT__memory_write));
	vcdp->fullBit  (c+164,(vlTOPp->v__DOT__uut__DOT__flash_enable));
	vcdp->fullBit  (c+165,(vlTOPp->v__DOT__uut__DOT__ram_enable));
	vcdp->fullBit  (c+166,(vlTOPp->v__DOT__uut__DOT__ram_lower_enable));
	vcdp->fullBit  (c+167,(vlTOPp->v__DOT__uut__DOT__ram_upper_enable));
	vcdp->fullBit  (c+168,(vlTOPp->v__DOT__uut__DOT__e_rom));
	vcdp->fullBit  (c+169,(vlTOPp->v__DOT__uut__DOT__screen_control));
	vcdp->fullBus  (c+170,((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					>> 6))),8);
	vcdp->fullBit  (c+131,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a) 
					>> 7)))));
	vcdp->fullBus  (c+132,((0x3f & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b))),6);
	vcdp->fullBus  (c+171,(vlTOPp->v__DOT__uut__DOT__rom_pia_rs),2);
	vcdp->fullBit  (c+172,(vlTOPp->v__DOT__uut__DOT__rom_pia_cs));
	vcdp->fullBit  (c+173,(vlTOPp->v__DOT__uut__DOT__rom_pia_write));
	vcdp->fullBus  (c+174,(vlTOPp->v__DOT__uut__DOT__rom_pia_data_in),8);
	vcdp->fullBit  (c+177,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en)) 
				| ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))))));
	vcdp->fullBit  (c+182,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en)) 
				| ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))))));
	vcdp->fullBus  (c+185,(vlTOPp->v__DOT__uut__DOT__widget_pia_rs),2);
	vcdp->fullBit  (c+186,(vlTOPp->v__DOT__uut__DOT__widget_pia_cs));
	vcdp->fullBit  (c+187,(vlTOPp->v__DOT__uut__DOT__widget_pia_write));
	vcdp->fullBus  (c+188,(vlTOPp->v__DOT__uut__DOT__widget_pia_data_in),8);
	vcdp->fullBit  (c+191,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en)) 
				| ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output)))))));
	vcdp->fullBit  (c+196,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en)) 
				| ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))))));
	vcdp->fullBus  (c+199,(vlTOPp->v__DOT__uut__DOT__blt_rs),3);
	vcdp->fullBit  (c+200,(vlTOPp->v__DOT__uut__DOT__blt_reg_cs));
	vcdp->fullBus  (c+201,(vlTOPp->v__DOT__uut__DOT__blt_reg_data_in),8);
	vcdp->fullBit  (c+202,((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->fullBit  (c+203,((3 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->fullBit  (c+204,(vlTOPp->v__DOT__uut__DOT__blt_blt_ack));
	vcdp->fullBus  (c+205,(((3 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))
				 ? (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_address)
				 : (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_address))),16);
	vcdp->fullBus  (c+206,(((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_substitution)
				 ? (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_value)
				 : (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data))),8);
	vcdp->fullBit  (c+207,((1 & ((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state)) 
				     | (~ ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_lower) 
					   | ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress) 
					      & (0 
						 == 
						 (0xf 
						  & (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data))))))))));
	vcdp->fullBit  (c+208,((1 & ((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state)) 
				     | (~ ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_upper) 
					   | ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress) 
					      & (0 
						 == 
						 (0xf 
						  & ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data) 
						     >> 4))))))))));
	vcdp->fullBus  (c+209,(vlTOPp->v__DOT__uut__DOT__color_table[0]),8);
	vcdp->fullBus  (c+210,(vlTOPp->v__DOT__uut__DOT__color_table[1]),8);
	vcdp->fullBus  (c+211,(vlTOPp->v__DOT__uut__DOT__color_table[2]),8);
	vcdp->fullBus  (c+212,(vlTOPp->v__DOT__uut__DOT__color_table[3]),8);
	vcdp->fullBus  (c+213,(vlTOPp->v__DOT__uut__DOT__color_table[4]),8);
	vcdp->fullBus  (c+214,(vlTOPp->v__DOT__uut__DOT__color_table[5]),8);
	vcdp->fullBus  (c+215,(vlTOPp->v__DOT__uut__DOT__color_table[6]),8);
	vcdp->fullBus  (c+216,(vlTOPp->v__DOT__uut__DOT__color_table[7]),8);
	vcdp->fullBus  (c+217,(vlTOPp->v__DOT__uut__DOT__color_table[8]),8);
	vcdp->fullBus  (c+218,(vlTOPp->v__DOT__uut__DOT__color_table[9]),8);
	vcdp->fullBus  (c+219,(vlTOPp->v__DOT__uut__DOT__color_table[10]),8);
	vcdp->fullBus  (c+220,(vlTOPp->v__DOT__uut__DOT__color_table[11]),8);
	vcdp->fullBus  (c+221,(vlTOPp->v__DOT__uut__DOT__color_table[12]),8);
	vcdp->fullBus  (c+222,(vlTOPp->v__DOT__uut__DOT__color_table[13]),8);
	vcdp->fullBus  (c+223,(vlTOPp->v__DOT__uut__DOT__color_table[14]),8);
	vcdp->fullBus  (c+224,(vlTOPp->v__DOT__uut__DOT__color_table[15]),8);
	vcdp->fullBus  (c+225,(vlTOPp->v__DOT__uut__DOT__pixel_nibbles),8);
	vcdp->fullBus  (c+226,(vlTOPp->v__DOT__uut__DOT__pixel_byte_l),8);
	vcdp->fullBus  (c+227,(vlTOPp->v__DOT__uut__DOT__pixel_byte_h),8);
	vcdp->fullBus  (c+228,((((IData)(vlTOPp->v__DOT__uut__DOT__screen_control) 
				 << 8) | (0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						  >> 6)))),9);
	vcdp->fullBus  (c+229,(vlTOPp->v__DOT__uut__DOT__debug_last_mpu_address),16);
	vcdp->fullBus  (c+230,(vlTOPp->v__DOT__uut__DOT__r_advance),2);
	vcdp->fullBit  (c+231,((((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
				 > 0x20) & ((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
					    < 0x154))));
	vcdp->fullBit  (c+232,(vlTOPp->v__DOT__uut__DOT__r_advance_video_count));
	vcdp->fullBit  (c+233,(vlTOPp->v__DOT__uut__DOT__r_clear_video_count));
	vcdp->fullBit  (c+234,(vlTOPp->v__DOT__uut__DOT__r_vblank));
	vcdp->fullBus  (c+235,(vlTOPp->v__DOT__uut__DOT__r_hCounter),12);
	vcdp->fullBus  (c+236,(vlTOPp->v__DOT__uut__DOT__r_vCounter),12);
	vcdp->fullBit  (c+237,(vlTOPp->v__DOT__uut__DOT__r_hblank));
	vcdp->fullBit  (c+238,(((IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter) 
				>= 0x1f4)));
	vcdp->fullBit  (c+239,(((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
				>= 0x154)));
	vcdp->fullBit  (c+157,((0 != (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->fullBit  (c+158,(vlTOPp->v__DOT__uut__DOT__mpu_halted));
	vcdp->fullBit  (c+240,(vlTOPp->v__DOT__uut__DOT__blt__DOT__span_src));
	vcdp->fullBit  (c+241,(vlTOPp->v__DOT__uut__DOT__blt__DOT__span_dst));
	vcdp->fullBit  (c+242,(vlTOPp->v__DOT__uut__DOT__blt__DOT__synchronize_e));
	vcdp->fullBit  (c+243,(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress));
	vcdp->fullBit  (c+244,(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_substitution));
	vcdp->fullBit  (c+245,(vlTOPp->v__DOT__uut__DOT__blt__DOT__shift_right));
	vcdp->fullBit  (c+246,(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_lower));
	vcdp->fullBit  (c+247,(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_upper));
	vcdp->fullBus  (c+248,(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_value),8);
	vcdp->fullBus  (c+249,(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_base),16);
	vcdp->fullBus  (c+250,(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_base),16);
	vcdp->fullBus  (c+251,(vlTOPp->v__DOT__uut__DOT__blt__DOT__width),9);
	vcdp->fullBus  (c+252,(vlTOPp->v__DOT__uut__DOT__blt__DOT__height),9);
	vcdp->fullBus  (c+253,(vlTOPp->v__DOT__uut__DOT__blt__DOT__state),2);
	vcdp->fullBus  (c+254,(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data),8);
	vcdp->fullBus  (c+255,(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_address),16);
	vcdp->fullBus  (c+256,(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_address),16);
	vcdp->fullBus  (c+257,(vlTOPp->v__DOT__uut__DOT__blt__DOT__x_count),9);
	vcdp->fullBus  (c+258,((0x1ff & ((IData)(1) 
					 + (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__x_count)))),9);
	vcdp->fullBus  (c+259,(vlTOPp->v__DOT__uut__DOT__blt__DOT__y_count),9);
	vcdp->fullBus  (c+260,((0x1ff & ((IData)(1) 
					 + (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__y_count)))),9);
	vcdp->fullBit  (c+261,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_write)))));
	vcdp->fullBit  (c+262,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_q));
	vcdp->fullBit  (c+263,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_q));
	vcdp->fullBit  (c+264,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_q));
	vcdp->fullBit  (c+265,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_q));
	vcdp->fullBus  (c+178,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a),8);
	vcdp->fullBus  (c+179,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_a),8);
	vcdp->fullBus  (c+266,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				 << 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
					   << 6) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output) 
					    << 5) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_4) 
					     << 4) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
						<< 3) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access) 
						   << 2) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_edge) 
						      << 1) 
						     | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en))))))))),8);
	vcdp->fullBit  (c+267,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf));
	vcdp->fullBit  (c+268,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf));
	vcdp->fullBit  (c+176,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output));
	vcdp->fullBit  (c+269,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_4));
	vcdp->fullBit  (c+270,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3));
	vcdp->fullBit  (c+271,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access));
	vcdp->fullBit  (c+272,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_edge));
	vcdp->fullBit  (c+273,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en));
	vcdp->fullBit  (c+274,(((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
				& (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))));
	vcdp->fullBit  (c+275,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))));
	vcdp->fullBit  (c+175,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_out_value));
	vcdp->fullBus  (c+183,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b),8);
	vcdp->fullBus  (c+184,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_b),8);
	vcdp->fullBus  (c+276,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				 << 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
					   << 6) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output) 
					    << 5) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_4) 
					     << 4) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
						<< 3) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access) 
						   << 2) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_edge) 
						      << 1) 
						     | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en))))))))),8);
	vcdp->fullBit  (c+277,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf));
	vcdp->fullBit  (c+278,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf));
	vcdp->fullBit  (c+181,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output));
	vcdp->fullBit  (c+279,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_4));
	vcdp->fullBit  (c+280,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3));
	vcdp->fullBit  (c+281,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access));
	vcdp->fullBit  (c+282,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_edge));
	vcdp->fullBit  (c+283,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en));
	vcdp->fullBit  (c+284,(((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
				& (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))));
	vcdp->fullBit  (c+285,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))));
	vcdp->fullBit  (c+180,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_out_value));
	vcdp->fullBit  (c+139,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				     >> 0xb))));
	vcdp->fullBit  (c+286,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_write)))));
	vcdp->fullBit  (c+287,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_q));
	vcdp->fullBit  (c+288,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_q));
	vcdp->fullBit  (c+289,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_q));
	vcdp->fullBit  (c+290,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_q));
	vcdp->fullBus  (c+192,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a),8);
	vcdp->fullBus  (c+193,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_a),8);
	vcdp->fullBus  (c+291,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
				 << 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
					   << 6) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output) 
					    << 5) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_4) 
					     << 4) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
						<< 3) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access) 
						   << 2) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_edge) 
						      << 1) 
						     | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en))))))))),8);
	vcdp->fullBit  (c+292,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf));
	vcdp->fullBit  (c+293,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf));
	vcdp->fullBit  (c+190,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output));
	vcdp->fullBit  (c+294,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_4));
	vcdp->fullBit  (c+295,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3));
	vcdp->fullBit  (c+296,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access));
	vcdp->fullBit  (c+297,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_edge));
	vcdp->fullBit  (c+298,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en));
	vcdp->fullBit  (c+299,(((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
				& (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output)))));
	vcdp->fullBit  (c+189,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_out_value));
	vcdp->fullBus  (c+197,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b),8);
	vcdp->fullBus  (c+198,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_b),8);
	vcdp->fullBus  (c+300,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf) 
				 << 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf) 
					   << 6) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output) 
					    << 5) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_4) 
					     << 4) 
					    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
						<< 3) 
					       | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access) 
						   << 2) 
						  | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_edge) 
						      << 1) 
						     | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en))))))))),8);
	vcdp->fullBit  (c+301,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf));
	vcdp->fullBit  (c+302,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf));
	vcdp->fullBit  (c+195,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output));
	vcdp->fullBit  (c+303,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_4));
	vcdp->fullBit  (c+304,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3));
	vcdp->fullBit  (c+305,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access));
	vcdp->fullBit  (c+306,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_edge));
	vcdp->fullBit  (c+307,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en));
	vcdp->fullBit  (c+308,(((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
				& (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))));
	vcdp->fullBit  (c+309,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))));
	vcdp->fullBit  (c+194,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_out_value));
	vcdp->fullBit  (c+128,(vlTOPp->v__DOT__uut__DOT__r_hSync));
	vcdp->fullBit  (c+129,(vlTOPp->v__DOT__uut__DOT__r_vSync));
	vcdp->fullBus  (c+310,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__video_address))),12);
	vcdp->fullBus  (c+311,((0x1ff & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					 >> 5))),12);
	vcdp->fullBus  (c+312,(((0x400 & ((IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter) 
					  << 0xa)) 
				| (0x3ff & (IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter)))),11);
	vcdp->fullBit  (c+313,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter))));
	vcdp->fullBit  (c+314,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter)))));
	vcdp->fullBus  (c+315,((((IData)(vlTOPp->v__DOT__uut__DOT__vga_red) 
				 << 6) | (((IData)(vlTOPp->v__DOT__uut__DOT__vga_green) 
					   << 3) | (IData)(vlTOPp->v__DOT__uut__DOT__vga_blue)))),9);
	vcdp->fullBus  (c+316,((0x3ff & (((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						   << 2)) 
					  + (0x7c & 
					     ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      << 2))) 
					 + (0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2))))),10);
	vcdp->fullBus  (c+317,((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					<< 2))),10);
	vcdp->fullBus  (c+120,(vlTOPp->v__DOT__uut__DOT__mpu_data_out),8);
	vcdp->fullBit  (c+121,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__memory_output_enable)))));
	vcdp->fullBit  (c+122,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__memory_write)))));
	vcdp->fullBus  (c+127,(vlTOPp->v__DOT__uut__DOT__memory_address),23);
	vcdp->fullBit  (c+123,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_enable)))));
	vcdp->fullBit  (c+124,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_lower_enable)))));
	vcdp->fullBit  (c+125,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_upper_enable)))));
	vcdp->fullBit  (c+126,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__flash_enable)))));
	vcdp->fullBus  (c+318,(vlTOPp->v__DOT__cpu__DOT__acca),8);
	vcdp->fullBus  (c+319,(vlTOPp->v__DOT__cpu__DOT__accb),8);
	vcdp->fullBus  (c+320,(vlTOPp->v__DOT__cpu__DOT__cc),8);
	vcdp->fullBus  (c+321,(vlTOPp->v__DOT__cpu__DOT__dp),8);
	vcdp->fullBus  (c+322,(vlTOPp->v__DOT__cpu__DOT__xreg),16);
	vcdp->fullBus  (c+323,(vlTOPp->v__DOT__cpu__DOT__yreg),16);
	vcdp->fullBus  (c+324,(vlTOPp->v__DOT__cpu__DOT__sp),16);
	vcdp->fullBus  (c+325,(vlTOPp->v__DOT__cpu__DOT__up),16);
	vcdp->fullBus  (c+326,(vlTOPp->v__DOT__cpu__DOT__pc),16);
	vcdp->fullBus  (c+327,(vlTOPp->v__DOT__cpu__DOT__md),16);
	vcdp->fullBit  (c+328,(vlTOPp->v__DOT__cpu__DOT__ba));
	vcdp->fullBit  (c+329,(vlTOPp->v__DOT__cpu__DOT__bs));
	vcdp->fullBit  (c+333,(vlTOPp->v__DOT__LIC));
	vcdp->fullBit  (c+334,(vlTOPp->v__DOT__AVMA));
	vcdp->fullBit  (c+336,(vlTOPp->v__DOT__BUSY));
	vcdp->fullBit  (c+337,(vlTOPp->v__DOT__RamWait));
	vcdp->fullBit  (c+339,(vlTOPp->v__DOT__FlashStSts));
	vcdp->fullBus  (c+340,(vlTOPp->v__DOT__SW),8);
	vcdp->fullBus  (c+341,(vlTOPp->v__DOT__BTN),4);
	vcdp->fullBus  (c+342,(vlTOPp->v__DOT__ja),8);
	vcdp->fullBus  (c+343,(vlTOPp->v__DOT__jb),8);
	vcdp->fullBus  (c+344,(vlTOPp->v__DOT__dac),8);
	vcdp->fullBit  (c+331,(vlTOPp->v__DOT__clk25));
	vcdp->fullBit  (c+345,((1 & (IData)(vlTOPp->v__DOT__BTN))));
	vcdp->fullBit  (c+330,(vlTOPp->v__DOT__CLK));
	vcdp->fullBit  (c+346,(vlTOPp->v__DOT__uut__DOT__clock_50m_0));
	vcdp->fullBit  (c+347,(vlTOPp->v__DOT__uut__DOT__clock_50m_fb));
	vcdp->fullBit  (c+348,((1 & ((IData)(vlTOPp->v__DOT__SW) 
				     >> 6))));
	vcdp->fullBit  (c+349,((1 & ((IData)(vlTOPp->v__DOT__BTN) 
				     >> 1))));
	vcdp->fullBit  (c+350,((1 & ((IData)(vlTOPp->v__DOT__SW) 
				     >> 2))));
	vcdp->fullBit  (c+351,((1 & ((IData)(vlTOPp->v__DOT__SW) 
				     >> 1))));
	vcdp->fullBit  (c+352,((1 & (IData)(vlTOPp->v__DOT__SW))));
	vcdp->fullBus  (c+353,(1),8);
	vcdp->fullBit  (c+354,((1 & (IData)(vlTOPp->v__DOT__ja))));
	vcdp->fullBit  (c+355,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 1))));
	vcdp->fullBit  (c+356,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 2))));
	vcdp->fullBit  (c+357,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 3))));
	vcdp->fullBit  (c+358,((1 & ((IData)(vlTOPp->v__DOT__BTN) 
				     >> 3))));
	vcdp->fullBit  (c+359,((1 & ((IData)(vlTOPp->v__DOT__BTN) 
				     >> 2))));
	vcdp->fullBit  (c+360,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 4))));
	vcdp->fullBit  (c+361,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 5))));
	vcdp->fullBit  (c+362,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 7))));
	vcdp->fullBit  (c+363,((1 & ((IData)(vlTOPp->v__DOT__ja) 
				     >> 6))));
	vcdp->fullBit  (c+364,((1 & (IData)(vlTOPp->v__DOT__jb))));
	vcdp->fullBit  (c+365,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 1))));
	vcdp->fullBit  (c+366,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 2))));
	vcdp->fullBit  (c+367,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 3))));
	vcdp->fullBit  (c+368,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 7))));
	vcdp->fullBit  (c+369,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 4))));
	vcdp->fullBit  (c+370,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 5))));
	vcdp->fullBit  (c+371,((1 & ((IData)(vlTOPp->v__DOT__jb) 
				     >> 6))));
	vcdp->fullBus  (c+372,((0xf & (~ ((8 & (IData)(vlTOPp->v__DOT__jb)) 
					  | ((4 & (IData)(vlTOPp->v__DOT__jb)) 
					     | ((2 
						 & (IData)(vlTOPp->v__DOT__jb)) 
						| (1 
						   & (IData)(vlTOPp->v__DOT__jb)))))))),4);
	vcdp->fullBus  (c+373,((0xf & (~ ((8 & (IData)(vlTOPp->v__DOT__ja)) 
					  | ((4 & (IData)(vlTOPp->v__DOT__ja)) 
					     | ((2 
						 & (IData)(vlTOPp->v__DOT__ja)) 
						| (1 
						   & (IData)(vlTOPp->v__DOT__ja)))))))),4);
	vcdp->fullBus  (c+374,((0xf & (~ ((8 & ((IData)(vlTOPp->v__DOT__jb) 
						>> 4)) 
					  | ((4 & ((IData)(vlTOPp->v__DOT__jb) 
						   >> 4)) 
					     | ((2 
						 & ((IData)(vlTOPp->v__DOT__jb) 
						    >> 4)) 
						| (1 
						   & ((IData)(vlTOPp->v__DOT__jb) 
						      >> 4)))))))),4);
	vcdp->fullBus  (c+375,((0xf & (~ ((8 & ((IData)(vlTOPp->v__DOT__ja) 
						>> 4)) 
					  | ((4 & ((IData)(vlTOPp->v__DOT__ja) 
						   >> 4)) 
					     | ((2 
						 & ((IData)(vlTOPp->v__DOT__ja) 
						    >> 4)) 
						| (1 
						   & ((IData)(vlTOPp->v__DOT__ja) 
						      >> 4)))))))),4);
	vcdp->fullBit  (c+338,(1));
	vcdp->fullBit  (c+335,(0));
	vcdp->fullBit  (c+332,(vlTOPp->v__DOT__clk12));
    }
}
