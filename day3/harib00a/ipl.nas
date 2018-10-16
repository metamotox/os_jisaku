; haribote-ipl
; TAB=4

	ORG		0x7c00

	JMP		entry
	DB		0x90
	DB		"HARIBOTE"
	DW		512
	DB		1
	DW		1
	DB		2
	DW		224
	DW		2880
	DB		0xf0
	DW		9
	DW		18
	DW		2
	DD		0
	DD		2880
	DB		0,0,0x29
	DD		0xffffffff
	DB		"HARIBOTEOS "
	DB		"FAT12   "
	TIMES	18	DB	0x00

; main program

entry:
	MOV		AX,0
	MOV		SS,AX
	MOV		SP,0x7c00
	MOV		DS,AX

; reading disk
	MOV		AX,0x0820
	MOV		ES,AX
	MOV		CH,0		; cylinder=0
	MOV		DH,0		; head=0
	MOV		CL,2		; sector=2

	MOV		AH,0x02		; AH=0x02 : reading disk operation
	MOV		AL,1		; 1 sector
	MOV		BX,0
	MOV		DL,0x00		; target : A drive
	INT		0x13
	JC		error

fin:
	HLT
	JMP		fin

error:
	MOV		SI,msg

putloop:
	MOV		AL,[SI]
	ADD		SI,1
	CMP		AL,0
	JE		fin
	MOV		AH,0x0e		; 1 character display function
	MOV		BX,15		; color code
	INT		0x10		; video BIOS call
	JMP		putloop

msg:
	DB		0x0a, 0x0a
	DB		"no drink, no life!"
	DB		0x0a
	DB		0

	TIMES	0x7dfe-0x7c00-($-$$)	DB	0x00
	DB		0x55, 0xaa

