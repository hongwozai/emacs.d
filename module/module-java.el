;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'lsp-java)

;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (require 'lsp-java)
;;             (let ((plugindir (expand-file-name "plugins" lsp-java-server-install-dir)))
;;               (when (file-directory-p plugindir)
;;                 (lsp-deferred)))
;;             ))

(add-hook 'java-mode-hook
          (lambda ()
            (lsp)))

;;; local install jdt
;; (setq lsp-java-jdt-download-url "file://")