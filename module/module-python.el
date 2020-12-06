;;-------------------------------------------
;;; lsp package
;;-------------------------------------------
;;; jedi python-language-server[all] rope pyflakes etc.
(add-hook 'python-mode-hook #'lsp)

(setq python-shell-interpreter "python3")
