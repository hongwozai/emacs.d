(require-package 'slime)
(require-package 'slime-company)

(setq inferior-lisp-program "sbcl")
(slime-setup '(slime-fancy slime-company))

(add-hook 'lisp-mode-hook
          (lambda ()
            ;; C-c C-d h clhs
            (when (file-exists-p "~/quicklisp/clhs-use-local.el")
              (load "~/quicklisp/clhs-use-local.el" t))))

;;; key
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)

(provide 'init-common-lisp)