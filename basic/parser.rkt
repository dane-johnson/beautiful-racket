#lang ragg
program : NEWLINE line*
line    : lineno [stmt] (":" stmt)* NEWLINE
lineno  : INTEGER
stmt    : ("print" | "goto") [expr] | "end"
expr    : STRING [";" expr] | INTEGER ["+" expr] | DECIMAL ["+" expr]
