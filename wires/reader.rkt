#lang br/quicklang

(require "parser.rkt")
(define (read-syntax path port)
  (define parse-tree (parse path (wires-tokenizer port)))
  (datum->syntax #f `(module wires-mod "expander.rkt" ,parse-tree)))
(provide read-syntax)

(require brag/support)
(require br-parser-tools/lex-sre)
(define-tokens a (BINOP WIRE MONOP CONSTANT))
(define (wires-tokenizer port)
  (define (next-token)
    (define wires-lexer
      (lexer
       [whitespace (next-token)]
       [(union "AND" "OR" "RSHIFT" "LSHIFT") (token-BINOP lexeme)]
       [(union "NOT") (token-MONOP lexeme)]
       ["->" lexeme]
       [(+ alphabetic) (token-WIRE lexeme)]
       [(+ numeric) (token-CONSTANT (string->number lexeme))]))
    (wires-lexer port))
  next-token)
