#lang racket

(require parser-tools/lex)
(require (prefix-in : parser-tools/lex-sre))
(require ragg/support)

(define-lex-abbrev digits (:+ (char-set "0123456789")))

(define basic-lexer
  (lexer-src-pos
   ["\n" (token 'NEWLINE lexeme)]
   [whitespace (token lexeme #:skip? #t)]
   [(:: "rem" (:* (:~ "\n"))) (token 'REM #:skip? lexeme)]
   [(:or "print" "goto" "end" "+" ":" ";") lexeme]
   [(:or (:: (:? digits) "." digits)
         (:: digits "."))
    (token 'DECIMAL (string->number lexeme))]
   [digits (token 'INTEGER (string->number lexeme))]
   [(:or (:: "\"" (:* (:~ "\"")) "\"")
         (:: "'" (:* (:~ "'")) "'"))
    (token 'STRING (substring lexeme 1 (sub1 (string-length lexeme))))]
   [(eof) (void)]))

(provide basic-lexer)
