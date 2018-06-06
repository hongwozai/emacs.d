
;; ispell
(when (executable-find "aspell")
  (setq-default ispell-program-name "aspell"))
(setq ispell-dictionary "english")

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

;; bookmark
(evil-define-key 'motion bookmark-bmenu-mode-map
  (kbd "RET") 'bookmark-bmenu-this-window)

;;; hexl edit
(with-eval-after-load 'hexl
  (evil-define-key 'normal hexl-mode-map
    (kbd "j") 'hexl-next-line
    (kbd "k") 'hexl-previous-line
    (kbd "h") 'hexl-backward-char
    (kbd "l") 'hexl-forward-char
    (kbd "0") 'hexl-beginning-of-line
    (kbd "$") 'hexl-end-of-line
    (kbd "gg") 'hexl-beginning-of-buffer
    (kbd "G") 'hexl-end-of-buffer))

;;; minibuffer map
(define-key minibuffer-local-map (kbd "C-p") 'previous-history-element)
(define-key minibuffer-local-map (kbd "C-n") 'next-history-element)

;; hippie expand
(setq evil-complete-next-func #'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;;; avy
(setq avy-background t)
(setq avy-all-windows nil)

;;; auto highlight symbol
(setq highlight-symbol-idle-delay 1)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(add-hook 'prog-mode-hook 'highlight-symbol-nav-mode)

;;; iedit
(evil-define-minor-mode-key 'normal 'iedit-mode
  (kbd "F") 'iedit-restrict-function
  (kbd "L") 'iedit-restrict-current-line
  (kbd "D") 'iedit-delete-occurrences
  (kbd "S") '(lambda () (interactive)
              (iedit-delete-occurrences)
              (evil-insert-state))
  (kbd "gg") 'iedit-goto-first-occurrence
  (kbd "G")  'iedit-goto-last-occurrence
  (kbd "n") 'iedit-next-occurrence
  (kbd "N") 'iedit-prev-occurrence
  (kbd "C-;") 'iedit-mode)

(evil-define-minor-mode-key 'insert 'iedit-mode
  (kbd "C-;") '(lambda () (interactive) (iedit-mode) (evil-normal-state)))

(with-eval-after-load 'iedit
  (define-key iedit-mode-occurrence-keymap
      (kbd "<tab>") 'iedit-toggle-selection)
  (define-key iedit-mode-occurrence-keymap
      (kbd "TAB")   'iedit-toggle-selection)
  )

(define-key evil-normal-state-map (kbd "C-;") 'iedit-mode)

(provide 'init-editing-utils)
