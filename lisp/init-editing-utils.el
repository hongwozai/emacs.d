;; basic information
(setq user-full-name "luzeya")
(setq user-mail-address "hongwozai@163.com")
(setq default-directory "~/")

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default default-tab-width           4
              indent-tabs-mode            nil
              column-number-mode          t
              scroll-preserve-screen-position 'always
              make-backup-files           nil
              auto-save-mode              nil
              x-select-enable-clipboard   t
              mouse-yank-at-point         t
              truncate-lines              nil
              scroll-margin               0
              scroll-step                 1
              visible-bell                t
              mode-require-final-newline  nil
              split-width-threshold       81
              ring-bell-function          'ignore)

;;; trailing whitespace
(add-hook 'prog-mode-hook (lambda () (setq-local show-trailing-whitespace t)))

;; Auto refresh buffers, dired revert have bugs.
;;; remote file revert have bugs.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            nil
      auto-revert-verbose                 nil)

;;; cursor
(blink-cursor-mode 0)

;; syntax hightlight
(global-font-lock-mode t)

;;; highlight current line
(add-hook 'prog-mode-hook #'hl-line-mode)

;;; recentf
(setq recentf-auto-cleanup 'never)
(require 'recentf)
(setq recentf-max-saved-items 100)
(setq recentf-exclude '(".*\\.png$" ".*\\.gz$" ".*\\.jpg$"
                        "GTAGS" "TAGS" "tags"))
(add-hook 'after-init-hook (lambda () (recentf-mode 1)))

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(when (executable-find "aspell")
  (setq-default ispell-program-name "aspell"))
(setq ispell-dictionary "english")

;; uniquify buffer-name
(require 'uniquify)

;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(setq avy-background t)
(setq avy-all-windows nil)

;; show pair
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;;; rainbow-delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; built-in paren dir
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

;;; .dir-locals.el
(setq enable-local-variables :all enable-local-eval t)

;; bookmark
(setq bookmark-save-flag 1)
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

;;; minibuffer
(setq minibuffer-message-timeout 1)

;;; minibuffer map
(define-key minibuffer-local-map (kbd "C-p") 'previous-history-element)
(define-key minibuffer-local-map (kbd "C-n") 'next-history-element)

;;; key hint
(add-hook 'after-init-hook #'which-key-mode)

;;; ediff
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(provide 'init-editing-utils)