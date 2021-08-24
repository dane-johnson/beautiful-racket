#lang br/quicklang

(define (read-syntax path port)
  (define src-lines (port->lines port))
  (define src-datums (format-datums '~a src-lines))
  (define module-datum `(module stacker-mod "stacker.rkt" (handle ,@src-datums)))
  (datum->syntax #f module-datum))
(provide read-syntax)

(define-macro (stacker-module-begin HANDLE-ARGS-EXPR)
  #'(#%module-begin
     (display (first HANDLE-ARGS-EXPR))))
(provide (rename-out [stacker-module-begin #%module-begin]))

(define (handle . args)
  (foldl (lambda (e a)
           (cond
            [(number? e) (cons e a)]
            [(or (equal? * e) (equal? + e))
             (cons (e (car a) (cadr a)) (cddr a))]
            [else a]))
         '() args))

(provide handle + *)
