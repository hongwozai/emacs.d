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
;;; zsh bash not set TERM=xterm-256color, otherwise not display normally
(setq multi-term-program
      (or (executable-find "/bin/zsh") "/bin/bash"))
;;; term-mode-hook term-raw-map !!! must be term-raw-map
(global-set-key (kbd "M-[") 'multi-term-prev)
(global-set-key (kbd "M-]") 'multi-term-next)
(add-hook 'term-mode-hook
          (lambda ()
            (setq multi-term-dedicated-select-after-open-p t)
            (setq-local show-trailing-whitespace nil)
            (define-key term-raw-map (kbd "C-r") 'term-send-reverse-search-history)
            (define-key term-raw-map (kbd "C-y") 'term-paste)
            (define-key term-raw-map (kbd "M-x") 'execute-extended-command)
            (define-key term-raw-map (kbd "C-p") 'term-send-up)
            (define-key term-raw-map (kbd "C-n") 'term-send-down)
            (define-key term-raw-map (kbd "M-DEL") 'term-send-backward-kill-word)
            (define-key term-raw-map (kbd "M-d") 'term-send-forward-kill-word)
            (define-key term-raw-map (kbd "M-c") 'term-send-raw-meta)
            (define-key term-raw-map (kbd "TAB")
              '(lambda ()
                 (interactive)
                 (term-send-raw-string "\t")))
            ))

;;; shell
(setq shell-file-name "/bin/bash")
(add-hook 'shell-mode-hook 'hong/exit)
(add-hook 'shell-mode-hook
          (lambda ()
            (define-key shell-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key shell-mode-map (kbd "C-n") 'comint-next-input)))

;;; comint mode
(add-hook 'comint-mode-hook
          (lambda ()
            (define-key comint-mode-map (kbd "C-p") 'comint-previous-input)
            (define-key comint-mode-map (kbd "C-n") 'comint-next-input)))

;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)
(defalias 'sh 'shell)
(defalias 'mt 'multi-term)

(provide 'init-shell)
