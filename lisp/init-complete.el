;; hippie expand
(setq hippid-expand-try-functions-list
      '(try-complete-file-name-partially
        try-complete-file-name
        try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill))


;; company
(require-package 'company)
(require-package 'company-c-headers)

(dolist (hook '(prog-mode-hook cmake-mode-hook))
  (add-hook hook 'company-mode))

(setq company-idle-delay    0.1)
(setq company-minimum-prefix-length 3)
(setq company-dabbrev-ignore-case t)
(setq company-dabbrev-downcase nil)
(setq company-show-numbers t)

(eval-after-load 'company
  '(progn
     (add-to-list 'company-backends 'company-cmake)
     (add-to-list 'company-backends 'company-c-headers)
     ;; (setq company-clang-insert-arguments nil)
     ))
(eval-after-load 'company-c-headers
  '(progn
     (setq company-c-headers-path-system
           (append company-c-headers-path-system
                   (hong/gtk-include-path)))))
(provide 'init-complete)
