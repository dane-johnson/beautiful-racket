#lang racket

(require json)

(define-syntax-rule (jsonic-module-begin parse-tree)
  (#%module-begin
   (define result-string parse-tree)
   (define validated-jsexpr (string->jsexpr result-string))
   (display result-string)))
(provide (rename-out [jsonic-module-begin #%module-begin])
         (except-out (all-from-out racket) #%module-begin))

(define-syntax-rule (jsonic-program expr ...)
  (string-trim (string-append expr ...)))
(define-syntax-rule (jsonic-char c)
  c)
(define-syntax (jsonic-sexp stx)
  (syntax-case stx ()
    [(_ sexp-string)
     (with-syntax ([sexp (datum->syntax stx (read (open-input-string (syntax->datum #'sexp-string))))])
       #'(jsexpr->string sexp))]))
(provide jsonic-program jsonic-char jsonic-sexp)
