;;; set path
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;;; eshell
(add-hook 'eshell-mode-hook
          (lambda () (setq pcomplete-cycle-completions nil
                       eshell-save-history-on-exit nil
                       eshell-buffer-shorthand t)))

;;; term
(require-package 'multi-term)
(setq multi-term-program "/bin/bash")
(add-hook 'term-mode-hook
          (lambda ()
            (define-key term-mode-hook (kbd "C-p") 'term-send-up)
            (define-key term-mode-hook (kbd "C-n") 'term-send-down)
            (define-key term-mode-hook (kbd "M-DEL") 'term-send-backward-kill-word)))

;;; shell
(setq shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)
(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key shell-mode-map (kbd "C-n") 'comint-next-input)))

;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)
(defalias 'sh 'shell)
(defalias 'mt 'multi-term)

(provide 'init-shell)
