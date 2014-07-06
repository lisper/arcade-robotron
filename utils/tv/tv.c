
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>

#include <SDL/SDL.h>

typedef unsigned int u32;
typedef unsigned char u8;

#define HH 384
#define VV 256
u8 fb[64*1024];

int mag = 1;

static SDL_Surface *screen;

int debug;

unsigned char cmap[16] = {
	0x00, 0x11, 0x22, 0x33,
	0x44, 0x50, 0x60, 0x80,
	0x90, 0xa0, 0xb0, 0xc0,
	0xd0, 0xe0, 0xf0, 0xff,
};

int sdl_init(void)
{
	int flags, rows, cols;

	cols = HH;
	rows = VV;

	flags = SDL_INIT_VIDEO | SDL_INIT_NOPARACHUTE;

	if (SDL_Init(flags)) {
		printf("SDL initialization failed\n");
		return -1;
	}

	/* NOTE: we still want Ctrl-C to work - undo the SDL redirections*/
	signal(SIGINT, SIG_DFL);
	signal(SIGQUIT, SIG_DFL);

	flags = SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_HWACCEL;
	
	screen = SDL_SetVideoMode(cols*mag, rows*mag, 8, flags);

	if (!screen) {
		printf("Could not open SDL display\n");
		return -1;
	}

	SDL_WM_SetCaption("tv", "tv");

	return 0;
}

void sdl_update(int h, int v)
{
	if (!screen)
		return;

	SDL_UpdateRect(screen, h, v, 2*mag, 1*mag);
}

void sdl_update_all(void)
{
	if (!screen)
		return;

	SDL_UpdateRect(screen, 0, 0, HH*mag, VV*mag);
}

void sdl_poll(void)
{
	SDL_Event ev1, *ev = &ev1;
	if (screen)
		SDL_PollEvent(ev);
}
	      
main(int argc, char *argv[])
{
	char line[1024];
	unsigned int i, h, v, bits, aoffset, offset, addr, show;
	unsigned char *ps;
	int do_window, do_set, do_show, do_wait;
	int eh, el;
	FILE *fin;

	do_window = 1;
	do_set = 1;
	do_show = 0;
	do_wait = 0;
	fin = stdin;

	for (i = 1; i < argc; i++) {
		if (argv[i][0] == '-')
			switch (argv[i][1]) {
			case 'n': do_window = 0; break;
			case 'f': fin = fopen(argv[i+1], "r"); i++; break;
			case 's': do_show++; break;
			case 'x': do_set = 0; break;
			case 'w': do_wait = 1; break;
			case 'd': debug++; break;
			}
	}

	if (do_window)
		sdl_init();

	ps = screen ? screen->pixels : NULL;

	while (fgets(line, sizeof(line), fin)) {

		if (do_show > 1)
			printf("%s", line);

		if (line[0] == 'r' && line[1] == 'o')
			;
		else
			continue;

		if (line[30] != '<')
			continue;

		if (debug) printf("%s", line);


		sscanf(line, "robotron_mem: ram addr=%x <= %x (%d)",
		       &addr, &bits, &eh);

		if (addr >= 0xc000)
			continue;

		el = eh % 10;
		eh = eh / 10;

		aoffset = addr;
		fb[aoffset] = bits;

		if (1)
		{
			int off, top;
			off = aoffset & 0x3fff;
			top = (aoffset & 0xc000) >> 14;
			aoffset = (off * 3) + top;
		}

		v = aoffset / (HH/2);
		h = aoffset % (HH/2);
		h = h * 2;

		offset = (v*mag * HH*mag) + h*mag;

		if (do_show) {
			printf("addr=%x, offset=%x v=%d, h=%d bits=%x\n",
			       addr, aoffset, v, h, bits);
			//printf("line: %s\n", line);
		}

		if (!ps)
			continue;

		if (do_wait) {
			char l[1024];
			if (bits) { printf("(%d, %d) %x?\n", h, v, bits); gets(l); }
		}

		if (mag == 1) {
			ps[offset + 0] = cmap[ (bits >> 8) & 0xf ];
			ps[offset + 1] = cmap[ bits & 0xf ];
		} else {
			ps[offset + 0] = cmap[ (bits >> 8) & 0xf ];
			ps[offset + 1] = cmap[ (bits >> 8) & 0xf ];

			ps[offset + 0 + HH*2] = cmap[ (bits >> 8) & 0xf ];
			ps[offset + 1 + HH*2] = cmap[ (bits >> 8) & 0xf ];

			ps[offset + 2] = cmap[ bits & 0xf ];
			ps[offset + 3] = cmap[ bits & 0xf ];

			ps[offset + 2 + HH*2] = cmap[ bits & 0xf ];
			ps[offset + 3 + HH*2] = cmap[ bits & 0xf ];
		}

		sdl_update(h, v);
	}

	printf("done!\n");
	sdl_update_all();

	while (screen) {
		sdl_poll();
	}

	exit(0);
}

