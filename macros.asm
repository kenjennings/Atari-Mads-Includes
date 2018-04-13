;===============================================================================
;	MACROS
;===============================================================================
; Generic, all-purpose, helper macros to shorten repetitive 
; tasks and make more readable code
;===============================================================================

;===============================================================================
; 16-BIT LOADS
;===============================================================================
; Load/move 16-bit values
;===============================================================================

;-------------------------------------------------------------------------------
;                                                                  LOADINT   A
;-------------------------------------------------------------------------------
; mLoadInt <Destination Address>, <Source Address>
;
; Loads the 16-bit value stored at <Source Address> into <Destination Address>.
; 
; Can be used to assign an address to a page 0 location for 
; later indirect addressing.
; In general, copies a 16-bit value to any address.   
; Like (in C):  C = D.
;-------------------------------------------------------------------------------

.macro mLoadInt target,source
	.IF :0<>2
		.ERROR "LoadInt: 2 arguments (target addr, source addr) required."
	.ELSE
		lda :source
		sta :target
		lda :source + 1
		sta :target + 1
	.ENDIF
.endm

;-------------------------------------------------------------------------------
;                                                                  LOADINTP  A
;-------------------------------------------------------------------------------
; mLoadIntP <Destination Address>, <Value/Address/Pointer>
;
; Loads the immediate 16-bit <Value/Address/Pointer> into <Destination Address>.
; 
; Can be used to assign an address to a page 0 location for 
; later indirect addressing.
; In general, stores an immediate 16-bit value at any address.
; Like (in C):
;  C = 12  or 
;  C = &D
;-------------------------------------------------------------------------------

.macro mLoadIntP target,value
	.if :0<>2
		.error "LoadIntP: 2 arguments (target addr, 16-bit value) required."
	.else
		lda #<:source
		sta :target
		lda #>:source
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

.macro mDiskPoke address,value
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
;-------------------------------------------------------------------------------

.macro mDiskDPoke addres,value
	.if :0<>2
		.error "DiskDPoke: 2 arguments (target addr, integer value) required."
	.else
		DISKDPOKE_TEMP =*
		ORG :address
		.word :value
		ORG DISKDPOKE_TEMP
	.endif
.endm 


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
;                                                                  SAVEAY A Y
;-------------------------------------------------------------------------------
; mSaveAY 
;
; Save A, Y CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mSaveAY 
	PHA 
	TYA 
	PHA  

.endm 

;-------------------------------------------------------------------------------
;                                                                  SAVEAX A X
;-------------------------------------------------------------------------------
; mSaveAX
;
; Save A, Y CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mSaveAX
	PHA 
	TXA 
	PHA  

.endm 

;-------------------------------------------------------------------------------
;                                                                  SAVEAYX A Y X
;-------------------------------------------------------------------------------
; mSaveAYX 
;
; Save A, Y, X CPU registers on stack. 
;-------------------------------------------------------------------------------

.macro mSaveAYX 
	PHA 
	TYA 
	PHA 
	TXA 
	PHA 

.endm 

;-------------------------------------------------------------------------------
;                                                                  RESTOREAY A Y
;-------------------------------------------------------------------------------
; mRestoreAY
;
; Restore A, Y CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRestoreAY  
	PLA 
	TAY 
	PLA 

.endm 

;-------------------------------------------------------------------------------
;                                                                  RESTOREAX A X
;-------------------------------------------------------------------------------
; mRestoreAX
;
; Restore A, X CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRestoreAX 
	PLA 
	TAX 
	PLA 

.endm 

;-------------------------------------------------------------------------------
;                                                               RESTOREAYX A X Y
;-------------------------------------------------------------------------------
; mRestoreAYX 
;
; Restore A, Y, X CPU registers from stack. 
;-------------------------------------------------------------------------------

.macro mRestoreAYX 
	PLA 
	TAX 
	PLA 
	TAY 
	PLA 

.endm 

;-------------------------------------------------------------------------------
;                                                               SAVEREGS A X Y P
;-------------------------------------------------------------------------------
; usage :
; mSaveRegs 
;
; Saves the CPU registers so subroutines do not disturb the 
; register states and logic/flow of the main code.
;-------------------------------------------------------------------------------

.macro mSaveRegs  
	PHP 
	mSaveAYX
.endm 

;-------------------------------------------------------------------------------
;                                                                SAFERTS A X Y P
;-------------------------------------------------------------------------------
; mSafeRTS 
;
; Restores CPU registers for safe return from a routine 
; that used saveRegs to preserve the CPU registers.
;
; Includes the RTS.
;-------------------------------------------------------------------------------

.macro mSafeRTS  
	mRestoreAYX
	PLP 
	
	RTS 
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

.macro mChainDLI ; current_DLI,next_DLI
	.if :0<>2
		.error "mChainDLI: 2 arguments required (Current DLI, Next DLI)
	.endif

	; If the same, then no need to change low byte.
	.if [:current_DLI&$FF]<>[:next_DLI&FF] 
		lda #<:next_DLI ; Low byte of next DLI address
		sta VDSLST      ; Set vector
	.endif

	; If the same, then no need to change high byte.
	.if [:current_DLI&$FF00]<>[:next_DLI&FF00] 
		lda #>:next_DLI ; High byte of next DLI address
		sta VDSLST+1    ; Set vector
	.endif

	pla ; restore A from stack
	rti ; DLI complete
.endm


;===============================================================================
; ****   ******   **    *****
; ** **    **    ****  **  
; **  **   **   **  ** **
; **  **   **   **  ** ** ***
; ** **    **   ****** **  **
; ****   ****** **  **  *****
;===============================================================================

;-------------------------------------------------------------------------------
;                                                               DEBUGBYTE    A Y
;-------------------------------------------------------------------------------
; mDebugByte <Address>, <X position>
;
; Calls the DiagByte routine to convert a byte into the two-byte, 
; hex representation and write this to a position in the 
; diagnostic screen memory intended for display on the screen. 
;-------------------------------------------------------------------------------

.macro mDebugByte address,xpos_offset
	.if :0<>2
		.error "DebugByte: 2 arguments (address, screen X position) required."
	.else
		lda :address      ; Load byte in address
		ldy #:xpos_offset ; Load screen line X offset.
		jsr DiagByte
	.endif
.endm

