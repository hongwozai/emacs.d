;;-------------------------------------------
;;; interper
;;-------------------------------------------
(require 'scheme)
(setq scheme-program-name "guile")

(eval-after-load 'scheme
  (font-lock-add-keywords
   'scheme-mode
   '(("(\\(\\(def\\|with\\|do\\)[^ \t\v\n]+\\)\\>" 1 'font-lock-keyword-face)
     ("handler-case" . 'font-lock-keyword-face))))


