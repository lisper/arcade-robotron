/* convert cmos.txt file into verilog initial */
#include <stdio.h>
#include <stdlib.h>

main()
{
	int a, d, h, l;

	printf("// cmos initialization values");
	printf("initial begin\n");
	while (scanf("%x %x", &a, &d) == 2) {
		h = (d >> 4) & 0xf;
		h = (h << 4) | h;
		l = d & 0xf;
		l = (l << 4) | l;
		printf("ramh[16'h%04x] = 8'h%02x; raml[16'h%04x] = 8'h%02x; // %02x\n",
		       a, h, a, l, d);
	}
	printf("end\n");
	exit(0);
}
