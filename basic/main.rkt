#lang racket
(require "tokenizer.rkt" "parser.rkt")

(require syntax/strip-context)
(define (read-syntax path port)
  (let ([parse-tree (parse path (make-tokenizer port))])
    (strip-context
     #`(module basic-mod basic/expander
         #,@parse-tree))))

(module+ reader
  (provide read-syntax))
