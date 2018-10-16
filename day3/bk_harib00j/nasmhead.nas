; nasmfunc
; TAB=4

[FROMAT "WCOFF"]
[BITS 32]

; Information for object file

[FILE "nasmhead.nas"]		; source file name information
	GLOBAL	_io_hlt		; function name that contains in this program

; function

[SECTION .text]		; in the object file, write the program after this description

_io_hlt:		; void io_hlt(void)
		HLT
		RET
