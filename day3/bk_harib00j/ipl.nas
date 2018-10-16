; haribote-ipl
; TAB=4
CYLS	EQU		10
	ORG		0x7c00		; where this program is loaded

	JMP		entry		; jmp operation to boot code entry point
	DB		0x90		; nop opecode
	DB		"HARIBOTE"	; OEM name
	DW		512		; define size of byte per sector(fixed:512)
	DB		1		; define size of sector per cluster(fixed:1)
	DW		1		; start sector of FAT(normaly:1st sector)
	DB		2		; the number of FAT(fixed:2)
	DW		224		; Maximum number of entry in the root directory(normaly:224)
	DW		2880		; number of sectors contains in this drive(fixed:2880->1440KB)
	DB		0xf0		; Media type(fixed:0xf0,  0xf0 value means removable media)
	DW		9		; size of FAT area(fixed:9sector)
	DW		18		; sectors per track of storage device(fixed:18sector)
	DW		2		; number of heads(fixed:2)
	DD		0		; number of sectors before the start of partition(not use : 0)
	DD		2880		; number of sectors contains in this drive(fixed:2880)
	DB		0,0,0x29	; BIOS INT13h drive num, not used, Extended boot signature:0x29
	DD		0xffffffff	; Volume Serial number
	DB		"HARIBOTEOS "	; Volume label in ASCII, nann demo E!(11bytes)
	DB		"FAT12   "	; File system type label, normaly FATXX(8bytes)
	TIMES	18	DB	0x00	; not used

; main program

entry:					; jmp entry -> EB 4E, ip=0x02, so that entry address is 4E+0x02 = 0x50
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

readloop:
	MOV		SI,0		; the regsiter that counts number of reading failure

retry:
	MOV		AH,0x02		; select mode : AH=0x02 -> reading disk
	MOV		AL,1		; number of sector that is read from disk
	MOV		BX,0		
	MOV		DL,0x00		; drive number(0x00 - 0x7f : FDD, 0x80 - 0xff ; HDD)
	INT		0x13		
	JNC		next		; when not carry, jump next address
	ADD		SI,1
	CMP		SI,5		
	JAE		error
	MOV		AH,0x00
	MOV		DL,0x00
	INT		0x13
	JMP		retry

next:
	MOV		AX,ES
	ADD		AX,0x0020
	MOV		ES,AX
	ADD		CL,1
	CMP		CL,18
	JBE		readloop
	MOV		CL,1
	ADD		DH,1
	CMP		DH,2
	JB		readloop
	MOV		DH,0
	ADD		CH,1
	CMP		CH,CYLS
	JB		readloop

	MOV		[0x0ff0],CH
	JMP		0xc200
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
	DB		0x55, 0xaa	; Signature value 0xaa55(LE)

