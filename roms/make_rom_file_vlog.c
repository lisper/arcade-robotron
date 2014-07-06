/* read binary mame rom files and generate verilog initial code */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>

unsigned char d[4096];

struct {
	int ch;
	int off;
} rom_map[] = {
        '1', 0x0000,
        '2', 0x1000,
        '3', 0x2000,
        '4', 0x3000,
        '5', 0x4000,
        '6', 0x5000,
        '7', 0x6000,
        '8', 0x7000,
        '9', 0x8000,
        'a', 0xd000,
        'b', 0xe000,
        'c', 0xf000,
};

main()
{
	int n, i, f, r, a;
	char name[1024];

	printf("initial begin\n");

	for (n = 0; n < 12; n++) {
		int c;
		c = rom_map[n].ch;
		a = rom_map[n].off;
		sprintf(name, "mame/robotron/robotron.sb%c", c);
		f = open(name, O_RDONLY);
		if (f < 0) { perror(name); exit(1); }
		r = read(f, d, 4096);
		if (r != 4096) { printf("read error\n"); exit(2); }
		close(f);

		printf("\t// %s @ %04x\n", name, a);
		for (i = 0; i < 4096; i++) {
			printf("\trom%c[%d] = 8'h%02x; // 0x%04x\n", c, i, d[i], i+a);
		}
	}

	printf("end\n");
	exit(0);
}
