;;-------------------------------------------
;;; live use
;;-------------------------------------------
(module-require-manual)
(require-package 'simple-httpd)
(require-package 'skewer-mode)

(setq httpd-root "~/www/")
(setq httpd-host "0.0.0.0")

(skewer-setup)
