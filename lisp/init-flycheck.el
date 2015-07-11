;; ;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-check-syntax-automatically '(save mode-enable))

(setq flycheck-emacs-lisp-load-path 'inherit)

(setq flycheck-clang-include-path
      `("/usr/include"
         "include" "../include"
         "inc" "../inc"))

(provide 'init-flycheck)
