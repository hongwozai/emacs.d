;;; sql
(with-eval-after-load "sql"
  (load-library "sql-indent"))

(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (hong/exit)
            (toggle-truncate-lines t)))

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

;;; antlr
(autoload 'antlr-v4-mode "antlr-mode" nil t)
(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

;;; bison-mode
(autoload 'bison-mode "bison-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.y\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.yacc\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.l\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.lex\\'" . bison-mode))
(add-to-list 'auto-mode-alist '("\\.jison\\'" . jison-mode))


;;; graphviz
(when (executable-find "dot")
  (with-eval-after-load "org"
    (add-to-list 'org-src-lang-modes  '("dot" . graphviz-dot)))
;;; BUG: graphviz org-mode eval-after-load
  (require-package 'graphviz-dot-mode)
  (hong/select-buffer-window graphviz-dot-preview "*preview*")
  (setq graphviz-dot-auto-indent-on-braces t)
  (setq graphviz-dot-toggle-completions t))

(provide 'init-misc-mode)
