;*******************************************************************************
;*
;* TEST MACROS
;*
;* Test Atari MADS Includes                     
;*
;*******************************************************************************

; ==========================================================================
; Atari System Includes (MADS assembler)
	icl "ANTIC.asm" ; Display List registers
	icl "GTIA.asm"  ; Color Registers.
	icl "POKEY.asm" ;
	icl "PIA.asm"   ; Controllers
	icl "OS.asm"    ;
	icl "DOS.asm"   ; LOMEM, load file start, and run addresses.
; --------------------------------------------------------------------------

; ==========================================================================
; Macros (No code/data declared)
	icl "macros.asm"
; --------------------------------------------------------------------------

; ==========================================================================
; Declare some Page Zero variables.
; The Atari OS owns the first half of Page Zero.

; The Atari load file format allows loading from disk to anywhere in
; memory, therefore indulging in this evilness to define Page Zero
; variables and load directly into them at the same time...
; --------------------------------------------------------------------------
	ORG $80

POS0 .byte $40 ; position of Player


; Now for the Code...
; Should be the first usable memory after DOS (and DUP?).

	ORG LOMEM_DOS
;	ORG LOMEM_DOS_DUP ; Use this if following DOS won't work.  or just use $5000

	; Label And Credit Where Ultimate Credit Is Due
	.by "** Thanks to the Word (John 1:1), Creator of heaven, and earth, and "
	.by "semiconductor chemistry and physics making all this fun possible. "
	.by "** Macros Test "
	.by "** Atari 8-bit computer systems. "
	.by "** Ken Jennings - Aug 2020 **"


	ORG $5000


;	.by ........1.1...1.1...1...1.111...11111.1111...... ..  
;	.by .......1..11..1.1...1..11.1..1..1.....1...1..... ..
;	.by ........1.1.1.1.1..1..1.1.1...1.1.11..1...1..... ..
;	.by ........1.1..11.1.1..1..1.1...1.1.....1.11...... ..
;	.by ........1.1...1.11..1.111.1...1.1.....1...1..... ..
;	.by ........1.1...1.1...1...1.1.111.11111.1...1..... ..

; We are trying for only 44 bits shifted 5 * 8 = 40 + 4

PM_TITLE_BITMAP_LINE1 ;	.by 00000000 10100010 10001000 10111000 11111011 11000000 00
	mBitmap16Left %0000000010100010

	mbitmap16Left %1010001010001000

	mbitmap16Left %1000100010111000   
	
	mbitmap16Left %1011100011111011  

	mbitmap16Left %1111101111000000
	
	mbitmap16LeftShift %1100000000000000,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE2 ; .by 00000001 00110010 10001001 10100100 10000010 00100000 00
	mBitmap16Left %0000000100110010

	mBitmap16Left %0011001010001001

	mBitmap16Left %1000100110100100   

	mBitmap16Left %1010010010000010  

	mBitmap16Left %1000001000100000 

	mBitmap16LeftShift %0010000000000000,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE3 ; .by 00000000 10101010 10010010 10100010 10110010 00100000 00
	mBitmap16Left %0000000010101010     

	mBitmap16Left %1010101010010010    

	mBitmap16Left %1001001010100010   

	mBitmap16Left %1010001010110010  

	mBitmap16Left %1011001000100000 

	mBitmap16LeftShift %0010000000000000,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE4 ; .by 00000000 10100110 10100100 10100010 10000010 11000000 00
	mBitmap16Left %0000000010100110     

	mBitmap16Left %1010011010100100    

	mBitmap16Left %1010010010100010   

	mBitmap16Left %1010001010000010  

	mBitmap16Left %1000001011000000 

	mBitmap16LeftShift %1100000000000000,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE5 ; .by 00000000 10100010 11001011 10100010 10000010 00100000 00
	mBitmap16Left %0000000010100010     

	mBitmap16Left %1010001011001011 

	mBitmap16Left %1100101110100010 

	mBitmap16Left %1010001010000010  

	mBitmap16Left %1000001000100000 

	mBitmap16LeftShift %0010000000000000,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE6 ; .by 00000000 10100010 10001000 10101110 11111010 00100000 00
	mBitmap16Left %0000000010100010 

	mBitmap16Left %1010001010001000    

	mBitmap16Left %1000100010101110   

	mBitmap16Left %1010111011111010  

	mBitmap16Left %1111101000100000 

	mBitmap16LeftShift %0010000000000000,0,3 ; 0, 1, 2, 3


;	********.*.***.*.***.***.*...***.....*....********  
;	*******.**..**.*.***.**..*.**.**.*****.***.*******
;	********.*.*.*.*.**.**.*.*.***.*.*..**.***.*******
;	********.*.**..*.*.**.**.*.***.*.*****.*..********
;	********.*.***.*..**.*...*.***.*.*****.***.*******
;	********.*.***.*.***.***.*.*...*.....*.***.*******

; We are trying for only 44 bits shifted 5 * 8 = 40 + 4

;	.by 11 11111101 01110101 11011101 00011100 00010000 11111111  
;	.by 11 11111011 00110101 11011001 01101101 11110111 01111111
;	.by 11 11111101 01010101 10110101 01110101 00110111 01111111
;	.by 11 11111101 01100101 01101101 01110101 11110100 11111111
;	.by 11 11111101 01110100 11010001 01110101 11110111 01111111
;	.by 11 11111101 01110101 11011101 01000100 00010111 01111111


PM_TITLE_BITMAP_LINE7 ;	.by 11 11111101 01110101 11011101 00011100 00010000 11111111  
	mBitmap16Right %0001000011111111 

	mbitmap16Right %0001110000010000

	mbitmap16Right %1101110100011100   
	
	mbitmap16Right %0111010111011101  

	mbitmap16Right %1111110101110101
	
	mbitmap16RightShift %1111111111111101,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE8 ;	.by 11 11111011 00110101 11011001 01101101 11110111 01111111
	mBitmap16Right %1111011101111111

	mbitmap16Right %0110110111110111

	mbitmap16Right %1101100101101101

	mbitmap16Right %0011010111011001

	mbitmap16Right %1111101100110101
	
	mbitmap16RightShift %1111111111111011,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE9 ;	.by 11 11111101 01010101 10110101 01110101 00110111 01111111
	mBitmap16Right %0011011101111111

	mbitmap16Right %0111010100110111

	mbitmap16Right %1011010101110101
	
	mbitmap16Right %0101010110110101

	mbitmap16Right %1111110101010101
	
	mbitmap16RightShift %1111111111111101,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE10 ;	.by 11 11111101 01100101 01101101 01110101 11110100 11111111
	mBitmap16Right %1111010011111111

	mbitmap16Right %0111010111110100

	mbitmap16Right %0110110101110101
	
	mbitmap16Right %0110010101101101

	mbitmap16Right %1111110101100101
	
	mbitmap16RightShift %1111111111111101,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE11 ;	.by 11 11111101 01110100 11010001 01110101 11110111 01111111
	mBitmap16Right %1111011101111111

	mbitmap16Right %0111010111110111

	mbitmap16Right %1101000101110101
	
	mbitmap16Right %0111010011010001

	mbitmap16Right %1111110101110100
	
	mbitmap16RightShift %1111111111111101,0,3 ; 0, 1, 2, 3


PM_TITLE_BITMAP_LINE12 ;	.by 11 11111101 01110101 11011101 01000100 00010111 01111111
	mBitmap16Right %0001011101111111

	mbitmap16Right %0100010000010111

	mbitmap16Right %1101110101000100
	
	mbitmap16Right %0111010111011101

	mbitmap16Right %1111110101110101
	
	mbitmap16RightShift %1111111111111101,0,3 ; 0, 1, 2, 3




	ORG $5400



PROGRAM_START

	jsr GfxInit

	lda #0
	sta COLOR2

	lda #$58
	sta PCOLOR0

	lda #PM_SIZE_DOUBLE
	sta SIZEP0

; Load animation frames into Player/Missile memory

AnimationLoop

; Left shift animation 

	lda #$40
	sta POS0 ; Page 0 shadow
	sta HPOSP0

	ldy #0

LeftAnimationLoop

	lda POS0
	sta HPOSP0
	
	ldx #128

	lda PM_TITLE_BITMAP_LINE1,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE2,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE3,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE4,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE5,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE6,Y
	jsr StuffitInPM0

	jsr PauseTicks
	
; Update next position of P/M graphics

	inc POS0
	inc POS0 ; double width is 2 color clocks.
	
; Loop for next image frame for P/M Graphics.

	iny
	cpy #44
	bne LeftAnimationLoop

; Done.   Reset.   

; Right shift animation 

	ldy #0

RightAnimationLoop

	dec POS0
	dec POS0
		
	lda POS0
	sta HPOSP0
	
	ldx #128

	lda PM_TITLE_BITMAP_LINE7,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE8,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE9,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE10,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE11,Y
	jsr StuffitInPM0

	lda PM_TITLE_BITMAP_LINE12,Y
	jsr StuffitInPM0

	jsr PauseTicks

	iny
	cpy #44
	bne RightAnimationLoop

; Done.   Reset.   
	
	jmp AnimationLoop

Do_While_More_Electricity
	jmp Do_While_More_Electricity


	rts


;==============================================================================
;												Pause5Ticks  X
;==============================================================================
; Pause for a number of vertical blank jiffies.
; -----------------------------------------------------------------------------

PauseTicks
	ldx #5

NextClockTick
	lda RTCLOK60

WaitForFrame
	cmp RTCLOK60
	beq WaitForFrame

	dex
	bne NextClockTick

	rts


;==============================================================================
;												StuffitInPM0  X
;==============================================================================
; Given data in  A  write intothe current  X  position and increment 
; X  for each write.
; -----------------------------------------------------------------------------

StuffitInPM0
	sta PLAYERADR0,X
	inx
	sta PLAYERADR0,X
	inx
	sta PLAYERADR0,X
	inx

	rts


;==============================================================================
;												PmgInit  A  X  Y
;==============================================================================
; One-time setup tasks to do Player/Missile graphics.
; -----------------------------------------------------------------------------

libPmgInit

	jsr libPmgAllZero  ; get all Players/Missiles off screen, etc.
	
	; clear all bitmap images
	jsr libPmgClearBitmaps

;	; Load text labels into P/M memory
;	jsr LoadPMGTextLines

	; Tell ANTIC where P/M memory is located for DMA to GTIA
	lda #>PMADR
	sta PMBASE

	; Enable GTIA to accept DMA to the GRAFxx registers.
	lda #ENABLE_PLAYERS|ENABLE_MISSILES
	sta GRACTL

	; Set all the ANTIC screen controls and DMA options.
	lda #ENABLE_DL_DMA|PM_1LINE_RESOLUTION|ENABLE_PM_DMA|PLAYFIELD_WIDTH_NORMAL
	sta SDMCTL

	lda #[GTIA_MODE_DEFAULT|%0001] ; Default priority 
	sta GPRIOR

	rts 


;==============================================================================
;											SetPmgHPOSZero  A  X
;==============================================================================
; Zero the hardware HPOS registers.
;
; Useful for DLI which needs to remove Players from the screen.
; With no other changes (i.e. the size,) this is sufficient to remove 
; visibility for all Player/Missile overlay objects 
; -----------------------------------------------------------------------------

libSetPmgHPOSZero

	lda #$00                ; 0 position

	sta HPOSP0 ; Player positions 0, 1, 2, 3
	sta HPOSP1
	sta HPOSP2
	sta HPOSP3
	sta HPOSM0 ; Missile positions 0, 1, 2, 3
	sta HPOSM1
	sta HPOSM2
	sta HPOSM3

	rts


;==============================================================================
;											PmgAllZero  A  X
;==============================================================================
; Simple hardware reset of all Player/Missile registers.
; Typically used only at program startup to zero everything
; and prevent any screen glitchiness on startup.
;
; Reset all Players and Missiles horizontal positions to 0, so
; that none are visible no matter the size or bitmap contents.
; Zero all colors.
; Also reset sizes to zero.
; -----------------------------------------------------------------------------

libPmgAllZero

	jsr libSetPmgHPOSZero   ; Sets all HPOS off screen.

	lda #$00                ; 0 position
	ldx #$03                ; four objects, 3 to 0

bAZ_LoopZeroPMSpecs
	sta SIZEP0,x            ; Player width 3, 2, 1, 0
	sta PCOLOR0,x           ; And black the colors.
	dex
	bpl bAZ_LoopZeroPMSpecs

	sta SIZEM



	rts


;==============================================================================
;											PmgClearBitmaps  A  X
;==============================================================================
; Zero the bitmaps for all players and missiles
; 
; Try to make this called only once at game initialization.
; All other P/M  use should be orderly and clean up after itself.
; Residual P/M pixels are verboten.
; -----------------------------------------------------------------------------

libPmgClearBitmaps

	lda #$00
	tax      ; count 0 to 255.

bCB_Loop
	sta MISSILEADR,x  ; Missiles
	sta PLAYERADR0,x  ; Player 0
	sta PLAYERADR1,x  ; Player 1
	sta PLAYERADR2,x  ; Player 2
	sta PLAYERADR3,x  ; Player 3
	inx
	bne bCB_Loop      ; Count 1 to 255, then 0 breaks out of loop

	rts


;==============================================================================
;											GfxInit
;==============================================================================

GfxInit
	; Atari initialization stuff...

	lda #AUDCTL_CLOCK_64KHZ    ; Set only this one bit for clock.
	sta AUDCTL                 ; Global POKEY Audio Control.
	lda #3                     ; Set SKCTL to 3 to stop possible cassette noise, 
	sta SKCTL                  ; so say Mapping The Atari and De Re Atari.

	lda #0                     ; Zero AUDC1-4, AUDF1-4
	ldx #7
LoopInitZeroSound
	sta AUDC1,X                ; Stop POKEY playing.
	dex
	bpl LoopInitZeroSound

	lda #COLOR_BLACK+$E        ; COLPF3 is white on all screens. it is up to DLIs to modify otherwise.
	sta COLOR3

	jsr libPmgInit             ; Will also reset SDMACTL settings for P/M DMA

	rts                         ; And now ready to go back to main game loop . . . .




; ==========================================================================
; PLAYER/MISSILE GRAPHICS MEMORY
;
; --------------------------------------------------------------------------

	.align $0800 ; single line P/M needs 2K boundary.

PMADR

MISSILEADR = PMADR+$300
PLAYERADR0 = PMADR+$400
PLAYERADR1 = PMADR+$500
PLAYERADR2 = PMADR+$600
PLAYERADR3 = PMADR+$700



; ==========================================================================
; Inform DOS of the program's Auto-Run address...
; PROGRAM_START is declared above, earlier in the file.
; --------------------------------------------------------------------------

	mDiskDPoke DOS_RUN_ADDR, PROGRAM_START


	END

