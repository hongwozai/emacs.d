;;; eshell
(add-hook 'eshell-mode
          (lambda () (setq pcomplete-cycle-completions nil
                       eshell-save-history-on-exit nil
                       eshell-buffer-shorthand t)))
;;;
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)
;;; term
(require-package 'multi-term)

;;; shell
(setq shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)

;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)

(provide 'init-shell)
