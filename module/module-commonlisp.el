;;-------------------------------------------
;;; slime
;;-------------------------------------------
(require-package 'slime)
(require-package 'slime-company)

(setq inferior-lisp-program "clisp")
(add-to-list 'slime-contribs 'slime-fancy)
