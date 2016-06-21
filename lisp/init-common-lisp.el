(require-package 'slime)
(require-package 'slime-company)

(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-fancy slime-company))

(add-hook 'lisp-mode-hook
          (lambda ()
            ;; C-c C-d h clhs
            (when (file-exists-p "~/quicklisp/clhs-use-local.el")
              (load "~/quicklisp/clhs-use-local.el" t))))

(provide 'init-common-lisp)