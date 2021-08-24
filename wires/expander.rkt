#lang racket

(define-syntax-rule (wires-module-begin PARSE-TREE)
  (#%module-begin PARSE-TREE))
(provide (rename-out [wires-module-begin #%module-begin])
         #%top #%app #%datum)


(define-syntax-rule (program expr ...)
  (begin expr ...))
(require (for-syntax racket/syntax))
(define-syntax (expr stx)
  (syntax-case stx ()
    [(_ signal "->" wire)
     (with-syntax ([wiresym (datum->syntax #'wire (string->symbol (syntax->datum #'wire)))])
       #'(begin
           (define (wiresym) signal) (provide wiresym)))]))
(provide provide define)
(define-syntax (signal stx)
  (syntax-case stx ()
    [(_ e) #'e]
    [(_ "NOT" e) #'(bitwise-not-16 e)]
    [(_ e1 "AND" e2) #'(bitwise-and-16 e1 e2)]
    [(_ e1 "OR" e2) #'(bitwise-ior-16 e1 e2)]
    [(_ e1 "LSHIFT" e2) #'(arithmetic-shift-16 e1 e2)]
    [(_ e1 "RSHIFT" e2) #'(arithmetic-shift-16 e1 (- e2))]))
(define-syntax (define-16 stx)
  (let* ([funname (symbol->string (cadr (syntax->datum stx)))]
         [funname-16 (string->symbol (string-append funname "-16"))])
    (datum->syntax
     stx
     `(define (,funname-16 . args)
        (modulo (apply ,(string->symbol funname) args) 16)))))
(define-16 bitwise-not)
(define-16 bitwise-and)
(define-16 bitwise-ior)
(define-16 arithmetic-shift)
(provide bitwise-not-16 bitwise-ior-16 bitwise-and-16 arithmetic-shift-16)
(define-syntax (val stx)
  (syntax-case stx ()
    [(_ v)
     (if (string? (syntax->datum #'v))
         #`(#,(datum->syntax stx (string->symbol (syntax->datum #'v))))
         #'v)]))
(provide program expr signal val)
