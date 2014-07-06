#!/bin/sh -x

#V=verilator
V=/usr/local/bin/verilator

TOP="--top-module robotron_verilator"
RTL=../robotron_cpu
SOUND=../robotron_sound
GEN=../generated
INC="+incdir+$RTL +incdir+$GEN"

#$V -cc -exe --trace --Mdir ./tmp +define+debug=1 $TOP  robotron_verilator.v robotron_cpu.v robotron_mem.v cpu09.v sc1.v mc6821.v decoder_4.v decoder_6.v led_decoder.v robotron_verilator.cpp &&
#(cd tmp; make OPT="-O2" -f Vrobotron_verilator.mk)

$V -cc -LDFLAGS "-lSDL -lpthread" -exe --trace --Mdir ./tmp +define+debug=1 $INC $TOP  \
    $RTL/robotron_verilator.v $RTL/robotron_cpu.v $RTL/robotron_mem.v $RTL/cpu09.v $RTL/sc1.v $RTL/mc6821.v $GEN/decoder_4.v $GEN/decoder_6.v $RTL/led_decoder.v robotron_verilator.cpp vga.cpp  \
    $SOUND/robotron_sound.v $SOUND/cpu68.v $SOUND/m6810.v $SOUND/pia6821.v $SOUND/7442.v $SOUND/rom_snd.v $GEN/rom_snd_blocks.v && 
(cd tmp; make OPT="-O -fno-auto-inc-dec -fno-compare-elim -fno-cprop-registers -fno-dce -fno-defer-pop -fno-delayed-branch -fno-dse -fno-guess-branch-probability -fno-if-conversion2 -fno-if-conversion -fno-ipa-pure-const -fno-ipa-profile -fno-ipa-reference -fno-merge-constants -fno-split-wide-types -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-copyrename -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-forwprop -fno-tree-fre -fno-tree-phiprop -fno-tree-sra -fno-tree-pta -fno-tree-ter -fno-unit-at-a-time" -f Vrobotron_verilator.mk)
#(cd tmp; make -f Vrobotron_verilator.mk)

