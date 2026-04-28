# Aufgabe 2 

## Effekt der Befehle Anw01-06 (Byte-Swap)

VariableA enthält 0xBEEF. Da ARM in little-endian arbeitet, liegt im Speicher:
- Adresse N   : EF
- Adresse N+1 : BE

Damit im Memory Browser "BE EF" lesbar wird, müssen die beiden Bytes vertauscht werden.

- **Anw01** `ldr R0, =VariableA` : R0 = Adresse von VariableA
- **Anw02** `ldrb R2, [R0]` : R2 = 0x000000EF (low byte aus Speicher)
- **Anw03** `ldrb R3, [R0,#1]` : R3 = 0x000000BE (high byte aus Speicher)
- **Anw04** `lsl R2, #8` : R2 = 0x0000EF00 (low byte nach oben geschoben)
- **Anw05** `orr R2, R3` : R2 = 0x0000EFBE (R2 mit high byte odern)
- **Anw06** `strh R2, [R0]` : Memory ab VariableA neu: BE EF (statt EFBE)

## Erweiterung Anw07 - Anw08 (affe nach VariableC)

Neue Variable `VariableC` (DCW 0x0000) angelegt.

- low byte (0xFE) und high byte (0xAF) aus R5 herausziehen (and / lsr)
- low byte nach oben schieben, high byte odern
- Ergebnis 0xFEAF nach VariableC umschreiben
- Memory zeigt: AFFE

## Änderung Anw09 - Anw0E (Memory soll "12 34" zeigen)

Da der Speicher little-endian ist, muss in VariableB der Wert 0x3412 stehen, 
damit im Memory Browser "12 34" erscheint. 
Ansatz: direkt 0x3412 mit MOV laden und mit STRH schreiben, 
die vorherige ADD-Konstruktion ist nicht nötgi.

## Problem
 Wie bereits bei A1.
