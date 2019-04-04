clean:
	nasm -f bin -o yoyo.bin yoyo.asm
os:
	dd status=noxfer conv=notrunc if=yoyo.bin of=yoyo.flp
run:
	make clean && make os && qemu-system-i386 -fda yoyo.flp

