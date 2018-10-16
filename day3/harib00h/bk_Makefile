haribote.sys: haribote.nas
	nasm haribote.nas -o haribote.sys -l haribote.lst

ipl.bin: ipl.nas
	nasm ipl.nas -o ipl.bin

.PHONY: run
run:
	qemu-system-i386 -fda helloos.img

helloos.img: ipl.bin haribote.sys
	echo haribote.sys > haribote.name
	dd if=ipl.bin of=helloos.img count=2880 bs=512 conv=notrunc
	dd if=haribote.name of=helloos.img count=1 bs=512 seek=19 conv=notrunc
	dd if=haribote.sys of=helloos.img count=1 bs=512 seek=33 conv=notrunc
