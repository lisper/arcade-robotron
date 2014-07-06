// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Prototypes for DPI import and export functions.
//
// Verilator includes this file in all generated .cpp files that use DPI functions.
// Manually include this file where DPI .c import functions are declared to insure
// the C functions match the expectations of the DPI imports.

#ifdef __cplusplus
extern "C" {
#endif
    
    
    // DPI IMPORTS
    // DPI Import at ../robotron_cpu/robotron_verilator.v:213
    extern void dpi_vga_display (int vsync, int hsync, int pixel);
    // DPI Import at ../robotron_cpu/robotron_verilator.v:210
    extern void dpi_vga_init (int h, int v);
    
#ifdef __cplusplus
}
#endif
