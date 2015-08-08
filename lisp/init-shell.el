;;; eshell
(add-hook 'eshell-mode
          (lambda () (setq pcomplete-cycle-completions nil
                           eshell-save-history-on-exit nil
                           eshell-buffer-shorthand t)))
;;; term
(add-hook 'term-mode-hook 'hong/exit)

;;; shell
(setq shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)

;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)

(provide 'init-shell)
