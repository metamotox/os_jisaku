/* nasmhead.nas */

struct BOOTINFO{
	char cyls, leds, vmode, reserve;
	short scrnx, scrny;
	char *vram;
};

#define ADR_BOOTINFO	0x00000ff0

/* nasmfunc.nas */
extern void io_hlt(void); 
extern void io_cli(void);
extern void io_out8(int port, int data);
extern int io_load_eflags(void);
extern void io_store_eflags(int eflags);
extern void load_gdtr(int limit, int addr);
extern void load_idtr(int limit, int addr);

/* graphic.c */
extern void init_palette(void);
extern void set_palette(int start, int end, unsigned char *rgb);
extern void boxfill8(unsigned char *vram, int xsize, unsigned char c, int x0, int y0, int x1, int y1);
extern void init_screen(char *vram, int x, int y);
extern void putfont8(char *vram, int xsize, int x, int y, char c, char *font);
extern void putfont8_asc(char *vram, int xsize, int x, int y, char c, unsigned char *s);
extern void init_mouse_cursor8(char *mouse, char bc);
extern void putblock8_8(char *vram, int vxsize, int pxsize, int pysize, int px0, int py0, char *buf, int bxsize);
 
#define COL8_000000	0
#define COL8_FF0000	1
#define COL8_00FF00	2
#define COL8_FFFF00	3
#define COL8_0000FF	4
#define COL8_FF00FF	5
#define COL8_00FFFF	6
#define COL8_FFFFFF	7
#define COL8_C6C6C6	8
#define COL8_840000	9
#define COL8_008400	10
#define COL8_848400	11
#define COL8_000084	12
#define COL8_840084	13
#define COL8_008484	14
#define COL8_848484	15

/* ------dsctbl.c------*/
/* segment descriptor entry structure */
struct SEGMENT_DESCRIPTOR{
	short limit_low, base_low;
	char base_mid, access_right;
	char limit_high, base_high;
};

/* gate descriptor entry structure */
struct GATE_DESCRIPTOR{
	short offset_low, selector;
	char dw_count, access_right;
	short offset_high;
};

extern void init_gdtidt(void);
extern void set_segmdesc(struct SEGMENT_DESCRIPTOR *sd, unsigned int limit, int base, int ar);
extern void set_gatedesc(struct GATE_DESCRIPTOR *gd, int offset, int selector, int ar);

#define	ADR_IDT		0x0026f800
#define	LIMIT_IDT	0x000007ff
#define	ADR_GDT		0x00270000
#define	LIMIT_GDT	0x00000fff
#define	ADR_BOTPAK	0x00280000
#define LIMIT_BOTPAK	0x0007ffff
#define	AR_DATA32_RW	0x4092
#define AR_CODE32_ER	0x409a
#define AR_INTGATE32	0x008e
/* ini.c */
#define PIC0_ICW1		0x0020
#define PIC0_OCW2		0x0020
#define PIC0_IMR		0x0021
#define PIC0_ICW2		0x0021
#define PIC0_ICW3		0x0021
#define PIC0_ICW4		0x0021
#define PIC1_ICW1		0x00a0
#define PIC1_OCW2		0x00a0
#define PIC1_IMR		0x00a1
#define PIC1_ICW2		0x00a1
#define PIC1_ICW3		0x00a1
#define PIC1_ICW4		0x00a1

