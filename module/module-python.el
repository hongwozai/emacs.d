;;-------------------------------------------
;;; lsp package
;;-------------------------------------------
;;; jedi python-language-server[all] rope pyflakes etc.
(require-package 'lsp-python)

(autoload 'lsp-python-enable "lsp-python")
(add-hook 'python-mode-hook
          (lambda () (ignore-errors (lsp-python-enable))))
