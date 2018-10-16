bootpack.hrb: bootpack.c nasmfunc.o os.lds
	gcc -march=i486 -m32 -nostdlib -T os.lds nasmfunc.o bootpack.c -o bootpack.hrb

nasmhead.bin: nasmhead.nas
	nasm nasmhead.nas -o nasmhead.bin -l nasmhead.lst

nasmfunc.o: nasmfunc.nas
	nasm -f elf nasmfunc.nas -o nasmfunc.o -l nasmfunc.lst

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
