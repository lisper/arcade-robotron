#!/bin/sh

RTL=../robotron_cpu
GEN=../generated
SOUND=../robotron_sound

cver +define+debug=1 +incdir+$GEN \
    robotron_cpu_tb.v $RTL/robotron_cpu.v $RTL/robotron_mem.v $RTL/cpu09.v $RTL/sc1.v $RTL/mc6821.v $RTL/line_buffer.v \
    $GEN/decoder_4.v $GEN/decoder_6.v $RTL/led_decoder.v \
    $SOUND/robotron_sound.v $SOUND/cpu68.v $SOUND/m6810.v $SOUND/pia6821.v $SOUND/7442.v $SOUND/rom_snd.v $GEN/rom_snd_blocks.v
#sc1.v sc1_test.v
