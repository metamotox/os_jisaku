/* tell compiler that there is the function in another file */
/* proto type declaration */
extern void io_hlt(void);
extern void write_mem8(int addr, int data);

void HariMain(void)
{
	int i;			/* 32bit integer */
	for(i = 0xa0000; i <= 0xaffff; i++){
		write_mem8(i,i & 0x0f);		/* MOV BYTE [i],15*/
	}

	for(;;){
		io_hlt();
	}
}
