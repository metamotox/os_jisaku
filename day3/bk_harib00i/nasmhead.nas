; haribote-os boot assembly code
; TAB=4

BOTPAK	EQU		0x00280000	; the address of loading bootpack
DSKCAC	EQU		0x00100000	; the address of disk cache
DSKCAC0	EQU		0x00008000	; the address of disk cache(when real mode)

; Information related to BOOT_INFO
CYLS	EQU		0x0ff0		; set by boot sector
LEDS	EQU		0x0ff1		; LED color
VMODE	EQU		0x0ff2		; How many bit colors ?
SCRNX	EQU		0x0ff4		; resolution X
SCRNY	EQU		0x0ff6		; resolution Y
VRAM	EQU		0x0ff8		; start address of Graphic buffer
		ORG		0xc200

; display mode setting

		MOV	AL,0x13			; mode settings, VGA graphics 320x200x8bit color
		MOV	AH,0x00			; fixed value of AH
		INT	0x10			; video mode setting operation
		MOV	BYTE [VMODE],8		; memorize video mode(c language use this information)
		MOV	WORD [SCRNX],320	; memorize resolution X 
		MOV	WORD [SCRNY],200	; memorize resolution Y
		MOV	DWORD [VRAM],0x000a0000	; what does 0x000a0000 mean ?

; tell from BIOS the keyboard LED status

		MOV	AH,0x02
		INT	0x16		; keyboard BIOS
		MOV	[LEDS],AL

; configuration not to accept interrupt to PIC

		MOV	AL,0xff
		OUT	0x21,AL
		NOP
		OUT	0xa1,AL
		CLI			; ban to interrupt as cpu level

; A20GATE setting to be able to access more than 1MB memory from cpu
		CALL	waitkbdout
		MOV	AL,0xd1
		OUT	0x64,AL
		CALL	waitkbdout
		MOV	AL,0xdf
		OUT	0x60,AL
		CALL	waitkbdout

; to be protect mode

; [INSTRSET "i486p"]
		LGDT	[GDTR0]
		MOV	EAX,CR0		; get current value of CR0
		AND	EAX,0x7fffffff	; set zero to bit31(ban the paging)
		OR	EAX,0x00000001	; set 1 to bit0(for changing mode to protected mode)
		MOV	CR0,EAX		; chage value of CR0
		JMP	pipelineflush

pipelineflush:				; initialization segment registers
		MOV	AX,1*8		; all segment registers set 0x8 value
		MOV	DS,AX
		MOV	ES,AX
		MOV	FS,AX
		MOV	GS,AX
		MOV	SS,AX

; transferring bootpack
		MOV	ESI,bootpack	; set bootpack label address to source index register
		MOV	EDI,BOTPAK	; set 0x100000 to destination index register
		MOV	ECX,512*1024/4	; set 0x20000 to ecx
		CALL	memcpy		; call memcpy function(following exists this label)

; transferring disk data to original position
; first, boot sector

		MOV	ESI,0x7c00	; set ipl start address to ESI
		MOV	EDI,DSKCAC	; set disk cache start address to EDI
		MOV	ECX,512/4	; set 0x80 to ecx
		CALL	memcpy

; next, other things
; cache address is after the boot sector data(boot sector size is 512 byte so that...)		
		MOV	ESI,DSKCAC0+512	; set 0x8000+0x200 to ESI(real mode disk cache)
		MOV	EDI,DSKCAC+512	; set 0x100000+0x200 to EDI(disk cache)
		MOV	ECX,0		; initialize ecx register
		MOV	CL,BYTE [CYLS]	; copy the value stored 0x0ff0 address (Byte size value)
		IMUL	ECX,512*18*2/4	; singed multiply operation  
		SUB	ECX,512/4	; 
		CALL	memcpy

; finish to descript that it must do on nasmhead code.
; so, other code is bootpack 

; launch bootpack
		MOV	EBX,BOTPAK
		MOV	ECX,[EBX+16]
		ADD	ECX,3		; ECX +=3
		SHR	ECX,2		; ECX /=4
		JZ	skip
		MOV	ESI,[EBX+20]
		ADD	ESI,EBX
		MOV	EDI,[EBX+12]
		CALL	memcpy

skip:
		MOV	ESP,[EBX+12]		; initialize stack pointer
		JMP	DWORD 2*8:0x0000001b

waitkbdout:
		IN	AL,0x64
		AND	AL,0x02
		JNZ	waitkbdout
		RET

memcpy:
		MOV	EAX,[ESI]
		ADD	ESI,4
		MOV	[EDI],EAX
		ADD	EDI,4
		SUB	ECX,1
		JNZ	memcpy
		RET

		ALIGNB	16

GDT0:
		TIMES	18	DB	0
		DW	0xffff,0x0000,0x9200,0x00cf	; writable segment - 32bit
		DW	0xffff,0x0000,0x9a28,0x0047	; executable segment - 32bit(bootpack)
		DW	0


GDTR0:
		TIMES	8	DB	0		; null selector
		DW	8*3-1
		DD	GDT0
		ALIGNB	16
bootpack:
