#lang racket

(require parser-tools/lex)
(require ragg/support)
(require (prefix-in : parser-tools/lex-sre))

(define (make-tokenizer port)
  (port-count-lines! port)
  (letrec ([next-token
            (lambda ()
              ((lexer-src-pos
                [(:: "//" any-string "\n") (next-token)]
                [(:: "@$" any-string "$@")
                 (token 'SEXP-TOK (substring lexeme 2 (- (string-length lexeme) 2)))]
                [any-char (token 'CHAR-TOK lexeme)]
                [(eof) (void)])
               port))])
    next-token))
(provide make-tokenizer)
