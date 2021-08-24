#lang racket

(define-syntax-rule (basic-module-begin _ "\n" exprs ...)
  (#%module-begin exprs ... (run-program)))

(provide (rename-out [basic-module-begin #%module-begin])
         #%app #%datum #%top)

(define lines (make-hash))

(define-syntax-rule (define-line (line-num) expr ...)
  (hash-set! lines line-num (λ () expr ...)))

(require racket/fixnum)
(define (call-line lineno)
  ((hash-ref lines (if (fixnum? lineno) lineno (fl->fx lineno))))
  (let ([next (next-line lineno)])
    (if next (call-line next)
        (void))))

(define (next-line lineno)
  (apply min (filter (λ (x) (> x lineno)) (hash-keys lines))))

(define-for-syntax (drop-colons l)
  (if (null? l)
      '()
      (cons (cadr l) (drop-colons (cddr l)))))

(define-syntax (line stx)
  (syntax-case stx (lineno)
    [(_ (lineno line-num) "\n")
     #'(define-line (line-num) (void))]
    [(_ (lineno line-num) stmt colon-stmts ... "\n")
     (with-syntax ([(stmts ...)
                    (datum->syntax
                     stx
                     (drop-colons (syntax->datum #'(colon-stmts ...))))])
       #'(define-line (line-num) stmt stmts ...))]))

(define-syntax (stmt stx)
  (syntax-case stx ()
    [(_ "end") #'(exit)]
    [(_ "goto" expr) #'(call-line expr)]
    [(_ "print") #'(displayln "")]
    [(_ "print" expr) #'(displayln expr)]))

(define-syntax (expr stx)
  (syntax-case stx ()
    [(_ v) #'v]
    [(_ v0 "+" v1) #'(+ v0 v1)]
    [(_ v0 ";" v1) #'(string-append v0 v1)]))

(define (run-program)
  (let ([first-line (apply min (hash-keys lines))])
    (call-line first-line)))

(provide define-line call-line lines line stmt expr run-program)
