;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'lsp-java)

(add-hook 'java-mode-hook
          (lambda ()
            (require 'lsp-java)
            (lsp-deferred)))

;;; local install jdt
;; (setq lsp-java-jdt-download-url "file://")