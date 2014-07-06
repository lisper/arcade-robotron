#!/bin/sh

RTL=../robotron_cpu
GEN=../generated
SOUND=../robotron_sound
ROMS=../../roms/output

cver +define+debug=1 robotron_sound_test.v $SOUND/robotron_sound.v $SOUND/7442.v $SOUND/cpu68.v $SOUND/m6810.v $SOUND/pia6821.v $SOUND/rom_snd.v $ROMS/rom_snd_blocks.v
