#!/bin/sh

RTL=../robotron_cpu
GEN=../generated
SOUND=../robotron_sound

cver +define+debug=1 +incdir+$GEN \
    robotron_cpu_tb.v robotron_cpu.v robotron_mem.v cpu09.v sc1.v mc6821.v $GEN/decoder_4.v $GEN/decoder_6.v led_decoder.v \
    $SOUND/robotron_sound.v $SOUND/cpu68.v $SOUND/m6810.v $SOUND/pia6821.v $SOUND/7442.v $SOUND/rom_snd.v $GEN/rom_snd_blocks.v
#sc1.v sc1_test.v
