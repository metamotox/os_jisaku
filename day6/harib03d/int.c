/* code related to interruption */

#include "bootpack.h"	// including io_out8 function

void init_pic(void)
/* pic(programmable interruption controller) initialization */
{
	io_out(PIC0_IMR, 0xff);	/* do not accept all interruption */
	io_out(PIC1_IMR, 0xff);	/* do not accept all interruption */

	/* PIC0 configuration */
 	io_out(PIC0_ICW1, 0x11);   /* edge trigger mode  */
	io_out(PIC0_ICW2, 0x20);   /* in the IRQ0-7, it accepts on INT20-27 */
 	io_out(PIC0_ICW3, 1 << 2); /* PIC1 is connected to IRQ2 */
	io_out(PIC0_ICW4, 0x01);   /* non buffer mode */
	
	/* PIC1 configuration */
 	io_out(PIC1_ICW1, 0x11); /* edge trigger mode */
	io_out(PIC1_ICW2, 0x28); /* in the IRQ8-15, it accepts on INT28-2f */
 	io_out(PIC1_ICW3, 2);	 /* PIC1 is connected to IRQ2 */
	io_out(PIC1_ICW4, 0x01); /* non buffer mode  */

 	io_out(PIC0_IMR, 0xfb);	 /* 11111011 : ban to use excluding PIC1 */
	io_out(PIC1_IMR, 0xff);	 /* 11111111 : do not accept all interruption */
 	
	return;
}
