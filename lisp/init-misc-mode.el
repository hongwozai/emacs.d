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

(provide 'init-misc-mode)
