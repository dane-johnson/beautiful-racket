#lang brag


program : expr*
expr    : signal "->" WIRE
signal  : val | val BINOP val | MONOP val
val     : WIRE | CONSTANT
