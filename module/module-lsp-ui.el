;;-------------------------------------------
;;; lsp ui
;;-------------------------------------------
(require-package 'lsp-ui)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(core/leader-set-key
  "il" 'lsp-ui-imenu)