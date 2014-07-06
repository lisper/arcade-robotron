
#V = verilator
V = /usr/local/bin/verilator

TOP = --top-module robotron_verilator
RTL = ../robotron_cpu
SOUND = ../robotron_sound
GEN = ../generated
INC = +incdir+$(RTL) +incdir+$(GEN)

LDFLAGS = "-lSDL -lpthread"
DEFINE = +define+debug=1
EXE = tmp/Vrobotron_verilator

VOUT = tmp/Vrobotron_verilator.cpp

SRC = \
	$(RTL)/robotron_verilator.v $(RTL)/robotron_cpu.v $(RTL)/robotron_mem.v $(RTL)/cpu09.v $(RTL)/sc1.v $(RTL)/mc6821.v \
	$(GEN)/decoder_4.v $(GEN)/decoder_6.v $(RTL)/led_decoder.v \
	$(SOUND)/robotron_sound.v $(SOUND)/cpu68.v $(SOUND)/m6810.v $(SOUND)/pia6821.v $(SOUND)/7442.v $(SOUND)/rom_snd.v \
	$(GEN)/rom_snd_blocks.v \
	robotron_verilator.cpp vga.cpp

OPT = "-O -fno-auto-inc-dec -fno-compare-elim -fno-cprop-registers -fno-dce -fno-defer-pop -fno-delayed-branch -fno-dse -fno-guess-branch-probability -fno-if-conversion2 -fno-if-conversion -fno-ipa-pure-const -fno-ipa-profile -fno-ipa-reference -fno-merge-constants -fno-split-wide-types -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-copyrename -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-forwprop -fno-tree-fre -fno-tree-phiprop -fno-tree-sra -fno-tree-pta -fno-tree-ter -fno-unit-at-a-time"

#OPT = -O

#OPT = "-O -fno-auto-inc-dec -fno-compare-elim -fno-cprop-registers -fno-dce -fno-defer-pop -fno-delayed-branch -fno-dse -fno-guess-branch-probability -fno-if-conversion2 -fno-if-conversion -fno-ipa-pure-const -fno-ipa-profile -fno-ipa-reference -fno-merge-constants -fno-split-wide-types -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-copyrename -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-forwprop"

#OPT = "-O -fno-auto-inc-dec -fno-compare-elim -fno-cprop-registers -fno-dce -fno-defer-pop -fno-delayed-branch -fno-dse -fno-guess-branch-probability -fno-if-conversion2 -fno-if-conversion -fno-ipa-pure-const -fno-ipa-profile -fno-ipa-reference -fno-merge-constants -fno-split-wide-types -fno-tree-bit-ccp -fno-tree-builtin-call-dce -fno-tree-ccp -fno-tree-ch -fno-tree-copyrename -fno-tree-dce -fno-tree-dominator-opts -fno-tree-dse -fno-tree-forwprop -fno-tree-phiprop -fno-tree-sra -fno-tree-pta -fno-tree-ter -fno-unit-at-a-time"

all: $(EXE)

clean:
	rm -f tmp/*

$(VOUT): $(SRC)
	$V -cc -LDFLAGS $(LDFLAGS) -exe --trace --Mdir ./tmp $(DEFINE) $(INC) $(TOP) $(SRC)

$(EXE): $(VOUT)
	(cd tmp; make OPT=$(OPT) -f Vrobotron_verilator.mk)

slow:
	(cd tmp; make -f Vrobotron_verilator.mk)


