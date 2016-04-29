;;; sql
(eval-after-load "sql"
  '(load-library "sql-indent"))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (hong/exit)
            (toggle-truncate-lines t)))

;;; antlr
(autoload 'antlr-mode "antlr-mode" nil t)
(autoload 'antlr-v4-mode "antlr-mode" nil t)
(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

;;; markdown-mode
(setq auto-mode-alist
      (append '(("\\.md\\'" . markdown-mode))
              '(("README\\'" . markdown-mode))
              '(("readme\\'" . markdown-mode))
              '(("readme\\.txt\\'" . markdown-mode))
              '(("README\\.txt\\'" . markdown-mode))
              auto-mode-alist))

;; cmake
(when (executable-find "cmake")
  (require-package 'cmake-mode)
  (require-package 'cpputils-cmake)
  (setq auto-mode-alist
        (append '(("CMakeLists\\.txt\\'" . cmake-mode))
                '(("\\.cmake\\'" . cmake-mode))
                auto-mode-alist))
  (add-hook 'cmake-mode-hook (lambda () (push 'company-cmake company-backends))))

;;; graphviz
(when (executable-find "dot")
  (eval-after-load "org"
    '(progn
       (add-to-list 'org-src-lang-modes  '("dot" . graphviz-dot))))
;;; BUG: graphviz org-mode eval-after-load
  (require-package 'graphviz-dot-mode)
  (hong/select-buffer-window graphviz-dot-preview "*preview*")
  (setq graphviz-dot-auto-indent-on-braces t)
  (setq graphviz-dot-toggle-completions t))

;;; guide key
(guide-key-mode 1)
(setq guide-key/idle-delay 0.3)
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/popup-window-position 'bottom)
(setq guide-key/guide-key-sequence
      '("C-x 4" "C-x r" "C-x RET" "C-x v" ",g" ",m" ",c"
        (dired-mode "*")
        (ibuffer-mode "%" "*" "/" "s")
        (markdown-mode "C-c C-c")
        (sh-mode "C-c")))

(provide 'init-misc)
