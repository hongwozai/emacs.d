;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'lsp-java)

(add-hook 'java-mode-hook
          (lambda ()
            (require 'lsp-java)
            (lsp-deferred)))