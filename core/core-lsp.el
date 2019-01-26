;;-------------------------------------------
;;; lsp package
;;-------------------------------------------
(require 'lsp-mode)

;;-------------------------------------------
;;; imenu
;;-------------------------------------------
(autoload 'lsp-enable-imenu "lsp-imenu" nil t)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq lsp-message-project-root-warning t)

;;; hook
(add-hook 'lsp-after-open-hook #'lsp-enable-imenu)

;;; drop lsp-hover
;; (setq lsp-eldoc-hook '(lsp-document-highlight lsp-hover))
(provide 'core-lsp)