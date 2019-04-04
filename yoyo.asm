BITS 16				; not an instruction, just tell nasm we're in 16 bit mode

_start:
	;
	;
	; don't worry about this or mess with it too much
	mov ax, 07c0h		; set up 4k stack space after this bootloader
	mov ax, 288		; (4096 + 512) / 16 bytes per paragraph
	mov ss, ax
	mov sp, 4096

	mov ax, 07c0h		; set data segment to where we're loaded
	mov ds, ax
	;
	;
	;

; this is where we setup the graphics stuff
bios_setup:
	mov ah, 00h		; tell the bios we'll be in graphics mode
	mov al, 13h
	int 10h			; call the BIOS

	mov ah, 0Ch		; set video mode
	mov bh, 0		; set output vga
	mov al, 0		; set initial color
	mov cx, 0		; x = 0
	mov dx, 0		; y = 0

; call the BIOS to draw
draw:
	int 10h

next:
	; cx register holds x coord and dx holds y coord
	cmp dx, 200		; if y is at 200, jump to done (200 is the max height)
	je done
	cmp cx, 320		; if x is at 320, jump to new_xy
	je new_xy
	inc cx			; else increment cx by 1
	jmp draw		; call the BIOS to draw it out

; here is where we increment y coord and reset x coord
new_xy:
	mov cx, 0		; reset x coord
	inc dx			; increment y coord

; after each line is drawn, a new color is set
new_color:
	cmp al, 100		; check current color val
	jg reset_color		; if color val is over 100, reset color
	inc al			; else increment color val
	jmp draw		; draw

reset_color:
	mov al, 0		; reset color val
	jmp draw		; draw

done:
	jmp $			; jump to the current line until the end of time


times 510-($-$$) db 0		; pad remainder of boot sector with 0's
dw 0xAA55			; the standard PC boot signature - do not change
