#!/bin/sh

SD=../../roms/mame/robotron

dd if=/dev/zero of=rom.bin bs=1k count=64
dd if=$SD/robotron.sb1 of=rom.bin conv=notrunc
dd if=$SD/robotron.sb2 of=rom.bin conv=notrunc bs=4k seek=1
dd if=$SD/robotron.sb3 of=rom.bin conv=notrunc bs=4k seek=2
dd if=$SD/robotron.sb4 of=rom.bin conv=notrunc bs=4k seek=3
dd if=$SD/robotron.sb5 of=rom.bin conv=notrunc bs=4k seek=4
dd if=$SD/robotron.sb6 of=rom.bin conv=notrunc bs=4k seek=5
dd if=$SD/robotron.sb7 of=rom.bin conv=notrunc bs=4k seek=6
dd if=$SD/robotron.sb8 of=rom.bin conv=notrunc bs=4k seek=7
dd if=$SD/robotron.sb9 of=rom.bin conv=notrunc bs=4k seek=8

dd if=$SD/robotron.sba of=rom.bin conv=notrunc bs=4k seek=13
dd if=$SD/robotron.sbb of=rom.bin conv=notrunc bs=4k seek=14
dd if=$SD/robotron.sbc of=rom.bin conv=notrunc bs=4k seek=15
