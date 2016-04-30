(require-package 'slime)
(require-package 'slime-company)

(setq inferior-lisp-program "sbcl")
(add-hook 'lisp-mode-hook
          (lambda ()
            ;; C-c C-d h clhs
            (when (file-exists-p "~/quicklisp/clhs-use-local.el")
              (load "~/quicklisp/clhs-use-local.el" t))))
(slime-setup '(slime-fancy slime-company))

(provide 'init-common-lisp)