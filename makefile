clean:
	nasm -f bin -o yoyo.bin yoyo.asm && dd status=noxfer conv=notrunc if=yoyo.bin of=yoyo.flp && qemu-system-i386 -fda yoyo.flp
