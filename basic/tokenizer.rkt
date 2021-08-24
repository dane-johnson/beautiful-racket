#lang racket
(require "lexer.rkt")

(require ragg/support)
(define (make-tokenizer port)
  (port-count-lines! port)
  (λ () (basic-lexer port)))
(provide make-tokenizer)
