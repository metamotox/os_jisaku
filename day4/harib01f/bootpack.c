/* tell compiler that there is the function in another file */
/* proto type declaration */
extern void io_hlt(void);
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int io_load_eflags(void);
extern void io_store_eflags(int eflags);

void init_palette(void);
void set_palette(int start, int end, unsigned char *rgb);

void HariMain(void)
{
	int i;			/* 32bit integer */
	char *p;		/* pointer */

	init_palette();		/* setting palette */

	p = (char *)0xa0000;	/* set address of VRAM area */

	for(i = 0; i <= 0xffff; i++){
		p[i] = i & 0x0f;	/* MOV BYTE [i],15*/
	}

	for(;;){
		io_hlt();
	}
}

void init_palette(void)
{
	static unsigned char table_rgb[16*3] = {
		0x00, 0x00, 0x00,	/* 0:black */
		0xff, 0x00, 0x00,	/* 1:light red */
		0x00, 0xff, 0x00,	/* 2:light green */
		0xff, 0xff, 0x00,	/* 3:light yellow */
		0x00, 0x00, 0xff,	/* 4:light blue */
		0xff, 0x00, 0xff,	/* 5:light purple */
		0x00, 0xff, 0xff,	/* 6:light water blue */
		0xff, 0xff, 0xff,	/* 7:white */
		0xc6, 0xc6, 0xc6,	/* 8:light gray */
		0x84, 0x00, 0x00,	/* 9:dark red */
		0x00, 0x84, 0x00,	/*10:dark green */
		0x84, 0x84, 0x00,	/*11:dark yellow */
		0x00, 0x00, 0x84,	/*12:dark blue */
		0x84, 0x00, 0x84,	/*13:dark purple */
		0x00, 0x84, 0x84,	/*14:dark water blue */
		0x84, 0x84, 0x84	/*15:dark gray */
	};
	set_palette(0, 15, table_rgb);
	return;

	/* static char operation is equals to DB operation */
}

void set_palette(int start, int end, unsigned char *rgb)
{
	int i, eflags;
	eflags = io_load_eflags();		/* record the allowing interrupt flags value */
	io_cli();				/* set allowing flag 0 for prohibitting interrupt */
	io_out8(0x03c8, start);

	for(i = start; i <= end; i++){
		io_out8(0x03c9, rgb[0]/4);
		io_out8(0x03c9, rgb[1]/4);
		io_out8(0x03c9, rgb[2]/4);
		rgb += 3;			/* gain rgb pointer index 3 */
	}

	io_store_eflags(eflags);		/* restore interrupt allowing flags */
	return;
}
