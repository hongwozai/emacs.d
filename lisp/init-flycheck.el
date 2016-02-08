;; ;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
;; (setq flycheck-check-syntax-automatically '(save mode-enable))
(setq flycheck-idle-change-delay 1)

(setq flycheck-emacs-lisp-load-path 'inherit)

;;; flycheck errors
(hong/select-buffer-window flycheck-list-errors "*Flycheck errors*")

(provide 'init-flycheck)
