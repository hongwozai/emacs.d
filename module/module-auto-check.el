;;-------------------------------------------
;;; flycheck
;;-------------------------------------------
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(with-eval-after-load 'flycheck
    (setq flycheck-idle-change-delay 1))

;;-------------------------------------------
;;; emacs lisp
;;-------------------------------------------
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq flycheck-emacs-lisp-load-path 'inherit)
            (add-to-list 'flycheck-disabled-checkers
                         'emacs-lisp-checkdoc)))

(provide 'module-auto-check)
