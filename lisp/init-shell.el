;;; set path
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;;; eshell
(add-hook 'eshell-mode-hook
          (lambda ()
            (define-key eshell-mode-map (kbd "C-p")
              'eshell-previous-matching-input-from-input)
            (define-key eshell-mode-map (kbd "C-n")
              'eshell-next-matching-input-from-input)
            (setq pcomplete-cycle-completions nil
                  eshell-save-history-on-exit nil
                  eshell-buffer-shorthand t)))

;;; term
(require-package 'multi-term)
(setq multi-term-program "/bin/bash")
;;; term-mode-hook term-raw-map !!! must be term-raw-map
(add-hook 'term-mode-hook
          (lambda ()
            (setq-local show-trailing-whitespace nil)
            (define-key term-raw-map (kbd "C-y") 'term-paste)
            (define-key term-raw-map (kbd "M-x") 'execute-extended-command)
            (define-key term-raw-map (kbd "C-p") 'term-send-up)
            (define-key term-raw-map (kbd "C-n") 'term-send-down)
            (define-key term-raw-map (kbd "M-DEL") 'term-send-raw-meta)
            (define-key term-raw-map (kbd "TAB") 'term-send-raw-meta)))

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
