;;; go language
(when (executable-find "go")
  (require-package 'go-mode)
  (require-package 'go-eldoc)
  (add-hook 'go-mode-hook 'go-eldoc-setup))

;;; haskell language
(when (executable-find "ghc")
  (require-package 'haskell-mode))

;;; antlr
(autoload 'antlr-mode "antlr-mode" nil t)
(autoload 'antlr-v4-mode "antlr-mode" nil t)
(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

;;; markdown-mode
(require-package 'markdown-mode)
(setq auto-mode-alist
      (append '(("\\.md\\'" . markdown-mode))
              '(("README\\'" . markdown-mode))
              '(("README\\.txt\\'" . markdown-mode))
              auto-mode-alist))

;; cmake
(when (executable-find "cmake")
  (require-package 'cmake-mode)
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

(provide 'init-misc)
