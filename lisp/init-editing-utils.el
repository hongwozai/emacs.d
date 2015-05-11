;; basic information
(setq user-full-name "luzeya")
(setq user-mail-address "hongwozai@163.com")
(setq default-directory "~/")

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default default-tab-width           4
              indent-tabs-mode            nil
              column-number-mode          t
              scorll-margin               3
              make-backup-files           nil
              auto-save-mode              nil
              x-select-enable-clipboard   t
              mouse-yank-at-point         t
              grep-hightlight-matches     t
              grep-scroll-output          t
              show-trailing-whitespace    t)

;; syntax hightlight
(global-font-lock-mode t)

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(setq ispell-dictionary "english")

;; uniquify buffer-name
(require 'uniquify)

;; expand-region
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; ace-jump
(require-package 'ace-jump-mode)
(global-set-key (kbd "C-;") 'ace-jump-word-mode)

;; pair mode
(show-paren-mode t)

;; eldoc-mode
;; (add-to-list 'lisp-interaction-mode-hook 'eldoc-mode)
;; (add-to-list 'emacs-lisp-mode-hook 'eldoc-mode)

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)

(provide 'init-editing-utils)
