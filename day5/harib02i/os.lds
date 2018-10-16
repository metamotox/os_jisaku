OUTPUT_FORMAT("binary");

SECTIONS
{
	.head 0x0:{
		LONG(64*1024)		/* offset:0 stack+.data+heap size( 4KBn) */
		LONG(0x69726148)	/* offset:4 signature "Hari" */
		LONG(0)			/* offset:8 size of mmarea */
		LONG(0x310000)		/* offset:12 initial stack data and data destination */
		LONG(SIZEOF(.data))	/* offset:16 .data section size */
		LONG(LOADADDR(.data))	/* offset:20 .data stored address */
		LONG(0xE9000000)	/* offset:24 0xE9000000 */
		LONG(HariMain - 0x20)	/* offset:28 entry point address - 0x20 */
		LONG(0)			/* offset:32 start address of heap section */
	}
	.text :{*(.text)}

	.data 0x310000:AT (ADDR(.text)+SIZEOF(.text)){
		*(.data)
		*(.rodata*)
		*(.bss)
	}

	/DISCARD/ : { *(.eh_frame) }
}
