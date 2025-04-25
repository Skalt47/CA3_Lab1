
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
SPEED:  EQU     $FFFF                   ; Change this number to change counting speed
SPEED_X: EQU    100
SPEED_Y: EQU    65535


; RAM: Variable data section
.data: SECTION
counter_L: DS.B 1          ; Low byte of counter (8 bits)
counter_H: DS.B 1          ; High byte of counter (8 bits)

; ROM: Constant data
.const: SECTION


; ROM: Code section
.init: SECTION


main:                                   ; Begin of the program
Entry:
        LDS  #__SEG_END_SSTACK          ; Initialize stack pointer
        CLI                             ; Enable interrupts, needed for debugger

         LDAA    #$FF
        STAA    DDRB                    ; Configure PORTB as output

        ; --- Initialize counter to 0 ---
        CLRA
        STAA    counter_L
        STAA    counter_H

loop:
        ; --- Load 16-bit counter into X register ---
        LDAA    counter_L
        LDAB    counter_H
        PSHB
        PSHA
        PULX                            ; A = low, B = high ? combined to X

        ; Optional: store back (not necessary here)
        STX     counter_L

        ; --- Output low byte to LEDs ---
        LDAA    counter_L
        STAA    PORTB

        ; --- Delay (~0.5s) ---
        JSR     delay_0_5sec

        ; --- Increment counter by 2 ---
        LDAA    counter_L
        ADDA    #2
        STAA    counter_L

        ; --- Carry to high byte if needed ---
        BCC     no_carry
        INC     counter_H
no_carry:

        ; --- Reset if counter reaches 64 ---
        LDAA    counter_L
        CMPA    #64
        BNE     loop

        CLRA
        STAA    counter_L
        STAA    counter_H
        BRA     loop

; ---------------------------------------------------------
; Subroutine: delay_0_5sec
; Delay ~0.5 seconds (nested loop)
; Registers D, X, Y may be modified
; ---------------------------------------------------------
delay_0_5sec:
        LDX     #SPEED_X
outer_loop:
        LDY     #SPEED_Y
inner_loop:
        DEY
        BNE     inner_loop
        DEX
        BNE     outer_loop
        RTS