/* main program */
#include "bootpack.h"

extern struct KEYBUF keybuf;

void HariMain(void)
{
	struct BOOTINFO *binfo = (struct BOOTINFO *) 0x0ff0;
	char s[40], mcursor[256];
	int mx, my, i, j;
	
	init_gdtidt();		/* initialization of GDT and IDT */
	init_pic();		/* initializing PIC */
	io_sti();		/* enable cpu interruption because initializing IDT/PIC is finished */ 

	init_palette();		/* setting palette */
	init_screen8(binfo->vram, binfo->scrnx, binfo->scrny);
	mx = (binfo -> scrnx - 16) / 2;		/* calculate x and y position for centering */
	my = (binfo -> scrny - 28 - 16) / 2;

	init_mouse_cursor8(mcursor, COL8_008484);
	putblock8_8(binfo -> vram, binfo -> scrnx, 16, 16, mx, my, mcursor, 16);
	sprintf(s, "(%d, %d)", mx, my);
	putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, s);
	
	io_out8(PIC0_IMR, 0xf9);	/* allow PIC1 and keyboard (= 11111001) */
	io_out8(PIC1_IMR, 0xef);	/* allow mounse (= 11101111) */

	for(;;){
		io_cli();
		if(keybuf.next == 0){
			io_stihlt();
		}else{
			i = keybuf.data[0];
			keybuf.next--;
			for(j = 0; j < keybuf.next; j++){
				keybuf.data[j] = keybuf.data[j + 1];
			}

			io_sti();
			sprintf(s, "%x", i);
			boxfill8(binfo->vram, binfo->scrnx, COL8_008484, 0, 16, 15, 31);
			putfont8_asc(binfo->vram, binfo->scrnx, 0, 16, COL8_FFFFFF, s);
		}
	}
}

