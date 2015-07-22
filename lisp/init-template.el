;;; yasnippet
(require-package 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"
                         yas-installed-snippets-dir))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))
(provide 'init-template)
