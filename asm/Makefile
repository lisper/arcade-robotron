
disassembler: disassembler.c
	cc -o disassembler disassembler.c

f9dasm: f9dasm.c
	cc -o f9dasm f9dasm.c

emu/6809:
	(cd emu/6809; make)

clean:
	rm -f disassembler f9dasm
	(cd emu/6809; make clean)
o
