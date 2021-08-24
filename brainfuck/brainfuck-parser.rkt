#lang brag

bf-program : bf-expr*
bf-expr    : bf-op | bf-loop
bf-op      : ">" | "<" | "+" | "-" | "." | ","
bf-loop    : "[" bf-expr* "]"
