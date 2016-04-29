;;; go language
(require-package 'go-mode)
(require-package 'go-eldoc)

(add-hook 'go-mode-hook 'go-eldoc-setup)

(provide 'init-go)