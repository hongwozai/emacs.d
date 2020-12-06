;;-------------------------------------------
;;; slime
;;-------------------------------------------
(require-package 'slime)
(require-package 'slime-company)

(setq inferior-lisp-program "sbcl")

(slime-setup '(slime-fancy slime-company))

(add-hook 'lisp-mode-hook
          (lambda ()
            (enable-paredit-mode)
            (setq-local show-paren-style 'expression)))
