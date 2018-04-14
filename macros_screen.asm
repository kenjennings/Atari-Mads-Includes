;===============================================================================
; Constants

; Color constants are supplied by GTIA.asm.  See mScreenSetColors for details.

SpaceATASCII    = $20
SpaceScreenCode = $00

False           = 0
True            = 1


;===============================================================================
; Macros/Subroutines


;==============================================================================
; mScreenFillMem
;
; warpper to call library routine ScreenFillMem.
;
; mScreenFillMem is like a generic routine to clear memory, but it 
; specifically sets 1,040 sequential bytes for screen memory.
;
; Arguments:
; 1 = Value (byte value to fill screen memory).
; If Value is greater the 255 it assumes the value is the memeory location
; containing the byte to use for screen memory.

.macro mScreenFillMem fillByte
	.if :0<>1
		.error "mScreenFillMem: 1 argument (byte to fill) required."
	.else
		.if :fillByte<256
			lda #:fillByte
		.else
			lda :fillByte
		.endif
		jsr ScreenFillMem
	.endif
.endm


;===============================================================================
; mScreenSetColors
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

.macro mScreenSetColors cBack,col0,col1,col2,col3
	.if :0<>5
		.error "mScreenSetColors: 5 arguments (Background color, Color 0, Color 1, Color 2, Color 3) required."
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


;===============================================================================
; mScreenSetColors
;
; Same as above, but instead of using constant value it 
; gets its color values from memory.

.macro mScreenSetColors_M cBack,col0,col1,col2,col3
	.if :0<>5
		.error "mScreenSetColors_M: 5 arguments (Background color, Color 0, Color 1, Color 2, Color 3) required."
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


;==============================================================================
; mScreenSetMode
;
; Change all the instructions in the library's Display List to 
; a different (and vertically compatible) display mode.
; Modes 2, 4, and 6 are supported.

.macro mScreenSetMode modeNum
	.if :0<>1
		.error "mScreenSetMode: 1 argument (mode 2, 4, or 6) required."
	.else
		.if :modNum=2 .or :modNum=4 .or :modNum=6
			lda #:modNum
			jsr ScreenSetMode
		.else
			.error "mScreenSetMode: argument 1 for mode must be value 2, 4, or 6."
		.endif
	.endif
.endm


;===============================================================================
; mScreenWaitScanLine
;
; Wait until ANTIC's scanline counter reaches a specific line.
; Nothing clever here to skip waiting if the scanline has already 
; passed in the current frame.
;
; Note that ANTIC's VCOUNT only counts every other scanline.
; This is not the terrible problem it sounds like, since the Atari does not 
; depend on the 6502 monitoring the scanline to make display-oriented 
; interrupts stable.

.macro mScreenWaitScanLine scanLine
	.if :0<>1
		.error "mScreenSetColors: 1 argument (Target scanline value) required."
	.else
        lda #:scanLine                 ; Target Scanline
        jsr ScreenWaitScanLine 
	.endif
.endm


;===============================================================================
; mScreenWaitFrames
; 
; Wait for a number of screen display frames to finish.  
; This works by monitoring the jiffy clock that is updated by the 
; Operating System's Vertical Blank Interrupt.   When the clock 
; changes then a new frame has started.
;
; Wait for the current frame to change:  mScreenWaitFrames 1   which is 
; the same as calling the base routine directly, jsr ScreenWaitFrame

.macro mScreenWaitFrames frameCount
	.if :0<>1
		.error "mScreenWaitFrames: 1 argument (Number of Frames) required."
	.else
        lda #:frameCount       ; Number of frames
        jsr ScreenWaitFrames 
	.endif
.endm

