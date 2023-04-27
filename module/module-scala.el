;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'scala-mode)
(require-package 'sbt-mode)
(require-package 'lsp-metals)

(setq sbt:program-name "sbt")

(setq lsp-metals-server-args '("-J-Dmetals.allow-multiline-string-formatting=off"))

(add-hook 'scala-mode-hook
          (lambda ()
            (lsp)))
