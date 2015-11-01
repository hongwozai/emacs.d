;;; shell-script-mode
(push '("\\.zsh\\'" . sh-mode) auto-mode-alist)
(push '("\\.sh\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash\\'" . sh-mode) auto-mode-alist)
(push '("\\.bashrc\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_history\\'" . sh-mode) auto-mode-alist)
(push '("\\.bash_profile\\'" . sh-mode) auto-mode-alist)

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
                  eshell-buffer-shorthand t)
            (defalias 'ff #'find-file)))

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
            (setq term-unbind-key-list '("C-x"  "<ESC>"))
            (setq term-bind-key-alist
                  '(("C-r" . term-send-reverse-search-history)
                    ("C-y" . term-paste)
                    ("M-y" . yank-pop)
                    ("C-p" . term-send-up)
                    ("C-n" . term-send-down)
                    ("M-DEL" . term-send-backward-kill-word)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-c" . term-send-raw-meta)
                    ("M-f" . term-send-forward-word)
                    ("M-b" . term-send-backward-word)
                    ("M-x" . execute-extended-command)
                    ("TAB" . (lambda () (interactive) (term-send-raw-string "\t")))))))

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
