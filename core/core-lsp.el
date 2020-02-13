;;-------------------------------------------
;;; lsp package
;;-------------------------------------------
(require-package 'lsp-mode)

;;-------------------------------------------
;;; imenu
;;-------------------------------------------
(autoload 'lsp-enable-imenu "lsp-imenu" nil t)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq lsp-message-project-root-warning t)

;;; imenu not
;; (add-hook 'lsp-after-open-hook #'lsp-enable-imenu)

;;; don't use flymake
(setq lsp-prefer-flymake nil)

;;; drop lsp-hover
;; (setq lsp-eldoc-hook '(lsp-document-highlight lsp-hover))
(provide 'core-lsp)
