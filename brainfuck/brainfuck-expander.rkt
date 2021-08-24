#lang br/quicklang

(define-macro (bf-module-begin PARSE-TREE)
  #'(#%module-begin
     PARSE-TREE))
(provide (rename-out [bf-module-begin #%module-begin]))

(define-macro (bf-program EXPR ...)
  #'(void EXPR ...))
(provide bf-program)

(define-macro (bf-expr EXPR)
  #'(void EXPR))
(provide bf-expr)

(define-macro (bf-loop "[" EXPR ... "]")
  #'(until (zero? (current-byte))
           EXPR ...))
(provide bf-loop)

(define-macro-cases bf-op
  [(bf-op ">") #'(bf->)]
  [(bf-op "<") #'(bf-<)]
  [(bf-op "+") #'(bf-+)]
  [(bf-op "-") #'(bf--)]
  [(bf-op ".") #'(bf-.)]
  [(bf-op ",") #'(bf-comma)])
(provide bf-op)

(define arr (make-vector 30000 0))
(define ptr 0)

(define (current-byte)
  (vector-ref arr ptr))
(define (set-current-byte! val)
  (vector-set! arr ptr val))

(define (bf->)
  (set! ptr (add1 ptr)))
(define (bf-<)
  (set! ptr (sub1 ptr)))
(define (bf-+)
  (set-current-byte! (add1 (current-byte))))
(define (bf--)
  (set-current-byte! (sub1 (current-byte))))
(define (bf-.)
  (write-byte (current-byte)))
(define (bf-comma)
  (set-current-byte! (read-byte)))

