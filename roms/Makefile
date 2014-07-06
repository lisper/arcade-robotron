#
# Make source files from binary mame files
#

all: sound cmos decoder roms

#dac_out_wave.py
#make_rom_file_vlog_all.c
#make_rom_file_vhdl.py

roms: make_rom_file_vlog.c
	cc -o output/make_rom_file_vlog make_rom_file_vlog.c
	output/make_rom_file_vlog >output/roms.v


decoder:
	./make_decoder_vlog.py mame/robotron/decoder.4 >output/decoder_4.v
	./make_decoder_vlog.py mame/robotron/decoder.6 >output/decoder_6.v
	./make_decoder_vhdl.py mame/robotron/decoder.4 >output/decoder_4.vhd
	./make_decoder_vhdl.py mame/robotron/decoder.6 >output/decoder_6.vhd

sound:
	./make_sound_rom_vlog.py
	./make_sound_rom_vhdl.py

cmos: cmos.c cmos.txt
	cc -o ./output/cmos cmos.c
	./output/cmos <cmos.txt >./output/cmos.v

install: output/cmos.v output/roms.v output/decoder_4.v output/decoder_6.v
	cp output/cmos.v ../rtl/generated
	cp output/roms.v ../rtl/generated
	cp output/decoder_4.v ../rtl/generated
	cp output/decoder_6.v ../rtl/generated
	cp output/rom_snd_blocks.v ../rtl/generated

clean:
	rm -f output/*.v
	rm -f output/*.vhd
	rm -f output/cmos output/make_rom_file_vlog

