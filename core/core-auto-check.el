;;-------------------------------------------
;;; flycheck
;;-------------------------------------------
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(with-eval-after-load 'flycheck
    (setq flycheck-idle-change-delay 1))

(provide 'core-auto-check)
