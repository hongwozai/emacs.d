;; ;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-idle-change-delay 1)
(setq flycheck-emacs-lisp-load-path 'inherit)

;;; flycheck pos-tip
(eval-after-load 'flycheck
  '(progn (flycheck-pos-tip-mode)))

(provide 'init-flycheck)
