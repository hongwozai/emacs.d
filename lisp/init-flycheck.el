;; ;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers
              '(emacs-lisp-checkdoc javascript-eslint
                javascript-jshint javascript-gjslint))
(setq flycheck-idle-change-delay 1)
(setq flycheck-emacs-lisp-load-path 'inherit)

;;; flycheck pos-tip
(setq flycheck-pos-tip-timeout -1)
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))

(provide 'init-flycheck)
