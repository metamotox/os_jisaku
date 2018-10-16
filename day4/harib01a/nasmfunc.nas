; nasmfunc
; TAB=4

; [FORMAT "WCOFF"]		; the mode creating object file
[BITS 32]			; 32 bit mode machine code

; information for object file

; [FILE "nasmfunc.nas"]		; source file information

	GLOBAL	io_hlt		; function name that contains this program
	GLOBAL	write_mem8
; program in the io_hlt

[SECTION .text]			; write this description at first
io_hlt:				; void io_hlt(void)
	HLT
	RET

; program in the write_mem8
write_mem8:			; void write_mem8(int addr, int data)
	MOV	ECX,[ESP+4]
	MOV	AL,[ESP+8]
	MOV	[ECX],AL
	RET			
