;===============================================================================
;	MACROS
;===============================================================================
; Generic, all-purpose, helper macros to shorten repetitive 
; tasks and make more readable code
;===============================================================================

;===============================================================================
; 6502 REGISTER MAINTENANCE
;===============================================================================
; Various shortcuts for managing 6502 A, X, Y registers typically used 
; when entering/exiting interrupts.  
;
; Also, a couple routines for entry/exit from a routine called by JSR to 
; preserve the registers and CPU flags, so the routine does not affect
; the caller.
;===============================================================================

;-------------------------------------------------------------------------------
;                                                               REGSAVEAY A Y
;-------------------------------------------------------------------------------
; mRegSaveAY 
;
; Save A, Y CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mRegSaveAY 
	PHA 
	TYA 
	PHA  
.endm 

;-------------------------------------------------------------------------------
;                                                               REGSAVEAX A X
;-------------------------------------------------------------------------------
; mRegSaveAX
;
; Save A, X CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mRegSaveAX  
	PHA 
	TXA 
	PHA  
.endm 

;-------------------------------------------------------------------------------
;                                                               REGSAVEAYX A Y X
;-------------------------------------------------------------------------------
; mRegSaveAYX 
;
; Save A, Y, X CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mRegSaveAYX  
	PHA 
	TYA 
	PHA 
	TXA 
	PHA 
.endm 

;-------------------------------------------------------------------------------
;                                                               REGRESTOREAY A Y
;-------------------------------------------------------------------------------
; mRegRestoreAY
;
; Restore A, Y CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRegRestoreAY  
	PLA 
	TAY 
	PLA 
.endm 

;-------------------------------------------------------------------------------
;                                                               REGRESTOREAX A X
;-------------------------------------------------------------------------------
; mRegRestoreAX
;
; Restore A, X CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRegRestoreAX  
	PLA 
	TAX 
	PLA 
.endm 

;-------------------------------------------------------------------------------
;                                                            REGRESTOREAYX A Y X
;-------------------------------------------------------------------------------
; mRegRestoreAYX 
;
; Restore A, Y, X CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRegRestoreAYX  
	PLA 
	TAX 
	PLA 
	TAY 
	PLA 
.endm 

;-------------------------------------------------------------------------------
;                                                               REGSAVE P A Y X
;-------------------------------------------------------------------------------
; mRegSave 
;
; Saves the CPU registers so subroutines do not disturb the 
; register states and logic/flow of the main code.
;-------------------------------------------------------------------------------

.macro mRegSave  
	PHP 
	
	mRegSaveAYX
.endm 

;-------------------------------------------------------------------------------
;                                                            REGRESTORE X Y A P
;-------------------------------------------------------------------------------
; mRegRestore 
;
; Restore A, Y, X CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRegRestore  
	mRegRestoreAYX
	
	PLP 
.endm 

;-------------------------------------------------------------------------------
;                                                             REGSAFERTS X Y A P
;-------------------------------------------------------------------------------
; mRegSafeRTS 
;
; Restores CPU registers for safe return from a routine 
; that used saveRegs to preserve the CPU registers.
;
; Includes the RTS.
;-------------------------------------------------------------------------------

.macro mRegSafeRTS  
	mRegRestore
	
	RTS 
.endm 

;===============================================================================
; The Basic Choice - (paper or plastic?)
;===============================================================================
; Load an explicit value or load from memeory?
; This means do not use page 0 references which would 
; be considered values less than 256, and the 
; address would be loaded as an explit value instead.
; (Which could be useful if you know what you're doing).
;===============================================================================

.macro mLDA_VM  value
	.if :0<>1
		.error "LDA_VM: 1 argument required"
	.else
		.if :value>$FF
			lda :value  ; get from memory
		.else
			lda #:value ; Get constant value
		.endif
	.endif
.endm

.macro mLDX_VM  value
	.if :0<>1
		.error "LDX_VM: 1 argument required"
	.else
		.if :value>$FF
			ldx :value  ; get from memory
		.else
			ldx #:value ; Get constant value
		.endif
	.endif
.endm

.macro mLDY_VM  value
	.if :0<>1
		.error "LDY_VM: 1 argument required"
	.else
		.if :value>$FF
			ldy :value  ; get from memory
		.else
			ldy #:value ; Get constant value
		.endif
	.endif
.endm

;===============================================================================
; 16-BIT LOADS
;===============================================================================
; Load/move 16-bit values
;===============================================================================

;-------------------------------------------------------------------------------
;                                                                LOADINT_M   A
;-------------------------------------------------------------------------------
; mLoadInt_M <Destination Address>, <Source Address>
;
; Loads the 16-bit value stored at <Source Address> into <Destination Address>.
; 
; Can be used to assign an address to a page 0 location for 
; later indirect addressing.
; In general, copies a 16-bit value to any address.   
; Like (in C):  C = D.
;-------------------------------------------------------------------------------

.macro mLoadInt_M  target,source
	.IF :0<>2
		.ERROR "LoadInt_M: 2 arguments (target addr, source addr) required."
	.ELSE
		lda :source
		sta :target
		lda :source + 1
		sta :target + 1
	.ENDIF
.endm

;-------------------------------------------------------------------------------
;                                                                LOADINT_V  A
;-------------------------------------------------------------------------------
; mLoadInt_V <Destination Address>, <Value>
;
; Loads the immediate 16-bit <Value> into <Destination Address>.
; 
; Can be used to assign an address to a page 0 location for 
; later indirect addressing.
; In general, stores an immediate 16-bit value at any address.
; Like (in C):
;  C = 12  or 
;  C = &D
;-------------------------------------------------------------------------------

.macro mLoadInt_V  target,value
	.if :0<>2
		.error "LoadInt_V: 2 arguments (target addr, 16-bit value) required."
	.else
		lda #<:value
		sta :target
		lda #>:value
		sta :target + 1
	.endif
.endm

;===============================================================================
; DISK SHENANIGANS
;===============================================================================
; The Atari executable file is a structured format.  The file contents identify
; starting address, ending address, and the data to load.  This feature 
; ordinarily allows the assembler to optimize the file size by describing only
; the segments of memory needed for the program.  However, it can also be
; abused to set values into any memory location during the program load time,
; such as the operating system shadow registers.  This allows the act of 
; loading the program to also perform a degree of initialization that applies
; configuration to the system without the program expending its own code 
; space to load and store values.
;
; The assembler supports this simply by changing the program address *=
; and then declaring storage (.byte, etc.)  These macros capture the 
; current program address in a temporary variable, set the current
; address,  declare the supplied value, then restore the program 
; address to the originally captured value.
;
; I think I recall Mac/65 would keep writes like this in the order in 
; which they occur.  But, it seems atasm collects (optimizes) these changes 
; of current program address into groups.  Use with caution.  Your Mileage 
; Will Definitely Vary.
;
; Maximum effectiveness using disk load would enable Title screens, 
; animation, music, etc. at known locations/events while loading the 
; main program.  Accomplishing this with atasm requires separate builds 
; and then concatenating the programs together.
;===============================================================================

;-------------------------------------------------------------------------------
;                                                                  DiskPoke
;-------------------------------------------------------------------------------
; mDiskPoke <Address> <byte value>
;
; Utilize the Atari's structured disk format to load a BYTE value into a memory
; location at the program load time.
;-------------------------------------------------------------------------------

.macro mDiskPoke  address,value
	.if :0<>2
		.error "DiskPoke: 2 arguments (target addr, byte value) required."
	.else
		.if :value>$FF
			.error "DiskPoke: Agument 2 for byte value is greater then $FF"
		.else
			DISKPOKE_TEMP =*
			ORG :address
			.byte :value
			ORG DISKPOKE_TEMP
		.endif
	.endif
.endm 

;-------------------------------------------------------------------------------
;                                                                  DiskDPoke
;-------------------------------------------------------------------------------
; mDiskDPoke <Address> <16-bit value>
;
; Utilize the Atari's structured disk format to load a 16-bit WORD value into a 
; memory location at the program load time.
; 
; Note that this macro cannot be used until AFTER a valid ORG address is 
; specified for assembly. If this is not done, then ORG DISKDPOKE_TEMP
; becomes an error.
;-------------------------------------------------------------------------------

.macro mDiskDPoke  address,value
	.if :0<>2
		.error "DiskDPoke: 2 arguments (target addr, integer value) required."
	.else
		DISKDPOKE_TEMP =*
		ORG :address
		.word :value
		ORG DISKDPOKE_TEMP
	.endif
.endm 

;-------------------------------------------------------------------------------
;                                                                CHAINDLI A
;-------------------------------------------------------------------------------
; mChainDLI 
;
; Use after a DLI to exit and change DLI vector to new address.
;
; It will only update the low byte/high byte of the vector when 
; they are different. 
;
; Restore Accumulator from stack.
;
; Exits interrupt with RTI.
;-------------------------------------------------------------------------------

.macro mChainDLI  ; current_DLI,next_DLI
	.if :0<>2
		.error "mChainDLI: 2 arguments required (Current DLI, Next DLI)
	.endif

	; If the same, then no need to change low byte.
	.if [<:current_DLI]<>[<:next_DLI] 
		lda #<:next_DLI ; Low byte of next DLI address
		sta VDSLST      ; Set vector
	.endif

	; If the same, then no need to change high byte.
	.if [>:current_DLI]<>[>:next_DLI] 
		lda #>:next_DLI ; High byte of next DLI address
		sta VDSLST+1    ; Set vector
	.endif

	pla ; restore A from stack
	rti ; DLI complete
.endm

