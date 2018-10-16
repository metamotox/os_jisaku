/* code related to interruption */

#include "bootpack.h"	// including io_out8 function

void init_pic(void)
/* pic(programmable interruption controller) initialization */
{
	io_out8(PIC0_IMR, 0xff);	/* do not accept all interruption */
	io_out8(PIC1_IMR, 0xff);	/* do not accept all interruption */

	/* PIC0 configuration */
 	io_out8(PIC0_ICW1, 0x11);   /* edge trigger mode  */
	io_out8(PIC0_ICW2, 0x20);   /* in the IRQ0-7, it accepts on INT20-27 */
 	io_out8(PIC0_ICW3, 1 << 2); /* PIC1 is connected to IRQ2 */
	io_out8(PIC0_ICW4, 0x01);   /* non buffer mode */
	
	/* PIC1 configuration */
 	io_out8(PIC1_ICW1, 0x11); /* edge trigger mode */
	io_out8(PIC1_ICW2, 0x28); /* in the IRQ8-15, it accepts on INT28-2f */
 	io_out8(PIC1_ICW3, 2);	 /* PIC1 is connected to IRQ2 */
	io_out8(PIC1_ICW4, 0x01); /* non buffer mode  */

 	io_out8(PIC0_IMR, 0xfb);	 /* 11111011 : ban to use excluding PIC1 */
	io_out8(PIC1_IMR, 0xff);	 /* 11111111 : do not accept all interruption */
 	
	return;
}

void inthandler21(int *esp)
{
	/* interruption from PS/2keyboard */
	struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
	boxfill8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32*8-1, 15);
	putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 21 (IRQ-1) : PS/2 keyboard");
	for(;;){
		io_hlt();
	}
}

void inthandler2c(int *esp)
{
	/* interruption from PS/2 mouse */
	struct BOOTINFO *binfo = (struct BOOTINFO *) ADR_BOOTINFO;
	boxfill8(binfo->vram, binfo->scrnx, COL8_000000, 0, 0, 32*8-1, 15);
	putfont8_asc(binfo->vram, binfo->scrnx, 0, 0, COL8_FFFFFF, "INT 2C (IRQ-12) : PS/2 mouse");
	for(;;){
		io_hlt();
	}
}

void inthandler27(int *esp)
{
	io_out8(PIC0_OCW2, 0x67);	/* inform to PIC that IRQ-07 acception is complete */
	return;
}
