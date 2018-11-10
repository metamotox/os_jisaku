bootpack.hrb: hankaku.c mysprintf.o dsctbl.o graphic.o nasmfunc.o fifo.o int.o bootpack.c os.lds
	gcc -march=i486 -m32 -nostdlib -T os.lds nasmfunc.o hankaku.c mysprintf.o dsctbl.o graphic.o fifo.o int.o bootpack.c -o bootpack.hrb

int.o: int.c
	gcc -c -m32 -march=i486 -nostdlib int.c -o int.o

fifo.o: fifo.c
	gcc -c -m32 -march=i486 -nostdlib fifo.c -o fifo.o

nasmhead.bin: nasmhead.nas
	nasm nasmhead.nas -o nasmhead.bin -l nasmhead.lst

nasmfunc.o: nasmfunc.nas
	nasm -f elf nasmfunc.nas -o nasmfunc.o -l nasmfunc.lst

dsctbl.o: dsctbl.c
	gcc -c -m32 -march=i486 -nostdlib dsctbl.c -o dsctbl.o

graphic.o: graphic.c
	gcc -c -m32 -march=i486 -nostdlib graphic.c -o graphic.o

mysprintf.o: mysprintf.c
	gcc -c -m32 -march=i486 -nostdlib mysprintf.c -o mysprintf.o

ipl.bin: ipl.nas
	nasm ipl.nas -o ipl.bin

haribote.sys: nasmhead.bin bootpack.hrb
	cat nasmhead.bin bootpack.hrb > haribote.sys

.PHONY: run
run:
	qemu-system-i386 -fda hariboteos.img

.PHONY: remove
remove:
	rm *.bin *.lst *.sys *.hrb *.o 
.PHONY: delete_img
delete_img:
	rm hariboteos.img

.PHONY: debug
debug:
	qemu-system-i386 -m 32 -localtime -vga std -fda hariboteos.img -gdb tcp::10000 -S &

hariboteos.img: ipl.bin haribote.sys
	mformat -f 1440 -C -B ipl.bin -i hariboteos.img ::
	mcopy -i hariboteos.img haribote.sys ::
