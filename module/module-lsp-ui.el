;;-------------------------------------------
;;; lsp ui
;;-------------------------------------------
(require-package 'lsp-ui)

;; (add-hook 'lsp-mode-hook 'lsp-ui-mode)

(core/leader-set-key
  "il" 'lsp-ui-imenu)


(add-hook 'lsp-ui-mode-hook
          (lambda ()
            (setq lsp-ui-doc-show-with-cursor nil)
            (setq lsp-ui-doc-show-with-mouse nil)
            (setq lsp-ui-sideline-enable nil)
            (setq lsp-ui-sideline-show-code-actions nil)
            (setq lsp-ui-sideline-show-hover nil)
            (setq lsp-ui-sideline-show-code-actions nil)))

