;;; eshell
(add-hook 'eshell-mode
          (lambda () (setq pcomplete-cycle-completions nil
                           eshell-save-history-on-exit nil
                           eshell-buffer-shorthand t)
            (set-face-attribute 'eshell-prompt nil :foreground "red")))

;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)

(provide 'init-shell)
