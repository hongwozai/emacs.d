;; hippie expand
(setq hippid-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-complete-lisp-symbol
        try-complete-lisp-symbol-partially
        try-expand-dabbrev-from-kill))

;; company
(require-package 'company)
(require-package 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-require-match nil)
(setq company-auto-complete nil)
(setq company-idle-delay    0.2)
(setq company-minimum-prefix-length 3)
(setq company-dabbrev-ignore-case t)
(setq company-dabbrev-downcase nil)
(setq company-show-numbers t)

(add-hook 'company-mode-hook
          '(lambda ()
             (define-key company-active-map (kbd "C-g") 'company-abort)))

(add-hook 'company-mode-hook
          '(lambda ()
             (add-to-list 'company-backends 'company-c-headers)))
;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8")

(provide 'init-complete)
