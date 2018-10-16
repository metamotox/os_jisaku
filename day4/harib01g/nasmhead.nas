; haribote-os 
; TAB=4

BOTPAK	EQU	0x00280000	; destination of loading bootpack
DSKCAC	EQU	0x00100000	; start address of disk cache
DSKCAC0	EQU	0x00008000	; start address of disk cache in real mode

; related to BOOT_INFO
CYLS	EQU	0x0ff0		; setting boot sector
LEDS	EQU	0x0ff1
VMODE	EQU	0x0ff2		; how many bit color ?
SCRNX	EQU	0x0ff4		; X display resolution
SCRNY	EQU	0x0ff6		; Y display resolution
VRAM	EQU	0x0ff8		; start address fo graphic buffer

	ORG	0xc200		; start address this program is loaded

; display mode settings
	
	MOV	AL,0x13		; VGA graphics, 320x200x8bit color
	MOV	AH,0x00		; fixed value
	INT	0x10
	MOV	BYTE [VMODE],8	; store display mode in the following
	MOV	WORD [SCRNX],320
	MOV	WORD [SCRNY],200
	MOV	DWORD [VRAM],0x000a0000

; tell from BIOS the LED status of keyboard

	MOV	AH,0x02
	INT	0x16		; keyboard bios
	MOV	[LEDS],AL

; make PIC not accept all interruption

	MOV	AL,0xff
	OUT	0x21,AL
	NOP
	OUT	0xa1,AL

	CLI			; ban interruption more than cpu level

; setting A20GATE to be able to access more than 1MB memory from cpu

	CALL	waitkbdout
	MOV	AL,0xd1
	OUT	0x64,AL
	CALL	waitkbdout
	MOV	AL,0xdf		; enable A20
	OUT	0x60,AL
	CALL	waitkbdout

; change to the protect mode

; [INSTRSET "i486p"]		; not necessary when using nasm

	LGDT	[GDTR0]		; setting provisional GDT
	MOV	EAX,CR0		; getting current CR0 value to EAX
	AND	EAX,0x7fffffff	; bit 31th makes zero(ban to paging functionality)
	OR	EAX,0x00000001
	MOV	CR0,EAX
	JMP	pipelineflush

pipelineflush:
	MOV	AX,1*8		; writable segment 32bit
	MOV	DS,AX
	MOV	ES,AX
	MOV	FS,AX
	MOV	GS,AX
	MOV	SS,AX

; transferring bootpack code
	MOV	ESI,bootpack	; source 
	MOV	EDI,BOTPAK	; destination
	MOV	ECX,512*1024/4	
	CALL	memcpy

; additional, trasferring disk data to original position

; 1st, boot sector
	MOV	ESI,0x7c00	; source
	MOV	EDI,DSKCAC	; destination
	MOV	ECX,512/4
	CALL	memcpy

; other things(boot sector size is 512 byte, so that...)
	MOV	ESI,DSKCAC0+512	; source
	MOV	EDI,DSKCAC+512	; destination
	MOV	ECX,0
	MOV	CL,BYTE [CYLS]
	IMUL	ECX,512*18*2/4
	SUB	ECX,512/4	; minus ipl size
	CALL	memcpy

; finished writing that must do in nasmhead block
; after this, bootpack block

; launch bootpack
	MOV	EBX,BOTPAK
	MOV	ECX,[EBX+16]
	ADD	ECX,3		; ECX +=3
	SHR	ECX,2		; ECX /=2
	JZ	skip
	MOV	ESI,[EBX+20]	; source
	ADD	ESI,EBX
	MOV	EDI,[EBX+12]	; destination
	CALL	memcpy

skip:
	MOV	ESP,[EBX+12]	; initialized value of stack
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

	ALIGNB	16,	DB	0

GDT0:
	TIMES	8	DB	0	; null selector
	DW		0xffff,0x0000,0x9200,0x00cf	; read-writeable segment 32bit
	DW		0xffff,0x0000,0x9a28,0x0047	; executable segment 32bit for bootpack
	DW	0

GDTR0:
	DW	8*3-1
	DD	GDT0
	ALIGNB	16,	DB	0

bootpack:
