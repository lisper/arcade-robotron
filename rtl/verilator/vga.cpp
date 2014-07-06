#include "svdpi.h"
#include <signal.h>
#include "Vrobotron_verilator__Dpi.h"

#ifdef _WIN32
#include "SDL.h"
#else
#include <SDL/SDL.h>
#endif

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif

static SDL_Surface *screen;
static int rows, cols;
static unsigned int row_sink, col_sink;
//static unsigned int col_hsync, row_vsync;
static unsigned int old_hsync, old_vsync;
static unsigned int pw_hsync, pw_vsync;
static int show_vis;
static int show_stats;

static struct {
    int hpol, vpol;
    unsigned int pw_hsync_hi, pw_hsync_lo;
    unsigned int pw_vsync_hi, pw_vsync_lo;
    unsigned int cols_h, rows_v, cols_hsync, rows_vsync;
    
} stats;

static void init_stats(void)
{
    stats.hpol = -1;
    stats.vpol = -1;
    stats.cols_h = -1;
    stats.rows_v = -1;
    stats.cols_hsync = -1;
    stats.rows_vsync = -1;
}

static void dump_stats(void)
{
    printf("vga: ");
    printf("hpol:%s ", stats.hpol >= 0 ? (stats.hpol > 0 ? "+" : "-") : "unknown");
    printf("vpol:%s ", stats.vpol >= 0 ? (stats.vpol > 0 ? "+" : "-") : "unknown");
    printf("hpw: hi%d lo%d ", stats.pw_hsync_hi, stats.pw_hsync_lo);
    printf("vpw: hi%d lo%d ", stats.pw_vsync_hi, stats.pw_vsync_lo);
    printf("hcols:%d ", stats.cols_h);
    printf("hcols sync:%d ", stats.cols_hsync);
    printf("vlines:%d ", stats.rows_v);
    printf("vlines sync:%d ", stats.rows_vsync);
    printf("\n");
}

void dpi_vga_init(int h, int v)
{
    int flags;

    cols = h;
    rows = v;

    show_vis = 0;
    show_stats = 0;

    printf("Initialize display %dx%d\n", cols, rows);

    flags = SDL_INIT_VIDEO | SDL_INIT_NOPARACHUTE;

    if (SDL_Init(flags)) {
        printf("SDL initialization failed\n");
        return;
    }

    /* NOTE: we still want Ctrl-C to work - undo the SDL redirections*/
    signal(SIGINT, SIG_DFL);
    signal(SIGQUIT, SIG_DFL);

    flags = SDL_HWSURFACE|SDL_ASYNCBLIT|SDL_HWACCEL;

    screen = SDL_SetVideoMode(cols, rows+8, 8, flags);

    if (!screen) {
        printf("Could not open SDL display\n");
        return;
    }

    SDL_WM_SetCaption("Image", "Image");

    row_sink = 0;
    col_sink = 0;
//    col_hsync = 0;
//    row_vsync = 0;
}


//static int eol;
//static int eof;

void dpi_vga_display(int vsync, int hsync, int pixel)
{
    unsigned char *ps;
    int offset, hedge, vedge;

    if(screen == NULL) {
        printf("Error: display not initialized\n");
        return;
    }

    /* edge detect */
    hedge = 0;
    vedge = 0;

    if (vsync != old_vsync) 
    {
        vedge++;

        if (vsync)
            stats.pw_vsync_lo = pw_vsync;
        else
            stats.pw_vsync_hi = pw_vsync;

        /* record polarity if we have not yet */
        if (stats.vpol < 0 && stats.pw_vsync_lo && stats.pw_vsync_hi) {
            if (stats.pw_vsync_lo > stats.pw_vsync_hi)
                stats.vpol = +1;
            else
                if (stats.pw_vsync_lo < stats.pw_vsync_hi)
                    stats.vpol = 0;
        }

        old_vsync = vsync;
        pw_vsync = 0;
    } else
        pw_vsync++;

    if (hsync != old_hsync) {
        hedge++;

        if (hsync)
            stats.pw_hsync_lo = pw_hsync;
        else
            stats.pw_hsync_hi = pw_hsync;

        /* record polarity if we have not yet */
        if (stats.hpol < 0 && stats.pw_hsync_lo > 0 && stats.pw_hsync_hi > 0) {
            if (stats.pw_hsync_lo > stats.pw_hsync_hi)
                stats.hpol = +1;
            else
                if (stats.pw_hsync_lo < stats.pw_hsync_hi)
                    stats.hpol = 0;
        }

        old_hsync = hsync;
        pw_hsync = 0;
    } else
        pw_hsync++;

    /* end of vblank? */
    if (vedge) {
        if (vsync != stats.vpol) {
            /* end of pulse */
            if (show_vis) printf("vga: visable lines %d\n", row_sink);
            if (0) printf("Frame Complete\n");
            if (show_stats) dump_stats();
	    SDL_UpdateRect(screen, 0, 0, cols, rows);

            stats.rows_vsync = row_sink - stats.rows_v + 1;
            row_sink = col_sink = 0;
            return;
        } else {
            stats.rows_v = row_sink;
        }
    }

    /* end of hblank? */
    if (hedge) {
        if (hsync != stats.hpol) {
            /* end of pulse */
            if (show_vis) printf("vga: visable h pixels %d\n", col_sink);
            row_sink++;
            stats.cols_hsync = col_sink - stats.cols_h + 1;
            col_sink = 0;
            return;
        } else {
            stats.cols_h = col_sink;
        }
    }

#if 0
    if (vsync == 0)
    {
        if(eof) {
            eof = 0;
            if (show_vis) printf("vga: visable lines %d\n", row_sink);
            if (0) printf("Frame Complete\n");
            if (show_stats) dump_stats();
	    SDL_UpdateRect(screen, 0, 0, 256, 304);
            row_vsync = 0;
        }
        row_vsync++;
        row_sink = col_sink = 0;
        eol = 0;
        return;
    } else {
        if (row_vsync) {
            if (show_vis) printf("vga: invisable v lines %d\n", row_vsync);
            row_vsync = 0;
        }
    }

    if (hsync == 0)
    {
        if (eol) {
            if (show_vis) printf("vga: visable h pixels %d\n", col_sink);
            row_sink++;
            col_hsync = 0;
        }
        col_hsync++;
        eol = 0;
        col_sink = 0;
        return;
    } else {
        if (col_hsync) {
            if (show_vis) printf("vga: invisable h pixels %d\n", col_hsync);
            stats.col_hsync = col_hsync;
            col_hsync = 0;
        }
    }
#endif

    if (col_sink >= cols ||
        row_sink >= rows)
        return;

    /* do it */
    ps = (unsigned char *)screen->pixels;
    offset = (row_sink * cols) + col_sink;

    //if (pixel) printf("pixel %x\n", pixel);
    if (ps[offset] != (unsigned char)pixel) {
        ps[offset] = (unsigned char)pixel;
        SDL_UpdateRect(screen, col_sink, row_sink, 1, 1);
    }

    col_sink++;
#if 0
    eol = 1;
    eof = 1;
#endif
}

#ifdef __cplusplus
}
#endif


/*
 * Local Variables:
 * indent-tabs-mode:nil
 * c-basic-offset:4
 * End:
*/

