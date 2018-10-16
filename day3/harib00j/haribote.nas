; haribote-os
; TAB=4

; related to BOOT_INFO

CYLS	EQU		0x0ff0
LEDS	EQU		0x0ff1
VMODE	EQU		0x0ff2		; color information. The number of bit color
SCRNX	EQU		0x0ff4		; X display resolution
SCRNY	EQU		0x0ff6		; Y display resolution
VRAM	EQU		0x0ff8		; start address of Graphic buffer

	ORG		0xc200		; where this program store in memory
	MOV		AL,0x13		; video bios setting : VGA 320x200x8bit color
	MOV		AH,0x00		; fixed value
	INT		0x10		; video bios call
	MOV		BYTE [VMODE],8		; store video mode 8 bit color
	MOV		WORD [SCRNX],320	; store video mode X resolution
	MOV		WORD [SCRNY],200	; store video mode Y resolution
	MOV		DWORD [VRAM],0x000a0000

; tell from BIOS the LED status of keyboard
	MOV		AH, 0x02
	INT		0x16		; keyboard BIOS
	MOV		[LEDS], AL
fin:
	HLT
	JMP		fin 
