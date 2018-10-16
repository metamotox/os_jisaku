; nasmfunc
; TAB=4

; [FORMAT "WCOFF"]		; the mode creating object file
[BITS 32]			; 32 bit mode machine code

; information for object file

; [FILE "nasmfunc.nas"]		; source file information

	GLOBAL	io_hlt		; function name that contains this program

; program in the io_hlt

[SECTION .text]			; write this description at first
io_hlt:				; void io_hlt(void)
	HLT
	RET
