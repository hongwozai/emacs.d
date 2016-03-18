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
     (setq company-ispell-dictionary
           (file-truename "~/.emacs.d/english-words.txt"))
))

(defun hong/toggle-company-ispell ()
  (interactive)
  (cond ((memq 'company-ispell company-backends)
         (setq company-backends (delete 'company-ispell company-backends))
         (message "Company ispell disabled."))
        (t (add-to-list 'company-backends 'company-ispell)
           (message "Company ispell enabled."))))

(provide 'init-complete)
