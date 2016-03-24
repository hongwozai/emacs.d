;;; yasnippet
(require-package 'yasnippet)
(setq yas-verbosity 0)
(yas-global-mode 1)

;; (add-hook 'yas--inhibit-overlay-hooks
;;           'yas--on-field-overlay-modification)

;;; configure
(setq yas-snippet-dirs '("~/.emacs.d/snippets"
                         yas-installed-snippets-dir))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))
(provide 'init-template)
