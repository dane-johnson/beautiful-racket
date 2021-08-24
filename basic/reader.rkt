#lang racket

(require "lexer.rkt" "parser.rkt")

(define (read-syntax port path)
  (let ([parse-tree] (parse path (make-tokenizer port path)))
    (strip-bindings
     #`(module basic-mod basic/expander
         #,parse-tree))))

(module+ reader
  (provide read-syntax))
