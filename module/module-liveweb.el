;;-------------------------------------------
;;; live use
;;-------------------------------------------
(require-package 'simple-httpd)
(require-package 'skewer-mode)

(setq httpd-root "~/www/")
(setq httpd-host "0.0.0.0")

(skewer-setup)

;;-------------------------------------------
;;; modify
;;-------------------------------------------
(add-hook 'skewer-repl-mode-hook
          (lambda ()
            (setq-local company-idle-delay nil)
            (local-set-key (kbd "C-M-i") 'company-skewer-repl)))