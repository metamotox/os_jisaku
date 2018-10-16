bootpack.hrb: bootpack.c os.lds
	gcc -march=i486 -m32 -nostdlib -T os.lds bootpack.c -o bootpack.hrb

nasmhead.bin: nasmhead.nas
	nasm nasmhead.nas -o nasmhead.bin -l nasmhead.lst

ipl.bin: ipl.nas
	nasm ipl.nas -o ipl.bin

haribote.sys: nasmhead.bin bootpack.hrb
	cat nasmhead.bin bootpack.hrb > haribote.sys

.PHONY: run
run:
	qemu-system-i386 -fda hariboteos.img

.PHONY: remove
remove:
	rm *.bin *.lst *.sys *.hrb 

.PHONY: debug
debug:
	qemu-system-i386 -m 32 -localtime -vga std -fda hariboteos.img -gdb tcp::10000 -S &

hariboteos.img: ipl.bin haribote.sys
	mformat -f 1440 -C -B ipl.bin -i hariboteos.img ::
	mcopy -i hariboteos.img haribote.sys ::
