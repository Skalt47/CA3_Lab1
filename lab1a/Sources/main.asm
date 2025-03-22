
;   Labor 1 - Problem 2.2
;   Incrementing a value once per second and binary output to LEDs
;
;   Computerarchitektur
;   (C) 2019-2022 J. Friedrich, W. Zimmermann, R. Keller
;   Hochschule Esslingen
;
;   Author:   R. Keller, HS-Esslingen
;            (based on code provided by J. Friedrich, W. Zimmermann)
;   Modified: -
;

; export symbols
        XDEF Entry, main

; import symbols
        XREF __SEG_END_SSTACK           ; End of stack

; include derivative specific macros
        INCLUDE 'mc9s12dp256.inc'

; Defines
;SPEED:  EQU     $FFFF                   ; Change this number to change counting speed
 SPEED_X: EQU    100
 SPEED_Y: EQU    65535

; RAM: Variable data section
.data: SECTION

; ROM: Constant data
.const: SECTION

; ROM: Code section
.init: SECTION

main:                                   ; Begin of the program
Entry:
        LDS  #__SEG_END_SSTACK          ; Initialize stack pointer
        CLI                             ; Enable interrupts, needed for debugger
        
        LDAA #$FF
        STAA DDRB

; --- ADDED FROM HERE ---
loop:
        LDAA    #$AA                    ; Load pattern (10101010) into A
        STAA    PORTB                   ; Output to LEDs
        JSR     delay                   ; Wait
        LDAA    #$00                    ; Turn off LEDs
        STAA    PORTB
        JSR     delay
        BRA     loop                    ; Repeat forever
; --- ADDED UNTIL HERE ---

; --- ADDED: simple delay subroutine ---
delay:
        LDX     #SPEED_X
outer_loop:
        LDY     #SPEED_Y
inner_loop:
        DEY
        BNE     inner_loop
        DEX
        BNE     outer_loop
        RTS
; --- END OF ADDED SECTION --- 


