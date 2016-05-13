;;; configure
(setq yas-verbosity 0)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))

;;; yasnippet
(yas-global-mode 1)

(provide 'init-template)
