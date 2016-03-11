;;; yasnippet
(require-package 'yasnippet)
(add-hook 'prog-mode-hook #'yas-minor-mode)

;; (add-hook 'yas--inhibit-overlay-hooks
;;           'yas--on-field-overlay-modification)

;;; configure
(setq yas-snippet-dirs '("~/.emacs.d/snippets"
                         yas-installed-snippets-dir))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))
(provide 'init-template)
