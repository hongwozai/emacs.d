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

(dolist (hook '(prog-mode-hook inferior-python-mode-hook inf-ruby-mode-hook
                               cmake-mode-hook web-mode-hook))
  (add-hook hook 'company-mode))

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-cmake)
     (add-to-list 'company-backends 'company-c-headers)
     ;; can't work with TRAMP
     (setq company-backends (delete 'company-ropemacs company-backends))
     (setq company-require-match nil)
     ;; press SPACE will accept the highlighted candidate and insert a space
     (setq company-auto-complete nil)
     (setq company-idle-delay    0.3)
     (setq company-dabbrev-downcase    nil)
     (setq company-dabbrev-ignore-case nil)
     (setq company-show-numbers t)
     (setq company-begin-commands '(self-insert-command))
     (setq company-clang-insert-arguments nil)))

(provide 'init-complete)
