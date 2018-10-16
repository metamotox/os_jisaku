; nasmfunc
; TAB=4

; [FORMAT "WCOFF"]		; the mode creating object file
[BITS 32]			; 32 bit mode machine code

; information for object file

; [FILE "nasmfunc.nas"]		; source file information

	GLOBAL	io_hlt		; function name that contains this program
	GLOBAL	io_cli
	GLOBAL	io_sti
	GLOBAL	io_stihlt
	GLOBAL	io_in8
	GLOBAL	io_in16
	GLOBAL	io_in32
	GLOBAL	io_out8
	GLOBAL	io_out16
	GLOBAL	io_out32
	GLOBAL	io_load_eflags
	GLOBAL	io_store_eflags

; program in the io_hlt

section .text			; write this description at first

io_hlt:				; void io_hlt(void)
	HLT
	RET

io_cli:				; void io_cli(void)
	CLI
	RET

io_sti:				; void io_sti(void)
	STI
	RET

io_stihlt:			; void io_stihlt(void)
	STI
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
	MOV	EDX,[ESP+4]
	IN	EAX,DX
	RET

io_out8:			; void io_out8(int port, int data)
	MOV	EDX,[ESP+4]
	MOV	AL,[ESP+8]
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

