;************************************************
;* Beginn der globalen Daten
;************************************************
                   AREA MyData, DATA, align = 2
Base
VariableA          DCW 0x1234
VariableB          DCW 0x4711

VariableC          DCD  0

MeinHalbwortFeld   DCW 0x22 , 0x3e , -52, 78 , 0x27 , 0x45

MeinWortFeld       DCD 0x12345678 , 0x9dca5986
                   DCD -872415232 , 1308622848
                   DCD 0x27000000
                   DCD 0x45000000

MeinTextFeld       DCB "ABab0123",0

                   EXPORT VariableA
                   EXPORT VariableB
                   EXPORT VariableC
                   EXPORT MeinHalbwortFeld
                   EXPORT MeinWortFeld
                   EXPORT MeinTextFeld

;***********************************************
;* Beginn des Programms
;************************************************
    AREA |.text|, CODE, READONLY, ALIGN = 3
; ----- Start des Hauptprogramms -----
                EXPORT main
                EXTERN initITSboard
main            PROC
                bl    initITSboard                 ; Hardware initialisieren

; --- Laden von Konstanten in Register ---
                ; kleine Konstante 0x12 direkt ins Maschinenwort
                mov   r0,#0x12                      ; Anw-01
                ; -128 als 32-Bit signed -> 0xFFFFFF80 (Zweierkomplement)
                mov   r1,#-128                      ; Anw-02
                ; grosse Konstante: Assembler legt sie im Literal Pool ab
                ; CPU führt aus: LDR R2,[PC,#offset]
                ldr   r2,=0x12345678                ; Anw-03

; --- Zugriff auf Variable ---
                ; Adresse von VariableA in R0 laden
                ldr   r0,=VariableA                 ; Anw-04
                ; 16 Bit (Halfword) lesen -> R1 = 0x00001234
                ldrh  r1,[r0]                       ; Anw-05
                ; 32 Bit lesen, obwohl VariableA nur 16 Bit ist!
                ; -> R2 enthält VariableA + VariableB = 0x47111234 (LE)
                ldr   r2,[r0]                       ; Anw-06
                ; R2 in VariableC speichern, Offset = VariableC-VariableA = 4
                str   r2,[r0,#VariableC-VariableA]  ; Anw-07

; --- Zugriff auf Felder (Speicherzellen) ---
                ; Anfangsadresse von MeinHalbwortFeld -> R0
                ldr   r0,=MeinHalbwortFeld          ; Anw-08
                ; Element 0 (0x22) -> R1
                ldrh  r1,[r0]                       ; Anw-09
                ; Element 1 (0x3E) ueber Offset +2 -> R2
                ldrh  r2,[r0,#2]                    ; Anw-10
                ; Offset im Register: 10 Bytes = 5 Halbwoerter
                mov   r3,#10                        ; Anw-11
                ; Element 5 (0x45) ueber Register-Offset -> R4
                ldrh  r4,[r0,r3]                    ; Anw-12

                ; Pre-indexed Writeback: erst R0+=2, dann lesen
                ; -> R0 = Anf+2, R5 = 0x003E (Element 1)
                ldrh  r5,[r0,#2]!                   ; Anw-13
                ; -> R0 = Anf+4, R6 = 0xFFCC (Element 2 = -52)
                ldrh  r6,[r0,#2]!                   ; Anw-14
                ; -> R0 = Anf+6, schreibt R6 nach Anf+6 (Element 3)
                ; Originalwert 78 wird zu 0xFFCC ueberschrieben
                strh  r6,[r0,#2]!                   ; Anw-15

; --- Addition und Subtraktion (signed / unsigned) ---
                ldr  r0,=MeinWortFeld               ; Anw-16
                ; R1 = 0x12345678 (positiv signed)
                ldr  r1,[r0]                        ; Anw-17
                ; R2 = 0x9DCA5986 (negativ signed, MSB=1)
                ldr  r2,[r0,#4]                     ; Anw-18
                ; ADDS setzt Flags. R3 = 0xAFFEAFFE
                ; signed OK (-1.342.343.682), unsigned OK (2.952.623.614)
                ; Flags: N=1, Z=0, C=0, V=0
                adds r3,r1,r2                       ; Anw-19

                ; R4 = 0xCC000000 (signed: -872.415.232)
                ldr  r4,[r0,#8]                     ; Anw-20
                ; R5 = 0x4E000000 (positiv)
                ldr  r5,[r0,#12]                    ; Anw-21
                ; SUBS R6 = 0x7E000000
                ; signed NICHT OK (Overflow, V=1), unsigned OK (C=1)
                ; Flags: N=0, Z=0, C=1, V=1
                subs r6,r4,r5                       ; Anw-22

                ; R7 = 0x27000000, R8 = 0x45000000
                ldr  r7,[r0,#16]                    ; Anw-23
                ldr  r8,[r0,#20]                    ; Anw-24
                ; SUBS R9 = 0xE2000000
                ; signed OK (-503.316.480), unsigned NICHT OK (Borrow, C=0)
                ; Flags: N=1, Z=0, C=0, V=0
                subs r9,r7,r8                       ; Anw-25

forever         b   forever                         ; Anw-26
                ENDP
                END