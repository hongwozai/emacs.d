;; hippie expand
(setq hippid-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-complete-lisp-symbol
        try-complete-lisp-symbol-partially
        try-expand-dabbrev-from-kill))

;; yasnippet
(require-package 'yasnippet)
(yas-global-mode)
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-dropdown-prompt
                             yas-completing-prompt))

;; company
(require-package 'company)
(require-package 'company-c-headers)
(add-hook 'after-init-hook 'global-company-mode)

(setq company-require-match nil)
(setq company-auto-complete nil)
(setq company-idle-delay    0.2)
(setq company-minimum-prefix-length 4)
(setq company-dabbrev-ignore-case t)
(setq company-dabbrev-downcase nil)
(setq company-begin-commands '(self-insert-command))
(setq company-show-numbers t)

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-cmake)
     ;; (add-to-list 'company-backends 'company)
     (setq company-clang-insert-arguments nil)))

;; (add-to-list 'company-c-headers-path-system "/usr/include/c++/4.8")

(provide 'init-complete)
