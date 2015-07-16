;; ;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-check-syntax-automatically '(save mode-enable))

(setq flycheck-emacs-lisp-load-path 'inherit)

;; color
(eval-after-load 'flycheck
  '(progn (custom-set-faces
           '(flycheck-error ((((class color)) (:background "#FF6E64" :underline nil))))
           '(flycheck-warning ((((class color)) (:breakline "Orange")))))))

(setq flycheck-clang-include-path
      '("/usr/include"
        "include" "../include"
        "inc" "../inc"))

(provide 'init-flycheck)
