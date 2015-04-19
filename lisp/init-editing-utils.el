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

;; pair mode
(show-paren-mode t)

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)

(provide 'init-editing-utils)
