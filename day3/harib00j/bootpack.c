/* tell compiler that there is the function in another file */
/* proto type declaration */
extern void io_hlt(void);

void HariMain(void)
{
	fin:
		io_hlt();	/* using function */
		goto fin;
}
