;******************** (C) COPYRIGHT HAW-Hamburg ********************************
;* File Name          : main.s
;* Author             : Martin Becke
;* Version            : V1.0 (erweitert fuer Aufgabe 2)
;* Date               : 01.06.2021
;* Description        : Datentransfer und Bit-Manipulation
;*******************************************************************************
    EXTERN initITSboard
    EXPORT main

ConstByteA  EQU 0xaffe

;* Datenbereich
    AREA DATA, DATA, align=2    
VariableA   DCW 0xbeef
VariableB   DCW 0x1234
VariableC   DCW 0x0000          ; Ziel fuer affe (byte-swapped)

;* Code
    AREA  |.text|, CODE, READONLY, ALIGN = 3    
    ALIGN   
main
    BL initITSboard

;* Byte-Swap von beef -> Memory zeigt "BE EF"
    ldr     R0,=VariableA       ; Anw01: Adresse VariableA in R0
    ldrb    R2,[R0]             ; Anw02: low byte (0xEF) -> R2
    ldrb    R3,[R0,#1]          ; Anw03: high byte (0xBE) -> R3
    lsl     R2, #8              ; Anw04: R2 um 8 Bit nach links (0xEF00)
    orr     R2, R3              ; Anw05: R2 oder R3 -> R2 = 0xEFBE
    strh    R2,[R0]             ; Anw06: zurueckschreiben -> Memory: BE EF
    
;* Konstante affe nach VariableC, byte-swapped -> Memory zeigt "AF FE"
    mov     R5,#ConstByteA      ; Anw07: R5 = 0x0000AFFE
    ldr     R4,=VariableC       ; Adresse VariableC in R4
    and     R2, R5, #0xFF       ; low byte 0xFE -> R2
    lsr     R3, R5, #8          ; high byte 0xAF -> R3
    lsl     R2, #8              ; R2 = 0xFE00
    orr     R2, R3              ; R2 = 0xFEAF
    strh    R2,[R4]             ; Anw08: schreiben -> Memory: AF FE
    
;* VariableB so schreiben, dass Memory "12 34" zeigt
    ldr     R1,=VariableB       ; Anw09: Adresse VariableB in R1
    mov     R6, #0x3412         ; Anw0A: little-endian -> Memory: 12 34
    strh    R6,[R1]             ; Anw0B: schreiben
    b .                         ; Anw0C
    
    ALIGN
    END