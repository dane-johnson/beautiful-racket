#lang racket

(require "tokenizer.rkt" "parser.rkt")

(define (read-syntax path port)
  (let* ([parse-tree (parse path (make-tokenizer port))]
         [module-datum `(module jsonic-module jsonic/expander
                          ,parse-tree)])
    (datum->syntax #f module-datum)))
(provide read-syntax)
