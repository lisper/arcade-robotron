#!/bin/sh

#+loadvpi=../pli/mmc/pli_mmc.so:vpi_compat_bootstrap +incdir+../rtl

cver m6810_test.v m6810.v
#rom_snd.v ../../roms/output/rom_snd_blocks.v
