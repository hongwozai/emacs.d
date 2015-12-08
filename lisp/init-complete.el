;; hippie expand
(global-set-key (kbd "M-/") 'hippie-expand)
(setq hippid-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))

;; company
(require-package 'company)
(require-package 'company-c-headers)
(require-package 'slime-company)

(add-hook 'after-init-hook #'global-company-mode)

(eval-after-load 'company
  '(progn
     (push 'company-cmake company-backends)
     (push 'company-c-headers company-backends)
     ;; can't work with TRAMP
     (setq company-backends (delete 'company-ropemacs company-backends))
     (setq company-idle-delay    0.2)
     (setq company-minimum-prefix-length 2)
     (setq company-tooltip-flip-when-above t)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-clang-insert-arguments nil)
     (setq company-global-modes
           '(not eshell-mode comint-mode gud-mode))
))

(provide 'init-complete)
