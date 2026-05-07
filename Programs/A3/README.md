# Aufgabe 3 – Erste Betrachtungen der ARM ISA

## Inhalt der Aufgabe
- Konstanten in Register laden (kleine direkt, grosse via Literal Pool)
- Variablen im Speicher adressieren
- Felder durchlaufen (Offset, Register-Offset, Pre-indexed Writeback)
- Addition und Subtraktion mit Auswertung der Statusflags (signed/unsigned)

## Wichtige Beobachtungen

### Anw-03: grosse Konstante
0x12345678 passt nicht in ein Maschinenwort. Der Assembler legt 
den Wert im Literal Pool ab und ersetzt LDR R2,=0x12345678 durch
LDR R2,[PC,#offset]. Sichtbar im Disassembly View.

### Anw-06: kein Typ-Check
LDR (Word) liest 32 Bit, obwohl VariableA nur 16 Bit (DCW) ist. 
Daher landen auch die Bytes von VariableB in R2 (R2 = 0x47111234).
Der Assembler prueft das nicht.

### Anw-13/14/15: Pre-indexed mit Writeback
Das "!" bewirkt, dass R0 nach dem Zugriff um den Offset erhoeht wird. 
So kann man durch ein Feld iterieren, ohne extra ein ADD zu schreiben.

### Anw-15: Schreibender Zugriff
Element 3 (Wert 78) wird mit dem Inhalt von R6 (0xFFCC) ueberschrieben.
Der Originalwert geht verloren.

### Statusflags Anw-19, Anw-22, Anw-25
- Anw-19: ADDS, beide Sichtweisen OK (V=0, C=0). Nur N=1 weil MSB=1.
- Anw-22: SUBS, SIGNED Overflow (V=1) – Ergebnis ausserhalb signed Range.
  Unsigned trotzdem OK (C=1).
- Anw-25: SUBS, UNSIGNED Underflow (C=0) – Minuend kleiner als Subtrahend.
  Signed bleibt OK.

## Eigene Tests / aufgetretene Fragen
- Was, wenn LDRH statt LDR bei Anw-06? : Liest nur 16 Bit, VariableB bleibt gleic.
- Was, wenn "!" bei Anw-13 fehlt? : R0 bleibt stehen, kein Iterieren möglich.
- Wie sieht -52 als Halfword aus? : 0xFFCC (Zweierkomplement: NOT(0x0034)+1).
- Wie sieht -128 als 32-Bit signed aus? : 0xFFFFFF80 (vorzeichenerweitert mit Fs).
- Warum geht MOV mit -128, aber nicht mit 0x12345678? : Kompakte Codierung 
  der Negativzahl möglich, willkuerliche 32-Bit-Werte nicht.
