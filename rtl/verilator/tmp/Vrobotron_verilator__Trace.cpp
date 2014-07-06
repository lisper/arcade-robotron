// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals
#include "verilated_vcd_c.h"
#include "Vrobotron_verilator__Syms.h"


//======================

void Vrobotron_verilator::traceChg(VerilatedVcd* vcdp, void* userthis, uint32_t code) {
    // Callback from vcd->dump()
    Vrobotron_verilator* t=(Vrobotron_verilator*)userthis;
    Vrobotron_verilator__Syms* __restrict vlSymsp = t->__VlSymsp; // Setup global symbol table
    if (vlSymsp->getClearActivity()) {
	t->traceChgThis (vlSymsp, vcdp, code);
    }
}

//======================


void Vrobotron_verilator::traceChgThis(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	if (VL_UNLIKELY((1 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__2(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 5))))) {
	    vlTOPp->traceChgThis__3(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 9))))) {
	    vlTOPp->traceChgThis__4(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 9)) | (vlTOPp->__Vm_traceActivity 
					    >> 0xe))))) {
	    vlTOPp->traceChgThis__5(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 0xa))))) {
	    vlTOPp->traceChgThis__6(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((vlTOPp->__Vm_traceActivity 
			       | (vlTOPp->__Vm_traceActivity 
				  >> 0xb)) | (vlTOPp->__Vm_traceActivity 
					      >> 0xf))))) {
	    vlTOPp->traceChgThis__7(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 0xd))))) {
	    vlTOPp->traceChgThis__8(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 0xe))))) {
	    vlTOPp->traceChgThis__9(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & (vlTOPp->__Vm_traceActivity 
			      | (vlTOPp->__Vm_traceActivity 
				 >> 0xf))))) {
	    vlTOPp->traceChgThis__10(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((2 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__11(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((4 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__12(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((1 & ((vlTOPp->__Vm_traceActivity 
			       >> 2) | (vlTOPp->__Vm_traceActivity 
					>> 9))))) {
	    vlTOPp->traceChgThis__13(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((8 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__14(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x10 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__15(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x20 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__16(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x40 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__17(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x80 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__18(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x100 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__19(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x200 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__20(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x800 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__21(vlSymsp, vcdp, code);
	}
	if (VL_UNLIKELY((0x1000 & vlTOPp->__Vm_traceActivity))) {
	    vlTOPp->traceChgThis__22(vlSymsp, vcdp, code);
	}
    }
    // Final
    vlTOPp->__Vm_traceActivity = 0;
}

void Vrobotron_verilator::traceChgThis__2(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+1,(vlTOPp->v__DOT__mem__DOT__i),32);
    }
}

void Vrobotron_verilator::traceChgThis__3(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+2,(vlTOPp->v__DOT__cpu__DOT__saved_state),8);
    }
}

void Vrobotron_verilator::traceChgThis__4(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+4,(vlTOPp->v__DOT__uut__DOT__video_count_next),15);
	vcdp->chgBus  (c+5,(((0x4000 & (IData)(vlTOPp->v__DOT__uut__DOT__video_count_next))
			      ? 0x3f00 : 0)),14);
	vcdp->chgBus  (c+6,(vlTOPp->v__DOT__uut__DOT__address),16);
	vcdp->chgBit  (c+7,(vlTOPp->v__DOT__uut__DOT__write));
	vcdp->chgBit  (c+8,(vlTOPp->v__DOT__uut__DOT__read));
	vcdp->chgBit  (c+9,((0xc000 == (0xfc00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+10,((0xc804 == (0xff0c & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+11,((0xc80c == (0xff0c & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+12,((0xca00 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+13,((0xcb00 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+14,((0xcbfe == (0xfffe & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+15,((0xc900 == (0xff00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBit  (c+16,((0xcc00 == (0xfe00 & (IData)(vlTOPp->v__DOT__uut__DOT__address)))));
	vcdp->chgBus  (c+17,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access))
			       ? (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_pa_in)
			       : (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs)) 
				   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access)))
				   ? (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_a)
				   : ((1 == (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_rs))
				       ? (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
					   << 7) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
					    << 6) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output) 
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
					   ? 1 : ((
						   (2 
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
	vcdp->chgBus  (c+18,(vlTOPp->v__DOT__uut__DOT__rom_pia_pa_in),8);
	vcdp->chgBus  (c+19,(vlTOPp->v__DOT__uut__DOT__rom_led_digit),8);
	vcdp->chgBus  (c+20,(((2 & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
				    >> 2)) | (1 & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_ic4_y) 
						   >> 2)))),8);
	vcdp->chgBus  (c+21,(vlTOPp->v__DOT__uut__DOT__widget_ic3_y),4);
	vcdp->chgBus  (c+22,(vlTOPp->v__DOT__uut__DOT__widget_ic4_y),4);
	vcdp->chgBus  (c+23,((((IData)(vlTOPp->v__DOT__uut__DOT__screen_control) 
			       << 8) | (0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__address) 
						>> 8)))),9);
	vcdp->chgBus  (c+24,(vlTOPp->v__DOT__uut__DOT____Vcellinp__vertical_decoder__data),8);
	vcdp->chgBus  (c+25,(vlTOPp->v__DOT__uut__DOT__n_hCounter),12);
	vcdp->chgBus  (c+26,(vlTOPp->v__DOT__uut__DOT__n_vCounter),12);
	vcdp->chgBit  (c+27,(vlTOPp->v__DOT__uut__DOT__n_hSync));
	vcdp->chgBit  (c+28,(vlTOPp->v__DOT__uut__DOT__n_vSync));
	vcdp->chgBus  (c+29,(vlTOPp->v__DOT__uut__DOT__hoffset),4);
	vcdp->chgBus  (c+30,(((0x400 & ((~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter)) 
					<< 0xa)) | 
			      (0x3ff & ((((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						   << 2)) 
					  + (0x7c & 
					     ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      << 2))) 
					 + (0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2))) 
					+ (IData)(vlTOPp->v__DOT__uut__DOT__hoffset))))),11);
	vcdp->chgBus  (c+31,((0x3ff & ((((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						  << 2)) 
					 + (0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2))) 
					+ (0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						   << 2))) 
				       + (IData)(vlTOPp->v__DOT__uut__DOT__hoffset)))),10);
	vcdp->chgBus  (c+3,(vlTOPp->v__DOT__MemDB_out),16);
    }
}

void Vrobotron_verilator::traceChgThis__5(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+32,(((((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
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
					 << 6) | (((IData)(vlTOPp->v__DOT__uut__DOT__mpu_halted) 
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
	vcdp->chgBus  (c+33,((((0 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
			       & (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access))
			       ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_pa_in)
			       : (((0 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
				   & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access)))
				   ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_a)
				   : ((1 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs))
				       ? (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
					   << 7) | 
					  (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
					    << 6) | 
					   (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output) 
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
					   : (((2 == (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_rs)) 
					       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access)))
					       ? (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_b)
					       : ((3 
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
    }
}

void Vrobotron_verilator::traceChgThis__6(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+35,(vlTOPp->v__DOT__uut__DOT__memory_data_in),8);
	vcdp->chgBus  (c+34,(vlTOPp->v__DOT__MemDB_in),16);
    }
}

void Vrobotron_verilator::traceChgThis__7(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+36,((0xff & ((8 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
				       ? ((4 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					   ? ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					       ? ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__md) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__md))
					       : ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__pc) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__pc)))
					   : ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					       ? ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__sp) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__sp))
					       : ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__up) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__up))))
				       : ((4 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					   ? ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					       ? ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__yreg) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__yreg))
					       : ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? 
						  ((IData)(vlTOPp->v__DOT__cpu__DOT__xreg) 
						   >> 8)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__xreg)))
					   : ((2 & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
					       ? ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? (IData)(vlTOPp->v__DOT__cpu__DOT__dp)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__accb))
					       : ((1 
						   & (IData)(vlTOPp->v__DOT__cpu__DOT__dout_ctrl))
						   ? (IData)(vlTOPp->v__DOT__cpu__DOT__acca)
						   : (IData)(vlTOPp->v__DOT__cpu__DOT__cc))))))),8);
    }
}

void Vrobotron_verilator::traceChgThis__8(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+37,(vlTOPp->v__DOT__uut__DOT__reset_counter),8);
	vcdp->chgBit  (c+38,(vlTOPp->v__DOT__uut__DOT__reset));
    }
}

void Vrobotron_verilator::traceChgThis__9(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+40,(vlTOPp->v__DOT__uut__DOT__rom_access));
	vcdp->chgBit  (c+41,(vlTOPp->v__DOT__uut__DOT__ram_access));
	vcdp->chgBus  (c+42,(vlTOPp->v__DOT__uut__DOT__widget_pia_pa_in),8);
	vcdp->chgBus  (c+43,(vlTOPp->v__DOT__uut__DOT____Vcellinp__horizontal_decoder__data),8);
	vcdp->chgBit  (c+39,(vlTOPp->v__DOT__cpu_reset));
    }
}

void Vrobotron_verilator::traceChgThis__10(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+46,(vlTOPp->v__DOT__cpu_vma));
	vcdp->chgBus  (c+44,(vlTOPp->v__DOT__cpu_addr),16);
	vcdp->chgBit  (c+45,(vlTOPp->v__DOT__cpu_rw));
	vcdp->chgBit  (c+47,(vlTOPp->v__DOT__cpu__DOT__alu___05Fvalid_lo));
	vcdp->chgBit  (c+48,(vlTOPp->v__DOT__cpu__DOT__alu___05Fvalid_hi));
	vcdp->chgBit  (c+49,(vlTOPp->v__DOT__cpu__DOT__alu___05Fcarry_in));
	vcdp->chgBus  (c+50,(vlTOPp->v__DOT__cpu__DOT__alu___05Fdaa_reg),8);
	vcdp->chgBus  (c+51,(vlTOPp->v__DOT__cpu__DOT__cc_out),8);
	vcdp->chgBus  (c+52,(vlTOPp->v__DOT__cpu__DOT__left),16);
	vcdp->chgBus  (c+53,(vlTOPp->v__DOT__cpu__DOT__right),16);
	vcdp->chgBus  (c+54,(vlTOPp->v__DOT__cpu__DOT__out_alu),16);
	vcdp->chgBus  (c+55,(vlTOPp->v__DOT__cpu__DOT__next_state),8);
	vcdp->chgBus  (c+56,(vlTOPp->v__DOT__cpu__DOT__return_state),8);
	vcdp->chgBus  (c+57,(vlTOPp->v__DOT__cpu__DOT__st_ctrl),2);
	vcdp->chgBus  (c+58,(vlTOPp->v__DOT__cpu__DOT__pc_ctrl),3);
	vcdp->chgBus  (c+59,(vlTOPp->v__DOT__cpu__DOT__ea_ctrl),3);
	vcdp->chgBus  (c+60,(vlTOPp->v__DOT__cpu__DOT__op_ctrl),2);
	vcdp->chgBus  (c+61,(vlTOPp->v__DOT__cpu__DOT__pre_ctrl),2);
	vcdp->chgBus  (c+62,(vlTOPp->v__DOT__cpu__DOT__md_ctrl),3);
	vcdp->chgBus  (c+63,(vlTOPp->v__DOT__cpu__DOT__acca_ctrl),3);
	vcdp->chgBus  (c+64,(vlTOPp->v__DOT__cpu__DOT__accb_ctrl),2);
	vcdp->chgBus  (c+65,(vlTOPp->v__DOT__cpu__DOT__ix_ctrl),3);
	vcdp->chgBus  (c+66,(vlTOPp->v__DOT__cpu__DOT__iy_ctrl),3);
	vcdp->chgBus  (c+67,(vlTOPp->v__DOT__cpu__DOT__cc_ctrl),2);
	vcdp->chgBus  (c+68,(vlTOPp->v__DOT__cpu__DOT__dp_ctrl),2);
	vcdp->chgBus  (c+69,(vlTOPp->v__DOT__cpu__DOT__sp_ctrl),3);
	vcdp->chgBus  (c+70,(vlTOPp->v__DOT__cpu__DOT__up_ctrl),3);
	vcdp->chgBus  (c+71,(vlTOPp->v__DOT__cpu__DOT__iv_ctrl),4);
	vcdp->chgBus  (c+72,(vlTOPp->v__DOT__cpu__DOT__left_ctrl),4);
	vcdp->chgBus  (c+73,(vlTOPp->v__DOT__cpu__DOT__right_ctrl),4);
	vcdp->chgBus  (c+74,(vlTOPp->v__DOT__cpu__DOT__alu_ctrl),6);
	vcdp->chgBus  (c+75,(vlTOPp->v__DOT__cpu__DOT__addr_ctrl),4);
	vcdp->chgBus  (c+76,(vlTOPp->v__DOT__cpu__DOT__dout_ctrl),4);
	vcdp->chgBus  (c+77,(vlTOPp->v__DOT__cpu__DOT__nmi_ctrl),2);
	vcdp->chgBit  (c+78,(vlTOPp->v__DOT__cpu__DOT__cond_true));
    }
}

void Vrobotron_verilator::traceChgThis__11(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+79,(vlTOPp->v__DOT__uut__DOT__old_HAND));
	vcdp->chgBus  (c+80,(vlTOPp->v__DOT__uut__DOT__old_PB),6);
	vcdp->chgBus  (c+81,(vlTOPp->v__DOT__uut__DOT__old_BTN),4);
	vcdp->chgBus  (c+82,(vlTOPp->v__DOT__uut__DOT__old_rom_pia_pa_in),8);
    }
}

void Vrobotron_verilator::traceChgThis__12(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+84,(vlTOPp->v__DOT__uut__DOT__clock_q));
	vcdp->chgBus  (c+86,(vlTOPp->v__DOT__uut__DOT__led_counter),16);
	vcdp->chgBus  (c+87,((3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
				   >> 0xe))),2);
	vcdp->chgBus  (c+85,(((0 == (3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
					  >> 0xe)))
			       ? 0xe : ((1 == (3 & 
					       ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						>> 0xe)))
					 ? 0xd : ((2 
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
	vcdp->chgBus  (c+88,(vlTOPp->v__DOT__uut__DOT__old_widget_pia_pa_in),8);
	vcdp->chgBit  (c+83,(vlTOPp->v__DOT__uut__DOT__clock_e));
    }
}

void Vrobotron_verilator::traceChgThis__13(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+90,((0xf & ((0 == (3 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						 >> 0xe)))
				      ? (IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address)
				      : ((1 == (3 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						 >> 0xe)))
					  ? ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
					     >> 4) : 
					 ((2 == (3 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						    >> 0xe)))
					   ? ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
					      >> 8)
					   : ((3 == 
					       (3 & 
						((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
						 >> 0xe)))
					       ? ((IData)(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address) 
						  >> 0xc)
					       : 0)))))),4);
	vcdp->chgBus  (c+89,(((1 == (0xf & ((0 == (3 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__led_counter) 
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
					    ? 0x19 : 
					   ((5 == (0xf 
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
					     : ((6 
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
    }
}

void Vrobotron_verilator::traceChgThis__14(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+91,(vlTOPp->v__DOT__mem__DOT__ram_out),16);
	vcdp->chgBus  (c+92,(((0xf00 & ((IData)(vlTOPp->v__DOT__mem__DOT__rom_data) 
					<< 4)) | (0xf 
						  & (IData)(vlTOPp->v__DOT__mem__DOT__rom_data)))),16);
	vcdp->chgBus  (c+93,(vlTOPp->v__DOT__mem__DOT__rom_data),8);
    }
}

void Vrobotron_verilator::traceChgThis__15(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+94,(vlTOPp->v__DOT__cpu__DOT__nmi_req));
    }
}

void Vrobotron_verilator::traceChgThis__16(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+95,(vlTOPp->v__DOT__cpu__DOT__op_code),8);
	vcdp->chgBus  (c+96,(vlTOPp->v__DOT__cpu__DOT__pre_code),8);
	vcdp->chgBus  (c+97,(vlTOPp->v__DOT__cpu__DOT__ea),16);
	vcdp->chgBus  (c+98,(vlTOPp->v__DOT__cpu__DOT__iv),3);
	vcdp->chgBit  (c+99,(vlTOPp->v__DOT__cpu__DOT__nmi_ack));
	vcdp->chgBit  (c+100,(vlTOPp->v__DOT__cpu__DOT__nmi_enable));
	vcdp->chgBus  (c+101,(vlTOPp->v__DOT__cpu__DOT__state_stack[0]),8);
	vcdp->chgBus  (c+102,(vlTOPp->v__DOT__cpu__DOT__state_stack[1]),8);
	vcdp->chgBus  (c+103,(vlTOPp->v__DOT__cpu__DOT__state_stack[2]),8);
    }
}

void Vrobotron_verilator::traceChgThis__17(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+104,(vlTOPp->v__DOT__RESET_N));
	vcdp->chgBit  (c+105,(vlTOPp->v__DOT__NMI_N));
	vcdp->chgBit  (c+106,(vlTOPp->v__DOT__FIRQ_N));
	vcdp->chgBit  (c+107,(vlTOPp->v__DOT__IRQ_N));
	vcdp->chgBit  (c+108,(vlTOPp->v__DOT__HALT_N));
	vcdp->chgBit  (c+109,((1 & (~ (IData)(vlTOPp->v__DOT__IRQ_N)))));
	vcdp->chgBit  (c+110,((1 & (~ (IData)(vlTOPp->v__DOT__FIRQ_N)))));
	vcdp->chgBit  (c+111,((1 & (~ (IData)(vlTOPp->v__DOT__NMI_N)))));
	vcdp->chgBit  (c+112,((1 & (~ (IData)(vlTOPp->v__DOT__HALT_N)))));
    }
}

void Vrobotron_verilator::traceChgThis__18(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+116,(((0xe0 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
					<< 5)) | ((0x18 
						   & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
						      >> 1)) 
						  | (7 
						     & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
							>> 6))))),32);
	vcdp->chgBus  (c+113,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
				    >> 6))),3);
	vcdp->chgBus  (c+114,((7 & ((IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data) 
				    >> 3))),3);
	vcdp->chgBus  (c+115,((7 & (IData)(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data))),3);
	vcdp->chgBus  (c+117,(vlTOPp->v__DOT__uut__DOT__lb__DOT__r_data),9);
    }
}

void Vrobotron_verilator::traceChgThis__19(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+118,((0x20 == (IData)(vlTOPp->v__DOT__cpu__DOT__state))));
	vcdp->chgBus  (c+119,(vlTOPp->v__DOT__cpu__DOT__state),8);
    }
}

void Vrobotron_verilator::traceChgThis__20(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+130,(((IData)(vlTOPp->v__DOT__uut__DOT__r_hblank) 
			       | (IData)(vlTOPp->v__DOT__uut__DOT__r_vblank))));
	vcdp->chgBus  (c+133,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_hSync)))),32);
	vcdp->chgBus  (c+134,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vSync)))),32);
	vcdp->chgBus  (c+135,(vlTOPp->v__DOT__uut__DOT__clock_12_phase),12);
	vcdp->chgBit  (c+136,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				    >> 2))));
	vcdp->chgBit  (c+137,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				    >> 8))));
	vcdp->chgBit  (c+138,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				    >> 5))));
	vcdp->chgBus  (c+140,(vlTOPp->v__DOT__uut__DOT__video_count),15);
	vcdp->chgBus  (c+141,(vlTOPp->v__DOT__uut__DOT__video_address),14);
	vcdp->chgBit  (c+142,((0xf == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      >> 0xa)))));
	vcdp->chgBit  (c+143,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
				    >> 0xb))));
	vcdp->chgBit  (c+144,((0xe == (0xf & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					      >> 1)))));
	vcdp->chgBit  (c+145,((0x1f == (0x1f & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						>> 9)))));
	vcdp->chgBit  (c+146,(vlTOPp->v__DOT__uut__DOT__video_blank));
	vcdp->chgBus  (c+147,(vlTOPp->v__DOT__uut__DOT__vga_red),3);
	vcdp->chgBus  (c+148,(vlTOPp->v__DOT__uut__DOT__vga_green),3);
	vcdp->chgBus  (c+149,(vlTOPp->v__DOT__uut__DOT__vga_blue),3);
	vcdp->chgBus  (c+150,(vlTOPp->v__DOT__uut__DOT__debug_blt_source_address),16);
	vcdp->chgBus  (c+151,(vlTOPp->v__DOT__uut__DOT__mpu_address),16);
	vcdp->chgBus  (c+152,(vlTOPp->v__DOT__uut__DOT__mpu_data_in),8);
	vcdp->chgBit  (c+153,(vlTOPp->v__DOT__uut__DOT__mpu_bus_status));
	vcdp->chgBit  (c+154,(vlTOPp->v__DOT__uut__DOT__mpu_bus_available));
	vcdp->chgBit  (c+155,(vlTOPp->v__DOT__uut__DOT__mpu_read));
	vcdp->chgBit  (c+156,(vlTOPp->v__DOT__uut__DOT__mpu_write));
	vcdp->chgBit  (c+159,(((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				 & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en)) 
				| ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
				   & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
				      & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output))))) 
			       | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				   & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en)) 
				  | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
				     & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
					& (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output))))))));
	vcdp->chgBus  (c+160,(vlTOPp->v__DOT__uut__DOT__memory_address),16);
	vcdp->chgBus  (c+161,(vlTOPp->v__DOT__uut__DOT__memory_data_out),8);
	vcdp->chgBit  (c+162,(vlTOPp->v__DOT__uut__DOT__memory_output_enable));
	vcdp->chgBit  (c+163,(vlTOPp->v__DOT__uut__DOT__memory_write));
	vcdp->chgBit  (c+164,(vlTOPp->v__DOT__uut__DOT__flash_enable));
	vcdp->chgBit  (c+165,(vlTOPp->v__DOT__uut__DOT__ram_enable));
	vcdp->chgBit  (c+166,(vlTOPp->v__DOT__uut__DOT__ram_lower_enable));
	vcdp->chgBit  (c+167,(vlTOPp->v__DOT__uut__DOT__ram_upper_enable));
	vcdp->chgBit  (c+168,(vlTOPp->v__DOT__uut__DOT__e_rom));
	vcdp->chgBit  (c+169,(vlTOPp->v__DOT__uut__DOT__screen_control));
	vcdp->chgBus  (c+170,((0xfc & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
				       >> 6))),8);
	vcdp->chgBit  (c+131,((1 & (~ ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a) 
				       >> 7)))));
	vcdp->chgBus  (c+132,((0x3f & (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b))),6);
	vcdp->chgBus  (c+171,(vlTOPp->v__DOT__uut__DOT__rom_pia_rs),2);
	vcdp->chgBit  (c+172,(vlTOPp->v__DOT__uut__DOT__rom_pia_cs));
	vcdp->chgBit  (c+173,(vlTOPp->v__DOT__uut__DOT__rom_pia_write));
	vcdp->chgBus  (c+174,(vlTOPp->v__DOT__uut__DOT__rom_pia_data_in),8);
	vcdp->chgBit  (c+177,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en)) 
			       | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
				     & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))))));
	vcdp->chgBit  (c+182,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en)) 
			       | ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
				     & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))))));
	vcdp->chgBus  (c+185,(vlTOPp->v__DOT__uut__DOT__widget_pia_rs),2);
	vcdp->chgBit  (c+186,(vlTOPp->v__DOT__uut__DOT__widget_pia_cs));
	vcdp->chgBit  (c+187,(vlTOPp->v__DOT__uut__DOT__widget_pia_write));
	vcdp->chgBus  (c+188,(vlTOPp->v__DOT__uut__DOT__widget_pia_data_in),8);
	vcdp->chgBit  (c+191,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en)) 
			       | ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
				     & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output)))))));
	vcdp->chgBit  (c+196,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf) 
				& (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en)) 
			       | ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf) 
				  & ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
				     & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))))));
	vcdp->chgBus  (c+199,(vlTOPp->v__DOT__uut__DOT__blt_rs),3);
	vcdp->chgBit  (c+200,(vlTOPp->v__DOT__uut__DOT__blt_reg_cs));
	vcdp->chgBus  (c+201,(vlTOPp->v__DOT__uut__DOT__blt_reg_data_in),8);
	vcdp->chgBit  (c+202,((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->chgBit  (c+203,((3 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->chgBit  (c+204,(vlTOPp->v__DOT__uut__DOT__blt_blt_ack));
	vcdp->chgBus  (c+205,(((3 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_address)
			        : (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_address))),16);
	vcdp->chgBus  (c+206,(((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_substitution)
			        ? (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_value)
			        : (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data))),8);
	vcdp->chgBit  (c+207,((1 & ((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state)) 
				    | (~ ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_lower) 
					  | ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress) 
					     & (0 == 
						(0xf 
						 & (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data))))))))));
	vcdp->chgBit  (c+208,((1 & ((2 == (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state)) 
				    | (~ ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_upper) 
					  | ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress) 
					     & (0 == 
						(0xf 
						 & ((IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data) 
						    >> 4))))))))));
	vcdp->chgBus  (c+209,(vlTOPp->v__DOT__uut__DOT__color_table[0]),8);
	vcdp->chgBus  (c+210,(vlTOPp->v__DOT__uut__DOT__color_table[1]),8);
	vcdp->chgBus  (c+211,(vlTOPp->v__DOT__uut__DOT__color_table[2]),8);
	vcdp->chgBus  (c+212,(vlTOPp->v__DOT__uut__DOT__color_table[3]),8);
	vcdp->chgBus  (c+213,(vlTOPp->v__DOT__uut__DOT__color_table[4]),8);
	vcdp->chgBus  (c+214,(vlTOPp->v__DOT__uut__DOT__color_table[5]),8);
	vcdp->chgBus  (c+215,(vlTOPp->v__DOT__uut__DOT__color_table[6]),8);
	vcdp->chgBus  (c+216,(vlTOPp->v__DOT__uut__DOT__color_table[7]),8);
	vcdp->chgBus  (c+217,(vlTOPp->v__DOT__uut__DOT__color_table[8]),8);
	vcdp->chgBus  (c+218,(vlTOPp->v__DOT__uut__DOT__color_table[9]),8);
	vcdp->chgBus  (c+219,(vlTOPp->v__DOT__uut__DOT__color_table[10]),8);
	vcdp->chgBus  (c+220,(vlTOPp->v__DOT__uut__DOT__color_table[11]),8);
	vcdp->chgBus  (c+221,(vlTOPp->v__DOT__uut__DOT__color_table[12]),8);
	vcdp->chgBus  (c+222,(vlTOPp->v__DOT__uut__DOT__color_table[13]),8);
	vcdp->chgBus  (c+223,(vlTOPp->v__DOT__uut__DOT__color_table[14]),8);
	vcdp->chgBus  (c+224,(vlTOPp->v__DOT__uut__DOT__color_table[15]),8);
	vcdp->chgBus  (c+225,(vlTOPp->v__DOT__uut__DOT__pixel_nibbles),8);
	vcdp->chgBus  (c+226,(vlTOPp->v__DOT__uut__DOT__pixel_byte_l),8);
	vcdp->chgBus  (c+227,(vlTOPp->v__DOT__uut__DOT__pixel_byte_h),8);
	vcdp->chgBus  (c+228,((((IData)(vlTOPp->v__DOT__uut__DOT__screen_control) 
				<< 8) | (0xff & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						 >> 6)))),9);
	vcdp->chgBus  (c+229,(vlTOPp->v__DOT__uut__DOT__debug_last_mpu_address),16);
	vcdp->chgBus  (c+230,(vlTOPp->v__DOT__uut__DOT__r_advance),2);
	vcdp->chgBit  (c+231,((((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
				> 0x20) & ((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
					   < 0x154))));
	vcdp->chgBit  (c+232,(vlTOPp->v__DOT__uut__DOT__r_advance_video_count));
	vcdp->chgBit  (c+233,(vlTOPp->v__DOT__uut__DOT__r_clear_video_count));
	vcdp->chgBit  (c+234,(vlTOPp->v__DOT__uut__DOT__r_vblank));
	vcdp->chgBus  (c+235,(vlTOPp->v__DOT__uut__DOT__r_hCounter),12);
	vcdp->chgBus  (c+236,(vlTOPp->v__DOT__uut__DOT__r_vCounter),12);
	vcdp->chgBit  (c+237,(vlTOPp->v__DOT__uut__DOT__r_hblank));
	vcdp->chgBit  (c+238,(((IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter) 
			       >= 0x1f4)));
	vcdp->chgBit  (c+239,(((IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter) 
			       >= 0x154)));
	vcdp->chgBit  (c+157,((0 != (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__state))));
	vcdp->chgBit  (c+158,(vlTOPp->v__DOT__uut__DOT__mpu_halted));
	vcdp->chgBit  (c+240,(vlTOPp->v__DOT__uut__DOT__blt__DOT__span_src));
	vcdp->chgBit  (c+241,(vlTOPp->v__DOT__uut__DOT__blt__DOT__span_dst));
	vcdp->chgBit  (c+242,(vlTOPp->v__DOT__uut__DOT__blt__DOT__synchronize_e));
	vcdp->chgBit  (c+243,(vlTOPp->v__DOT__uut__DOT__blt__DOT__zero_write_suppress));
	vcdp->chgBit  (c+244,(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_substitution));
	vcdp->chgBit  (c+245,(vlTOPp->v__DOT__uut__DOT__blt__DOT__shift_right));
	vcdp->chgBit  (c+246,(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_lower));
	vcdp->chgBit  (c+247,(vlTOPp->v__DOT__uut__DOT__blt__DOT__suppress_upper));
	vcdp->chgBus  (c+248,(vlTOPp->v__DOT__uut__DOT__blt__DOT__constant_value),8);
	vcdp->chgBus  (c+249,(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_base),16);
	vcdp->chgBus  (c+250,(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_base),16);
	vcdp->chgBus  (c+251,(vlTOPp->v__DOT__uut__DOT__blt__DOT__width),9);
	vcdp->chgBus  (c+252,(vlTOPp->v__DOT__uut__DOT__blt__DOT__height),9);
	vcdp->chgBus  (c+253,(vlTOPp->v__DOT__uut__DOT__blt__DOT__state),2);
	vcdp->chgBus  (c+254,(vlTOPp->v__DOT__uut__DOT__blt__DOT__blt_src_data),8);
	vcdp->chgBus  (c+255,(vlTOPp->v__DOT__uut__DOT__blt__DOT__src_address),16);
	vcdp->chgBus  (c+256,(vlTOPp->v__DOT__uut__DOT__blt__DOT__dst_address),16);
	vcdp->chgBus  (c+257,(vlTOPp->v__DOT__uut__DOT__blt__DOT__x_count),9);
	vcdp->chgBus  (c+258,((0x1ff & ((IData)(1) 
					+ (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__x_count)))),9);
	vcdp->chgBus  (c+259,(vlTOPp->v__DOT__uut__DOT__blt__DOT__y_count),9);
	vcdp->chgBus  (c+260,((0x1ff & ((IData)(1) 
					+ (IData)(vlTOPp->v__DOT__uut__DOT__blt__DOT__y_count)))),9);
	vcdp->chgBit  (c+261,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia_write)))));
	vcdp->chgBit  (c+262,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_q));
	vcdp->chgBit  (c+263,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_q));
	vcdp->chgBit  (c+264,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_q));
	vcdp->chgBit  (c+265,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_q));
	vcdp->chgBus  (c+178,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a),8);
	vcdp->chgBus  (c+179,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_a),8);
	vcdp->chgBus  (c+266,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf) 
				<< 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf) 
					  << 6) | (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output) 
						    << 5) 
						   | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_4) 
						       << 4) 
						      | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
							  << 3) 
							 | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access) 
							     << 2) 
							    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_edge) 
								<< 1) 
							       | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en))))))))),8);
	vcdp->chgBit  (c+267,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_1_intf));
	vcdp->chgBit  (c+268,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqa_2_intf));
	vcdp->chgBit  (c+176,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output));
	vcdp->chgBit  (c+269,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_4));
	vcdp->chgBit  (c+270,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3));
	vcdp->chgBit  (c+271,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_a_access));
	vcdp->chgBit  (c+272,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_edge));
	vcdp->chgBit  (c+273,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca1_int_en));
	vcdp->chgBit  (c+274,(((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_a_3) 
			       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))));
	vcdp->chgBit  (c+275,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_is_output)))));
	vcdp->chgBit  (c+175,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ca2_out_value));
	vcdp->chgBus  (c+183,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b),8);
	vcdp->chgBus  (c+184,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__ddr_b),8);
	vcdp->chgBus  (c+276,((((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf) 
				<< 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf) 
					  << 6) | (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output) 
						    << 5) 
						   | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_4) 
						       << 4) 
						      | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
							  << 3) 
							 | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access) 
							     << 2) 
							    | (((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_edge) 
								<< 1) 
							       | (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en))))))))),8);
	vcdp->chgBit  (c+277,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_1_intf));
	vcdp->chgBit  (c+278,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__irqb_2_intf));
	vcdp->chgBit  (c+181,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output));
	vcdp->chgBit  (c+279,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_4));
	vcdp->chgBit  (c+280,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3));
	vcdp->chgBit  (c+281,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__output_b_access));
	vcdp->chgBit  (c+282,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_edge));
	vcdp->chgBit  (c+283,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb1_int_en));
	vcdp->chgBit  (c+284,(((IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cr_b_3) 
			       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))));
	vcdp->chgBit  (c+285,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_is_output)))));
	vcdp->chgBit  (c+180,(vlTOPp->v__DOT__uut__DOT__rom_pia__DOT__cb2_out_value));
	vcdp->chgBit  (c+139,((1 & ((IData)(vlTOPp->v__DOT__uut__DOT__clock_12_phase) 
				    >> 0xb))));
	vcdp->chgBit  (c+286,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia_write)))));
	vcdp->chgBit  (c+287,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_q));
	vcdp->chgBit  (c+288,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_q));
	vcdp->chgBit  (c+289,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_q));
	vcdp->chgBit  (c+290,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_q));
	vcdp->chgBus  (c+192,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a),8);
	vcdp->chgBus  (c+193,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_a),8);
	vcdp->chgBus  (c+291,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf) 
				<< 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf) 
					  << 6) | (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output) 
						    << 5) 
						   | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_4) 
						       << 4) 
						      | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
							  << 3) 
							 | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access) 
							     << 2) 
							    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_edge) 
								<< 1) 
							       | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en))))))))),8);
	vcdp->chgBit  (c+292,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_1_intf));
	vcdp->chgBit  (c+293,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqa_2_intf));
	vcdp->chgBit  (c+190,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output));
	vcdp->chgBit  (c+294,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_4));
	vcdp->chgBit  (c+295,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3));
	vcdp->chgBit  (c+296,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_a_access));
	vcdp->chgBit  (c+297,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_edge));
	vcdp->chgBit  (c+298,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca1_int_en));
	vcdp->chgBit  (c+299,(((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_a_3) 
			       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_is_output)))));
	vcdp->chgBit  (c+189,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ca2_out_value));
	vcdp->chgBus  (c+197,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b),8);
	vcdp->chgBus  (c+198,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__ddr_b),8);
	vcdp->chgBus  (c+300,((((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf) 
				<< 7) | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf) 
					  << 6) | (
						   ((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output) 
						    << 5) 
						   | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_4) 
						       << 4) 
						      | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
							  << 3) 
							 | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access) 
							     << 2) 
							    | (((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_edge) 
								<< 1) 
							       | (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en))))))))),8);
	vcdp->chgBit  (c+301,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_1_intf));
	vcdp->chgBit  (c+302,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__irqb_2_intf));
	vcdp->chgBit  (c+195,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output));
	vcdp->chgBit  (c+303,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_4));
	vcdp->chgBit  (c+304,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3));
	vcdp->chgBit  (c+305,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__output_b_access));
	vcdp->chgBit  (c+306,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_edge));
	vcdp->chgBit  (c+307,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb1_int_en));
	vcdp->chgBit  (c+308,(((IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cr_b_3) 
			       & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))));
	vcdp->chgBit  (c+309,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_is_output)))));
	vcdp->chgBit  (c+194,(vlTOPp->v__DOT__uut__DOT__widget_pia__DOT__cb2_out_value));
	vcdp->chgBit  (c+128,(vlTOPp->v__DOT__uut__DOT__r_hSync));
	vcdp->chgBit  (c+129,(vlTOPp->v__DOT__uut__DOT__r_vSync));
	vcdp->chgBus  (c+310,((0x1f & (IData)(vlTOPp->v__DOT__uut__DOT__video_address))),12);
	vcdp->chgBus  (c+311,((0x1ff & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					>> 5))),12);
	vcdp->chgBus  (c+312,(((0x400 & ((IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter) 
					 << 0xa)) | 
			       (0x3ff & (IData)(vlTOPp->v__DOT__uut__DOT__r_hCounter)))),11);
	vcdp->chgBit  (c+313,((1 & (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter))));
	vcdp->chgBit  (c+314,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__r_vCounter)))));
	vcdp->chgBus  (c+315,((((IData)(vlTOPp->v__DOT__uut__DOT__vga_red) 
				<< 6) | (((IData)(vlTOPp->v__DOT__uut__DOT__vga_green) 
					  << 3) | (IData)(vlTOPp->v__DOT__uut__DOT__vga_blue)))),9);
	vcdp->chgBus  (c+316,((0x3ff & (((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						  << 2)) 
					 + (0x7c & 
					    ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
					     << 2))) 
					+ (0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
						   << 2))))),10);
	vcdp->chgBus  (c+317,((0x7c & ((IData)(vlTOPp->v__DOT__uut__DOT__video_address) 
				       << 2))),10);
	vcdp->chgBus  (c+120,(vlTOPp->v__DOT__uut__DOT__mpu_data_out),8);
	vcdp->chgBit  (c+121,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__memory_output_enable)))));
	vcdp->chgBit  (c+122,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__memory_write)))));
	vcdp->chgBus  (c+127,(vlTOPp->v__DOT__uut__DOT__memory_address),23);
	vcdp->chgBit  (c+123,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_enable)))));
	vcdp->chgBit  (c+124,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_lower_enable)))));
	vcdp->chgBit  (c+125,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__ram_upper_enable)))));
	vcdp->chgBit  (c+126,((1 & (~ (IData)(vlTOPp->v__DOT__uut__DOT__flash_enable)))));
    }
}

void Vrobotron_verilator::traceChgThis__21(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBus  (c+318,(vlTOPp->v__DOT__cpu__DOT__acca),8);
	vcdp->chgBus  (c+319,(vlTOPp->v__DOT__cpu__DOT__accb),8);
	vcdp->chgBus  (c+320,(vlTOPp->v__DOT__cpu__DOT__cc),8);
	vcdp->chgBus  (c+321,(vlTOPp->v__DOT__cpu__DOT__dp),8);
	vcdp->chgBus  (c+322,(vlTOPp->v__DOT__cpu__DOT__xreg),16);
	vcdp->chgBus  (c+323,(vlTOPp->v__DOT__cpu__DOT__yreg),16);
	vcdp->chgBus  (c+324,(vlTOPp->v__DOT__cpu__DOT__sp),16);
	vcdp->chgBus  (c+325,(vlTOPp->v__DOT__cpu__DOT__up),16);
	vcdp->chgBus  (c+326,(vlTOPp->v__DOT__cpu__DOT__pc),16);
	vcdp->chgBus  (c+327,(vlTOPp->v__DOT__cpu__DOT__md),16);
    }
}

void Vrobotron_verilator::traceChgThis__22(Vrobotron_verilator__Syms* __restrict vlSymsp, VerilatedVcd* vcdp, uint32_t code) {
    Vrobotron_verilator* __restrict vlTOPp VL_ATTR_UNUSED = vlSymsp->TOPp;
    int c=code;
    if (0 && vcdp && c) {}  // Prevent unused
    // Body
    {
	vcdp->chgBit  (c+328,(vlTOPp->v__DOT__cpu__DOT__ba));
	vcdp->chgBit  (c+329,(vlTOPp->v__DOT__cpu__DOT__bs));
    }
}
