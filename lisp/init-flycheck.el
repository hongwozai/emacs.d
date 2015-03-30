;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq flycheck-emacs-lisp-load-path 'inherit)
;; (setq flycheck-clang-include-path "")

(provide 'init-flycheck)
