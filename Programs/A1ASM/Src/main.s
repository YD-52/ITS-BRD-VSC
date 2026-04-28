;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke
;* Version            : V1.0 (optimiert)
;* Date               : 01.06.2021
;* Description        : Endzustand der LEDs in einem Befehl setzen
;*******************************************************************************
    EXTERN initITSboard
    EXPORT main

; GPIO-Adressen
PERIPH_BASE         equ 0x40000000
AHB1PERIPH_BASE     equ (PERIPH_BASE + 0x00020000)
GPIOD_BASE          equ (AHB1PERIPH_BASE + 0x0C00)

GPIO_D_SET          equ (GPIOD_BASE + 0x18)     ; LED an
GPIO_D_CLR          equ (GPIOD_BASE + 0x1A)     ; LED aus

    AREA  |.text|, CODE, READONLY, ALIGN = 3
    ALIGN
main
    BL initITSboard             ; Board-Setup
    nop
    LDR     R6, =GPIO_D_SET     ; SET-Register
    LDR     R7, =GPIO_D_CLR     ; CLR-Register (hier nicht mehr genutzt)
    MOV     R0, #0x03           ; Maske 0b00000011 -> D08 + D09

    ; Endzustand: D08 und D09 an
    STRB    R0, [R6]

    ; --- Original ---
    ; MOV     R1, #0x02         ; 0b00000010 (D09)
    ; MOV     R2, #0x40         ; 0b01000000 (D14)
    ; MOV     R3, #0x80         ; 0b10000000 (D15)
    ; STRB    R2, [R6]          ; D14 an
    ; STRB    R3, [R6]          ; D15 an
    ; STRB    R0, [R6]          ; D08 an
    ; STRB    R0, [R7]          ; D08 aus
    ; STRB    R0, [R6]          ; D08 an
    ; STRB    R1, [R6]          ; D09 an
    ; STRB    R2, [R7]          ; D14 aus
    ; STRB    R3, [R7]          ; D15 aus

    b .

    ALIGN
    END