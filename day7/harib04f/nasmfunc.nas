; nasmfunc
; TAB=4

; [FORMAT "WCOFF"]		; the mode creating object file
[BITS 32]			; 32 bit mode machine code

; information for object file

; [FILE "nasmfunc.nas"]		; source file information

	global	io_hlt		; function name that contains this program
	global	io_cli
	global	io_sti
	global	io_stihlt
	global	io_in8
	global	io_in16
	global	io_in32
	global	io_out8
	global	io_out16
	global	io_out32
	global	io_load_eflags
	global	io_store_eflags
	global	load_gdtr
	global	load_idtr
	global 	asm_inthandler21
	global	asm_inthandler27
	global 	asm_inthandler2c

	extern	inthandler21
	extern	inthandler27
	extern	inthandler2c

; program in the io_hlt

section .text			; write this description at first

io_hlt:				; void io_hlt(void)
	HLT
	RET

io_cli:				; void io_cli(void)
	CLI			; clear interrupt flag
	RET

io_sti:				; void io_sti(void)
	STI			; set IF flag 1
	RET

io_stihlt:			; void io_stihlt(void)
	STI			; set IF flag included EFLAGS 1
	HLT
	RET

io_in8:				; int io_in8(int port)
	MOV	EDX,[ESP+4]	; [ESP+4] is arg1
	MOV	EAX,0
	IN	AL,DX
	RET


io_in16:			; int io_in16(int port)
	MOV	EDX,[ESP+4]
	MOV	EAX,0
	IN	AX,DX
	RET

io_in32:			; int io_in32(int port)
	MOV	EDX,[ESP+4]	; [ESP+4] is argument(port)
	IN	EAX,DX
	RET

io_out8:			; void io_out8(int port, int data)
	MOV	EDX,[ESP+4]	; [ESP+4] is argument(port)
	MOV	AL,[ESP+8]	; [ESP+8] is argument(data)
	OUT	DX,AL
	RET

io_out16:			; void io_out16(int port, int data)
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,AX
	RET

io_out32:			; void io_out32(int port, int data)
	MOV	EDX,[ESP+4]
	MOV	EAX,[ESP+8]
	OUT	DX,EAX
	RET

io_load_eflags:			; int io_load_eflags(void);
	PUSHFD			; it is equals to PUSH EFLAGS
	POP	EAX
	RET

io_store_eflags:		; void io_store_eflags(int eflags);
	MOV	EAX,[ESP+4]
	PUSH	EAX
	POPFD			; it is equals to POP EFLAGS
	RET

load_gdtr:
	MOV	AX,[ESP+4]
	MOV	[ESP+6], AX
	LGDT	[ESP+6]
	RET

load_idtr:
	MOV	AX,[ESP+4]
	MOV	[ESP+6], AX
	LIDT	[ESP+6]
	RET

asm_inthandler21:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV	EAX,ESP
	PUSH	EAX
	MOV	AX,SS
	MOV	DS,AX
	MOV	ES,AX
	CALL	inthandler21
	POP	EAX
	POPAD
	POP	DS
	POP	ES
	IRETD

asm_inthandler27:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV	EAX,ESP
	PUSH	EAX
	MOV	AX,SS
	MOV	DS,AX
	MOV	ES,AX
	CALL	inthandler27
	POP	EAX
	POPAD
	POP	DS
	POP	ES
	IRETD

asm_inthandler2c:
	PUSH	ES
	PUSH	DS
	PUSHAD
	MOV	EAX,ESP
	PUSH	EAX
	MOV	AX,SS
	MOV	DS,AX
	MOV	ES,AX
	CALL	inthandler2c
	POP	EAX
	POPAD
	POP	DS
	POP	ES
	IRETD
