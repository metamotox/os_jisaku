haribote.sys: haribote.nas
	nasm haribote.nas -o haribote.sys -l haribote.lst

ipl.bin: ipl.nas
	nasm ipl.nas -o ipl.bin

.PHONY: run
run:
	qemu-system-i386 -fda hariboteos.img

.PHONY: remove
remove:
	rm *.bin *.lst *.sys

hariboteos.img: ipl.bin haribote.sys
	mformat -f 1440 -C -B ipl.bin -i hariboteos.img ::
	mcopy -i hariboteos.img haribote.sys ::
