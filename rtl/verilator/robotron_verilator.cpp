//
// robotron_verilator.cpp
//
//

#include <verilated.h>
#include <verilated_vcd_c.h>
#include "Vrobotron_verilator.h"

#include <iostream>

Vrobotron_verilator *top;                      // Instantiation of module

static unsigned long long main_time = 0;     // Current simulation time

void init_roms(void);

double sc_time_stamp () {       // Called by $time in Verilog
    return main_time;
}


int main(int argc, char** argv)
{
    VerilatedVcdC* tfp = NULL;
    Verilated::commandArgs(argc, argv);   // Remember args

    int show_waves = 0;
    int show_pc = 0;
    int show_loops = 0;

    int show_min_time = 0;
    int show_max_time = 0;
    int max_time = 0;
    int result = 0;
    int do_reset = 0;

    top = new Vrobotron_verilator;             // Create instance

    printf("built on: %s %s\n", __DATE__, __TIME__);

    // process local args
    for (int i = 0; i < argc; i++) {
	    if (argv[i][0] == '+') {
		    switch (argv[i][1]) {
		    case 'm': max_time = atoi(argv[i]+2); break;
		    case 'w': show_waves++; break;
		    case 'p': show_pc++; break;
		    case 'v': show_loops++; break;
		    case 'b': show_min_time = atoi(argv[i]+2); break;
		    case 'e': show_max_time = atoi(argv[i]+2); break;
		    case 'r': do_reset++; break;
		    default:
			    fprintf(stderr, "bad arg? %s\n", argv[i]);
			    exit(1);
		    }
	    }
    }

#ifdef VM_TRACE
    if (show_waves) {
	    Verilated::traceEverOn(true);
	    VL_PRINTF("Enabling waves...\n");
	    tfp = new VerilatedVcdC;
	    top->trace(tfp, 99);	// Trace 99 levels of hierarchy
	    tfp->open("verilator.vcd");	// Open the dump file

	    if (show_min_time)
		    printf("show_min_time=%d\n", (int)show_min_time);
	    if (show_max_time)
		    printf("show_max_time=%d\n", (int)show_max_time);
    }
#endif

    int old_clk = 1;
    int old_eclk = 1;

    init_roms();

    top->v__DOT__SW = 0x00;
    top->v__DOT__BTN = 0x0;
    top->v__DOT__ja = 0x0;
    top->v__DOT__jb = 0x0;

    // main loop
    while (!Verilated::gotFinish()) {

	if (show_loops) {
		VL_PRINTF("%llu; CLK=%d clock_e=%d BTN=%x RESET_N=%d\n",
			  main_time,
			  top->v__DOT__CLK,
			  top->v__DOT__uut__DOT__clock_e,
			  top->v__DOT__BTN,
			  top->v__DOT__RESET_N);
	}

	if (do_reset) {
		if (main_time > 5)
			top->v__DOT__BTN |= 0x1;
		if (main_time > 10)
			top->v__DOT__BTN &= ~0x1;
	}

	// coin
	if (1) {
#define COIN_TIME  120000000
#define START_TIME 140000000
		if (main_time >= COIN_TIME) {
			top->v__DOT__BTN |= 0x2;
			if (main_time == COIN_TIME) printf("DO COIN!\n");
		}
		if (main_time > (COIN_TIME+50000000))
			top->v__DOT__BTN &= ~0x2;

		// start
		if (main_time >= START_TIME) {
			top->v__DOT__BTN |= 0x8;
			if (main_time == START_TIME) printf("DO START!\n");
		}
		if (main_time > (START_TIME+50000000))
			top->v__DOT__BTN &= ~0x8;
	}

	// toggle clock(s)
	top->v__DOT__CLK = top->v__DOT__CLK ? 0 : 1;
	if (top->v__DOT__CLK) {
		top->v__DOT__clk25 = top->v__DOT__clk25 ? 0 : 1;

		if (top->v__DOT__clk25)
			top->v__DOT__clk12 = top->v__DOT__clk12 ? 0 : 1;
	}

	if (0)
		VL_PRINTF("clk %d %d %d\n",
			  top->v__DOT__CLK, top->v__DOT__clk25, top->v__DOT__clk12);

	// evaluate model
        top->eval();

#if 0
	//
	if (top->v__DOT__uut__DOT__rom_pia_cs &&
	    top->v__DOT__uut__DOT__rom_pia_write)
	{
		VL_PRINTF("%llu; pc=%04x rom_pia write %x %02x\n",
			  main_time,
			  top->v__DOT__cpu__DOT__pc,
			  top->v__DOT__uut__DOT__rom_pia_rs,
			  top->v__DOT__uut__DOT__mpu_data_out);
	}
#endif

        //
	if (top->v__DOT__uut__DOT__clock_e && old_eclk == 0)
	{
		if (show_pc)
			VL_PRINTF("%llu; pc=%04x A=%02x B=%02x X=%04x Y=%04x SP=%04x UP=%04x cc=%02x %s\n",
				  main_time,
				  top->v__DOT__cpu__DOT__pc,
				  top->v__DOT__cpu__DOT__acca,
				  top->v__DOT__cpu__DOT__accb,
				  top->v__DOT__cpu__DOT__xreg,
				  top->v__DOT__cpu__DOT__yreg,
				  top->v__DOT__cpu__DOT__sp,
				  top->v__DOT__cpu__DOT__up,
				  top->v__DOT__cpu__DOT__cc,
				  top->v__DOT__RESET_N ? "" : "(reset)");

		if (top->v__DOT__RESET_N ==  0) {
			VL_PRINTF("%llu; reset_count %d\n",
				  main_time,
				  top->v__DOT__uut__DOT__reset_counter);
		}
	}


	old_clk = top->v__DOT__CLK;
	old_eclk = top->v__DOT__uut__DOT__clock_e;

	if (max_time && main_time > max_time) {
		VL_PRINTF("%llu; MAX TIME pc %04x\n", main_time, top->v__DOT__cpu__DOT__pc);
		vl_finish("robotron_verilator.cpp",__LINE__,"");
		result = 2;
	}

#ifdef VM_TRACE
	if (tfp) {
		if (show_min_time == 0 && show_max_time == 0)
			tfp->dump(main_time);
		else
			if (show_min_time && main_time > show_min_time)
				tfp->dump(main_time);

		if (show_max_time && main_time > show_max_time)
			vl_finish("robotron_verilator.cpp",__LINE__,"");
	}
#endif

        main_time++;
    }

    top->final();

    if (tfp)
	    tfp->close();

    if (result)
	    exit(result);

    exit(0);
}

void init_roms(void)
{
}
