;===============================================================================
; ANTIC register list
; For Mads assembler
; Ken Jennings
;===============================================================================
; Hardware Registers
;
DMACTL = $D400 ; DMA control for display and Player/Missile graphics
CHACTL = $D401 ; Character display control
DLISTL = $D402 ; Display List Pointer (low)
DLISTH = $D403 ; Display List Pointer (high)
HSCROL = $D404 ; Horizontal Fine Scroll 0 to 16 color clocks.
VSCROL = $D405 ; Vertical Fine Scroll 0 to 16 scanlines.
PMBASE = $D407 ; Player/Missile Base Address (high) 
CHBASE = $D409 ; Character Set Base Address (high)
WSYNC =  $D40A ; Wait for Horizontal Sync
VCOUNT = $D40B ; (Read) Vertical Scan Line Counter
PENH =   $D40C ; (Read) Light Pen Horizontal Position
PENV =   $D40D ; (Read) Light Pen Vertical Position
NMIEN =  $D40E ; Non-Maskable Interupt (NMI) Enable
NMIRES = $D40F ; Non-Maskable Interrupt (NMI) Reset
NMIST =  $D40F ; (Read) Non-Maskable Interrupt Status
;
;-------------------------------------------------------------------------------
; Shadow Registers for Hardware Registers
;
SDMCTL = $022F ; DMACTL
SDLSTL = $0230 ; DLISTL
SDLSTH = $0231 ; DLISTH
;
CHBAS = $02F4 ; CHBASE
CHART = $02F3 ; CHACTL
;
LPENH = $0234 ; (Read) PENH
LPENV = $0235 ; (Read) PENV
;
;-------------------------------------------------------------------------------
; Important Bit Positions
;
; DMACTL and SDMCTL - DMA control for display and Player/Missile graphics
;
MASK_DL_DMA =          %11011111 ; Enable/Disable DMA to read the Display List
MASK_PM_RESOLUTION =   %11101111 ; Set P/M graphics DMA to 1 or 2 scan line per update  
MASK_PM_DMA =          %11110011 ; Enable/Disable DMA for Players/Missiles
MASK_PLAYFIELD_WIDTH = %11111100 ; Enable playfield display/set playfield width
;
; DMACTL and SDMCTL - Enable/Disable DMA to read the Display List
;
ENABLE_DL_DMA =  %00100000
DISABLE_DL_DMA = %00000000  ; defining this is overkill
;
; DMACTL and SDMCTL - Set P/M graphics DMA to 1 or 2 scan line per update  
;
PM_1LINE_RESOLUTION = %00010000
PM_2LINE_RESOLUTION = %00000000
;
; DMACTL and SDMCTL - Enable DMA for Players/Missiles
;
ENABLE_PLAYER_DMA =  %00001000
ENABLE_MISSILE_DMA = %00000100
ENABLE_PM_DMA =      %00001100
;
; DMACTL and SDMCTL - Enable playfield display/set playfield width
;
PLAYFIELD_DISABLE =      %00000000 ; No width is the same as no display
PLAYFIELD_WIDTH_NARROW = %00000001 ; 32 characters/128 color clocks
PLAYFIELD_WIDTH_NORMAL = %00000010 ; 40 characters/160 color clocks
PLAYFIELD_WIDTH_WIDE =   %00000011 ; 48 characters/192 color clocks (176 visible)
;
; CHACTL - Character display control
;
MASK_CHACTL_REFLECT = %11111011 ; Enable/Disable vertical reflect
MASK_CHACTL_INVERSE = %11111101 ; Enable/Disable characters with high bit set displayed as inverse 
MASK_CHACTL_BLANK =   %11111110 ; Enable/Disable characters with high bit set displayed as blank space
;
; CHACTL - Enable character display options
; 
CHACTL_REFLECT = %00000100 ; Enable vertical reflect
CHACTL_INVERSE = %00000010 ; Enable inverse display for characters with high bit set
CHACTL_BLANK =   %00000001 ; Enable blank display for characters with high bit set
;
; NMIEN (NMIRES and NMIST) - Non-Maskable Interupt (NMI) Reset and Status
;
MASK_NMI_DLI =   %01111111 ; Enable/Disable Display List Interrupts
MASK_NMI_VBI =   %10111111 ; Enable/Disable Vertical Blank Interrupt
MASK_NMI_RESET = %11011111 ; Enable/Disable Reset Key Interrupt
;
; NMIEN (NMIRES and NMIST) - Enable Non-Maskable Interupts
;
NMI_DLI =   %10000000 ; Enable Display List Interrupts
NMI_VBI =   %01000000 ; Enable Vertical Blank Interrupt
NMI_RESET = %00100000 ; Enable Reset Key Interrupt
;
;=================================================
; Display List Instructions/Options Mask
;
MASK_DL_DLI =     %01111111 ; Display List Interrupt on last scan line of graphics line
MASK_DL_LMS =     %10111111 ; Reload Memory Scan address for this graphics line
MASK_DL_VSCROLL = %11011111 ; Vertical scrolling for this graphics line
MASK_DL_HSCROLL = %11101111 ; Horizontal scrolling for this graphics line
MASK_DL_MODE =    %11110000 ; Text/Graphics Modes
;
; Display List Instruction Options
;
DL_DLI =     %10000000 ; Enable Display List Interrupt on last scan line of graphics line
DL_LMS =     %01000000 ; Enable Reload Memory Scan address for this graphics line
DL_VSCROLL = %00100000 ; Enable Vertical scrolling for this graphics line
DL_HSCROLL = %00010000 ; Enable Horizontal scrolling for this graphics line
;
DL_MODE =    %00001111 ; Collection of Text/Graphics Modes
;
; Display List Instructions, Jump 
;
DL_JUMP =    $01 ; Display List jump to new address
DL_JUMP_VB = $41 ; Display List jump to address and start Vertical Blank
;
; Display List Instructions, blank scan lines
; Note that bit $80 is not part of this, so the
; DL_DLI Instruction Option is available for 
; the blank line instructions.
;
DL_BLANK_1 = $00 ; 1 Blank Scan line
DL_BLANK_2 = $10 ; 2 Blank Scan lines
DL_BLANK_3 = $20 ; 3 Blank Scan lines
DL_BLANK_4 = $30 ; 4 Blank Scan lines
DL_BLANK_5 = $40 ; 5 Blank Scan lines
DL_BLANK_6 = $50 ; 6 Blank Scan lines
DL_BLANK_7 = $60 ; 7 Blank Scan lines
DL_BLANK_8 = $70 ; 8 Blank Scan lines
;
; Display List Instructions, Text Modes, specs for Normal width
;
DL_TEXT_2 = $02 ; 1.5 Color, 40 Columns X 8 Scan lines, 40 bytes/line
DL_TEXT_3 = $03 ; 1.5 Color, 40 Columns X 10 Scan lines, 40 bytes/line
DL_TEXT_4 = $04 ; 4/5 Color, 40 Columns X 8 Scan lines, 40 bytes/line
DL_TEXT_5 = $05 ; 4/5 Color, 40 Columns X 16 Scan lines, 40 bytes/line
DL_TEXT_6 = $06 ; 5 Color, 20 Columns X 8 Scan lines, 20 bytes/line
DL_TEXT_7 = $07 ; 5 Color, 20 Columns X 16 Scan lines, 20 bytes/line
;
; Display List Instructions, Map Modes
;
DL_MAP_8 = $08 ; 4 Color, 40 Pixels x 8 Scan Lines, 10 bytes/line
DL_MAP_9 = $09 ; 2 Color, 80 Pixels x 4 Scan Lines, 10 bytes/line
DL_MAP_A = $0A ; 4 Color, 80 Pixels x 4 Scan Lines, 20 bytes/line
DL_MAP_B = $0B ; 2 Color, 160 Pixels x 2 Scan Lines, 20 bytes/line
DL_MAP_C = $0C ; 2 Color, 160 Pixels x 1 Scan Lines, 20 bytes/line
DL_MAP_D = $0D ; 4 Color, 160 Pixels x 2 Scan Lines, 40 bytes/line
DL_MAP_E = $0E ; 4 Color, 160 Pixels x 1 Scan Lines, 40 bytes/line
DL_MAP_F = $0F ; 1.5 Color, 320 Pixels x 1 Scan Lines (and GTIA modes), 40 bytes/line
;
; Macros 
;
;-------------------------------------------------------------------------------
;								DL_BLANK
;-------------------------------------------------------------------------------
; mDL_BLANK <Lines>
;
; Declares a Blank line instruction for 1 through 8 blank lines 
; which should be expressed as DL_BLANK_1 through DL_BLANK_8.
; Note that "Lines" argument value may include the bit for DLI.
; 
; This may be used one of two ways...
; The value spacified may be the actual value of the blank line instruction; 
; OR it may be the simple numeric value 0 to 7 to specify the 1 to 8 scan lines.
; The DLI bit may be added to either value.
;
; So, first, preserve the DLI bit, if present.
; Next, preserve and separate the  DL_BLANK_X bits ( %01110000) ($70)
; and the equivalent numeric value (%00000111) ($07).
;
; If the known unused bit (%00001000) ($080) is set, then this is an 
; up front error.
;
; If bits are set in the low nybble value and the blank instruction bits are 
; set, too, then this is a problem.
;
;-------------------------------------------------------------------------------

.macro mDL_BLANK  lines
	.if :0<>1
		.error "mDL_BLANK: 1 argument required, number of blank lines 0 to 7."
	.endif

;	.print "** mDL_BLANK lines  = ",:lines
	
	TEMP_MDL_DLI=[[:lines] & DL_DLI]
;	.print "mDL_BLANK DLI    = ",TEMP_MDL_DLI 

	TEMP_MDL_UNUSED=[[:lines] & %00001000]
;	.print "mDL_BLANK UNUSED = ",TEMP_MDL_UNUSED 

	TEMP_MDL_HI_NYB=[[:lines] & %01110000]
;	.print "mDL_BLANK HI     = ",TEMP_MDL_HI_NYB

	TEMP_MDL_LO_NYB=[[:lines] & %00000111]
;	.print "mDL_BLANK LO     = ",TEMP_MDL_LO_NYB
	
	.if TEMP_MDL_UNUSED>0
		.error "mDL_BLANK: lines argument must not have bit %00001000/$08 set."
	.endif
	 
	.if TEMP_MDL_HI_NYB>0 ; BLANK instruction passed
		.if TEMP_MDL_LO_NYB>0 ; Bits are on in the low nybble too.  This is bad.
			.error "mDL_BLANK: lines argument must not have bits set in the high and low nybbles.  Use 0 to 7."
		.else ; Bits on in the instruction part.  So, use that
			.byte [TEMP_MDL_DLI|TEMP_MDL_HI_NYB]
		.endif
	.else ; No bits in the Instruction. Assume we're using the 0 to 7 numeric, and multiply to shift bits.
		.byte [TEMP_MDL_DLI|[TEMP_MDL_LO_NYB * 16]]
	.endif

.endm


;-------------------------------------------------------------------------------
;								DL 
;-------------------------------------------------------------------------------
; mDL <DLmode>
;
; Declares display list instruction without LMS address operand.
;
; Note that this will not verify the LMS bit is off, so that it can 
; be called by the mDL_LMS macro.  So, potential hole for ugly errors.
;-------------------------------------------------------------------------------

.macro mDL  mode
	.if :0<>1
		.error "mDL: 1 argument required, mode (value of low nybble $2 to $F)."
	.endif

;	.print "** mDL Mode = ",:mode

	TEMP_MDL_MODE=[[:mode]&$0F]
;	.print "mDL Temp = ",TEMP_MDL_MODE
	
	.if TEMP_MDL_MODE<DL_TEXT_2
		.error "mDL: graphics mode argument must have a low nybble value from $2 to $F."
	.endif

	; Byte for Mode value.
	.byte [:mode]  
	
.endm


;-------------------------------------------------------------------------------
; 								DL_LMS 
;-------------------------------------------------------------------------------
; mDL_LMS <DLmode>, <Address>
;
; Declares data for the provided display list instruction, adds the LMS 
; option, and then the supplied address in memory.
;
; Note that for validity checks it is only looking at the low nybble for
; the graphics mode, and then it simply ORs in the LMS option.
; This means the "mode" argument could include other options and
; even (redundantly) the LMS.
;-------------------------------------------------------------------------------

.macro mDL_LMS  mode,screenMemory
	.if :0<>2
		.error "** mDL_LMS: 2 arguments required, mode (value of low nybble $2 to $F), screen memory (address)."
	.endif

;	.print "** mDL_LMS Mode = ",:mode
;	.print "** mDL_LMS Mem  = ",:screenMemory

	; Byte for Mode plus LMS option.  And then the screen memory address.
	mDL [[:mode]|DL_LMS]
	.word [:screenMemory]

.endm


;-------------------------------------------------------------------------------
;								DL_JMP
;-------------------------------------------------------------------------------
; mDL_JMP <Address>
;
; Declares a JMP DL instruction with the new Display List address in memory.
;
;-------------------------------------------------------------------------------

.macro mDL_JMP  screenMemory
	.if :0<>1
		.error "mDL_JMP: 1 argument required, screen memory (address)."
	.endif

	; Byte for JMP.  And then the screen memory address.
	.byte DL_JUMP
	.word [:screenMemory]

.endm


;-------------------------------------------------------------------------------
; 								DL_JVB
;-------------------------------------------------------------------------------
; mDL_JVB <Address>
;
; Declares a JVB DL instruction (Jump Vertical Blank) with the new 
; Display List address in memory.
;
;-------------------------------------------------------------------------------

.macro mDL_JVB  dlMemory
	.if :0<>1
		.error "mDL_JVB: 1 argument required, display list memory (address)."
	.endif

	; Byte for JVB.  And then the display list memory address.
	.byte DL_JUMP_VB
	.word [:dlMemory]

.endm
