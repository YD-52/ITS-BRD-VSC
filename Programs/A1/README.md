# Aufgabe 1

## Was macht das Programm?
Es schaltet schrittweise mehrere LEDs an und wieder aus. 
Endzustand: nur D08 und D09 leuchten.

## Fehler in den Originalkommentaren
- `MOV R2, #0x40` -> Kommentar: `0b0100`, richtig: `0b01000000` (Bit 6 = D14)

- `MOV R3, #0x80` -> Kommentar: `0b1000`, richtig: `0b10000000` (Bit 7 = D15)

## Optimierung
Statt 8 STRB-Befehlen reicht einer:
`STRB R0, [R6]` mit `0x03` setzt D08 + D09 in einem Schritt.

## Problem
Beim `git clone --recursive` sind die Submodule (DisplayWaveshare, 
ITS_BRD_LIB, ITS_Keil_prj_base, stm32cubef4) nicht erreichbar 
(github.com/ITS-BRD/* not found). Das Projekt konnte daher nicht gebaut werden. Code wurde inhaltlich durchgearbeitet.