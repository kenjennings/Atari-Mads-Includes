;===============================================================================
;	MACROS - DIAGNOSTICS
;===============================================================================
; Generic, all-purpose, helper macros to shorten repetitive 
; tasks and make more readable code
;===============================================================================

.if DO_DIAG=1

;-------------------------------------------------------------------------------
;                                                               DIAGBYTE    A X
;-------------------------------------------------------------------------------
; mDiagByte <Address>, <X position>
;
; Calls the DiagByte routine to convert a byte into the two-byte, 
; hex representation and write this to a position in the 
; diagnostic screen memory intended for display on the screen. 
;-------------------------------------------------------------------------------

.macro mDiagByte address,xpos_offset
	.if :0<>2
		.error "DiagByte: 2 arguments (address, screen X position) required."
	.else
		mRegSave ; Save all CPU registers, so this call does not disrupt program state.
		lda :address      ; Load byte in address
		ldx #:xpos_offset ; Load screen line X offset.
		jsr libDiagDisplayByte
		mRegRestore ; Restore all registers.
	.endif
.endm

.endif ; if DO_DIAG=1

