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
              truncate-lines              nil
              show-trailing-whitespace    t)

;; syntax hightlight
(global-font-lock-mode t)

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(setq ispell-dictionary "english")

;;; subword c-subword superword
;; (global-subword-mode)

;; uniquify buffer-name
(require 'uniquify)

;; expand-region
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(require-package 'avy)
(global-set-key (kbd "C-;") 'avy-goto-word-0)

;; pair mode
(show-paren-mode t)

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)

(provide 'init-editing-utils)
