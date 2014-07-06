
all:
	cd roms && make
	cd asm && make
	cd utils && make
	cd rtl && make

clean:
	cd roms && make clean
	cd asm && make clean
	cd utils && make clean
	cd rtl && make clean


