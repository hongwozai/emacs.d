;;-------------------------------------------
;;; go package
;;-------------------------------------------
(module-require "cargo")
(require-package 'rust-mode)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(add-hook 'rust-mode-hook #'lsp)

(setq rust-format-on-save t)

(add-hook 'rust-mode-hook (lambda () (prettify-symbols-mode)))