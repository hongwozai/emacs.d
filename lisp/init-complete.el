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

(add-hook 'after-init-hook #'global-company-mode)

(eval-after-load 'company
  '(progn
     (push 'company-cmake company-backends)
     (push 'company-c-headers company-backends)
     ;; can't work with TRAMP
     (setq company-backends (delete 'company-ropemacs company-backends))
     (setq company-tooltip-flip-when-above t)
     (setq company-tooltip-align-annotations t)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-clang-insert-arguments nil)
     ;; shell-mode -> ivy
     (setq company-global-modes
           '(not gud-mode shell-mode eshell-mode term-mode))
))

(provide 'init-complete)
