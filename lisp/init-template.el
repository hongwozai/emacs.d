;;; yasnippet
(setq yas-verbosity 0)
(yas-global-mode 1)

;;; configure
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))
(provide 'init-template)
