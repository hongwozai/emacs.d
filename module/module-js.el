;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'js2-mode)
(require-package 'json-mode)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq js2-use-font-lock-faces  t
      js2-idle-timer-delay     0.1
      js2-indent-on-enter-key  t
      js2-auto-indent-p        t)

;;-------------------------------------------
;;; xref
;;-------------------------------------------
(require-package 'xref-js2)
(add-hook 'js2-mode-hook
          (lambda ()
            (setq-local xref-backend-functions 'xref-js2-xref-backend)))
