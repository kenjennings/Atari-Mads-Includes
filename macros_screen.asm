;===============================================================================
; SCREEN MACROS
;===============================================================================
; Generic, all-purpose, helper macros to shorten repetitive
; tasks, and make more readable code.
;===============================================================================

;===============================================================================
; Constants

; Color constants are supplied by GTIA.asm.  Also see mScreenSetColors.

SPACEATASCII    = $20
SPACESCREENCODE = $00

FALSE           = 0
TRUE            = 1


;===============================================================================
; Macros/Subroutines


;------------------------------------------------------------------------------
; 								SCREENFILLMEM
;------------------------------------------------------------------------------
; mScreenFillMem <fill byte>
;
; Wrapper to call library routine ScreenFillMem.
;
; mScreenFillMem is like a generic routine to clear memory, but it 
; specifically sets 1,040 sequential bytes for screen memory.
;
; Arguments:
; 1 = Value (byte value to fill screen memory).
; If Value is greater the 255 it assumes the value is the memeory location
; containing the byte to use for screen memory.
;------------------------------------------------------------------------------

.macro mScreenFillMem fillByte
	.if :0<>1
		.error "mScreenFillMem: 1 argument (byte to fill) required."
	.else
		.if :fillByte<256
			lda #:fillByte
		.else
			lda :fillByte
		.endif
		jsr libScreenFillMem
	.endif
.endm


;------------------------------------------------------------------------------
; 							SCREENSETCOLORS_V
;------------------------------------------------------------------------------
; mScreenSetColors_V <background>,<Color0>,<Color1>,<Color2>,<Color3>
;
; Atari Background and C64 Background/Border are different.
; In the Atari's multi-color text mode any empty space is the "background" 
; (aka COLOR4 or hardware COLBK) continuing through the oversan area.
; The Normal text mode uses Background color (COLOR4/COLBK) as the "border" 
; color around the text area, and COLOR2 (hardware COLPF2) as the background 
; behind text.
;
; Note that the values are going into the OS shadow registers, which the OS
; will copy to the hardware registers during the Vertical Blank.
;
; Color specifications are different as the Atari has 128 colors to 
; the C64s 16.  GTIA.asm provides 16 base color definitions in the high
; nybble, and then the assignment ORs a luminance value in the low nybble.  
; Example: COLOR_AQUA provides $A0, high nybble value for color.
; The code must OR a luminance value from $0 (dark) to $E (lightest).  
; Therefore: COLOR_AQUA|$0A for a medium-light aqua color. 
;
; Arguments:
; 1 = Background Color  (Value) (COLOR4)
; 2 = Playfield Color 0 (Value) (COLOR0)
; 3 = Playfield Color 1 (Value) (COLOR1)
; 4 = Playfield Color 2 (Value) (COLOR2)
; 5 = Playfield Color 3 (Value) (COLOR3)
;------------------------------------------------------------------------------

.macro mScreenSetColors_V cBack,col0,col1,col2,col3
	.if :0<>5
		.error "mScreenSetColors_V: 5 arguments (Background color, Color 0, Color 1, Color 2, Color 3) required."
	.else
        lda #:cBack   ; Background -> A
        sta COLOR4    ; A -> COLOR4
        lda #:col0    ; Color0 -> A
        sta COLOR0    ; A -> COLOR0
        lda #:col1    ; Color1 -> A
        sta COLOR1    ; A -> COLOR1
        lda #:col2    ; Color2 -> A
        sta COLOR2    ; A -> COLOR2
        lda #:col3    ; Color3 -> A
        sta COLOR3    ; A -> COLOR3
	.endif
.endm


;------------------------------------------------------------------------------
; 							ScreenSetColors_M
;------------------------------------------------------------------------------
; mScreenSetColors_M <background>,<Color0>,<Color1>,<Color2>,<Color3>
;
; Same as above, but instead of using constant values this expects the 
; arguments are addresses of memeory locations containing the values.
;------------------------------------------------------------------------------

.macro mScreenSetColors_M cBack,col0,col1,col2,col3
	.if :0<>5
		.error "mScreenSetColors_M: 5 arguments (address of Background color, address of Color 0, address of Color 1, address of Color 2, address of Color 3) required."
	.else
        lda :cBack    ; Background -> A
        sta COLOR4    ; A -> COLOR4
        lda :col0     ; Color0 -> A
        sta COLOR0    ; A -> COLOR0
        lda :col1     ; Color1 -> A
        sta COLOR1    ; A -> COLOR1
        lda :col2     ; Color2 -> A
        sta COLOR2    ; A -> COLOR2
        lda :col3     ; Color3 -> A
        sta COLOR3    ; A -> COLOR3
	.endif
.endm


;------------------------------------------------------------------------------
; 							SCREENSETMODE_V
;------------------------------------------------------------------------------
; mScreenSetMode_V <mode number>
;
; Change all the instructions in the library's Display List to 
; a different (and vertically compatible) display mode.
; Modes 2, 4, and 6 are supported.
;------------------------------------------------------------------------------

.macro mScreenSetMode_V modeNum
	.if :0<>1
		.error "mScreenSetMode_V: 1 argument (mode 2, 4, or 6) required."
	.else
		.if :modNum=2 .or :modNum=4 .or :modNum=6
			lda #:modeNum
			jsr libScreenSetMode
		.else
			.error "mScreenSetMode_V: argument 1 for mode must be value 2, 4, or 6."
		.endif
	.endif
.endm

\
;------------------------------------------------------------------------------
; 							SCREENCHANGEMODEINSTRUCTION_M
;------------------------------------------------------------------------------
; mScreenChangeModeInstruction_M <instruction address> 
;
; Change a Display List instruction to a new mode.  
; it Masks out the mode, and changes it without changing the 
; instruction option bits, so DLI, scrolling, etc. remain set.
;
; Unless the programmer is engaging in display list mayhem, there 
; are not a great many reasons to invoke this macro.  This was 
; implemented to simplify the appearance of libScreenSetTextMode 
; which has several occurrences of playing with the display list
; instructions.
;
; ScreenChangeModeInstruction expects to get the mode from zbTemp.
;------------------------------------------------------------------------------

.macro mScreenChangeModeInstruction_M instruction
	.if :0<>1
		.error "mScreenChangeModeInstruction_M: 1 argument (display list instruction address) required."
	.else
		lda :instruction ; Get the current display list instruction.
		and #$F0         ; Remove the mode bits.  Keep current option bits.
		ora zbTemp       ; Replace the mode.
		sta :instruction ; Rewrite the display list instruction.
	.endif
.endm


;------------------------------------------------------------------------------
; 							SCREENWAITSCANLINE_V
;------------------------------------------------------------------------------
; mScreenWaitScanLine_V <target scan line value>
;
; Wait until ANTIC's scanline counter reaches a specific line.
; Nothing clever here to skip waiting if the scanline has already 
; passed in the current frame.
;
; Note that ANTIC's VCOUNT only counts every other scanline.
; This is not the terrible problem it sounds like, since the Atari does not 
; depend on the 6502 monitoring the scanline to make display-oriented 
; interrupts stable.
;------------------------------------------------------------------------------

.macro mScreenWaitScanLine_V scanLine
	.if :0<>1
		.error "mScreenSetColors: 1 argument (Target scanline value) required."
	.else
        lda #:scanLine                 ; Target Scanline
        jsr libScreenWaitScanLine 
	.endif
.endm


;------------------------------------------------------------------------------
; 							SCREENWAITFRAMES_V
;------------------------------------------------------------------------------
; mScreenWaitFrames_V <number of frames>
; 
; Wait for a number of screen display frames to finish.  
; This works by monitoring the jiffy clock that is updated by the 
; Operating System's Vertical Blank Interrupt.   When the clock 
; changes then a new frame has started.
;
; Wait for the current frame to change:  mScreenWaitFrames 1   which is 
; the same as calling the base routine directly, jsr ScreenWaitFrame
;------------------------------------------------------------------------------

.macro mScreenWaitFrames_V frameCount
	.if :0<>1
		.error "mScreenWaitFrames: 1 argument (Number of Frames) required."
	.else
        lda #:frameCount       ; Number of frames
        jsr libScreenWaitFrames 
	.endif
.endm

