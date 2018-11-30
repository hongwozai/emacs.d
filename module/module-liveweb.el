;;-------------------------------------------
;;; live use
;;-------------------------------------------
(module-require-manual)
(require-package 'simple-httpd)
(require-package 'skewer-mode)
(require-package 'impatient-mode)

(setq httpd-root "~/www/")
(setq httpd-port 8080)
(setq httpd-host "0.0.0.0")

(skewer-setup)
