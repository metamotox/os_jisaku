/* FIFO library */

#include "bootpack.h"

#define FLAGS_OVERRUN	0x0001

void fifo8_init(struct FIFO8 *fifo, int size, unsigned char *buf)
/* initialization of FIFO buffer */
{
	fifo->size = size;
	fifo->buf = buf;
	fifo->free = size; /* check that  there is free area */
	fifo->flags = 0;
	fifo->p = 0; /* position of writing */
	fifo->q = 0; /* position of reading */
	return;
}

int fifo8_put(struct FIFO8 *fifo, unsigned char data)
/* save and send data to FIFO */
/* this function is for writing data to buffer */
{
	if(fifo->free == 0){
		/* when there is not free area(cannot write to buf)*/
		/* set overflow flag and exits */
		fifo->flags |= FLAGS_OVERRUN;
		return -1;
	}
	/* there is free area, wrte data to buffer */
	fifo->buf[fifo->p] = data;
	fifo->p++;
	if(fifo->p == fifo->size){
		fifo->p = 0;
	}
	fifo->free--;
	return 0;
}

int fifo8_get(struct FIFO8 *fifo)
/* get data from FIFO */
/* this function is for reading data from buffer */
{
	int data;
	if(fifo->free == fifo->size){
		/* if buffer is empty, return -1 */
		return -1;
	}
	data = fifo->buf[fifo->q];
	fifo->q++;
	if(fifo->q == fifo->size){
		fifo->q = 0;
	}
	fifo->free++;
	return data;
}

int fifo8_status(struct FIFO8 *fifo)
/* report how many data are saved */
{
	return fifo->size - fifo->free;
}
