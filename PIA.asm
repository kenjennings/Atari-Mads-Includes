;=================================================
; PIA register list
; for atasm
; Ken Jennings
;=================================================
; Hardware Registers
;
PORTA = $D300 ; Joystick ports 1 and 2, STICK0 and STICK1
PORTB = $D301 ; Joystick ports 3 and 4, STICK2 and STICK3
PACTL = $D302 ; Port A Control
PBCTL = $D303 ; Port B Control
;=================================================
; Shadow Registers for Hardware Registers...
; The system vertical blank routine extracts bits 
; from PORTA/PORTB and distributes the values to 
; the shadow registeres below.
;
STICK0 = $0278 
STICK1 = $0279
STICK2 = $027A
STICK3 = $027B
;
PTRIG0 = $027C
PTRIG1 = $027D
PTRIG2 = $027E
PTRIG3 = $027F
PTRIG4 = $0280
PTRIG5 = $0281
PTRIG6 = $0282
PTRIG7 = $0283
;=================================================
; Important Bit Positions
;
; MASK_JACK is about referencing the actual hardware registers.
; You can do this if you want to, however the OS already separates 
; the joysticks into individual OS register value (STICKx), so
; there's not a lot of reason to read the joystick 
; hardware directly.
MASK_JACK_1 = %00001111 ; Actually the anti-mask.  Keeps bits from first controller in pair.
MASK_JACK_2 = %11110000 ; The inverse of mask.  Keeps bits from second controller in pair.
MASK_JACK_3 = %00001111 ; Actually the anti-mask.  Keeps bits from first controller in pair.
MASK_JACK_4 = %11110000 ; The inverse of mask.  Keeps bits from second controller in pair.
;
; Note that 0 bit is pressed.  1 bit is not pressed.
; Reading "JACK" registers gives two joystick values.  
; The Joystick's bits in the high nybble should be right shifted 
; into the low nybble for testing.
; Or just use the STICKx shadow register as that is its purpose.  
; Bits for STICKx shadow regs below:
MASK_STICK_RIGHT = %11110111
MASK_STICK_LEFT =  %11111011
MASK_SITCK_UP =    %11111101
MASK_STICK_DOWN =  %11111110
;
STICK_RIGHT = %00001000 ; AND with STICKx. If 0, then pressed. If 1, then not pressed.
STICK_LEFT =  %00000100
SITCK_UP =    %00000010
STICK_DOWN =  %00000001
;
; PACTL and PBCTL
MASK_PORT_SERIAL_IRQ =   %01111111 ; (Read)
MASK_MOTOR_CONTROL =     %11110111 ; PACTL Peripheral motor control (cassette)
MASK_COMMAND_IDENT =     %11110111 ; PBCTL Peripheral command identification
MASK_PORT_ADDRESSING =   %11111011 ; PACTL 0 = Port direction control. 1 = Read port.
MASK_SERIAL_IRQ_ENABLE = %11111110
;
PORT_SERIAL_IRQ =   %10000000 ; (Read)
MOTOR_CONTROL =     %00001000 ; PACTL
COMMAND_IDENT =     %00001000 ; PBCTL
PORT_ADDRESSING =   %00000100
SERIAL_IRQ_ENABLE = %00000001
;
; PBCTL for the XL
MASK_SELECT_OS_ROM =      %11111110 ; Turn OS ROM on and off
MASK_SELECT_BASIC_ROM =   %11111101 ; Turn BASIC ROM on and off
MASK_LED_1_KEYBOARD =     %11111011 ; 1200XL LED 1, enable/disable keyboard
MASK_LED_2_INTL_CHARSET = %11110111 ; 1200XL LED 2, enable international character set
MASK_SELF_TEST_ROM =      %01111111 ; Expose Self Test at $5000
;
SELECT_OS_ROM =      %00000001
SELECT_BASIC_ROM =   %00000010
LED_1_KEYBOARD =     %00000100
LED_2_INTL_CHARSET = %00001000
SELF_TEST_ROM =      %10000000

