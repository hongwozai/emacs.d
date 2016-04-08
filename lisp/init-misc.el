;;; go language
(when (executable-find "go")
  (require-package 'go-mode)
  (require-package 'go-eldoc)
  (add-hook 'go-mode-hook 'go-eldoc-setup))

;;; haskell language
(when (executable-find "ghc")
  (require-package 'haskell-mode)
  (setq haskell-font-lock-symbols t)
  (add-hook 'haskell-mode-hook
            (lambda ()
              (setq haskell-tags-on-save t)
              (haskell-doc-mode)
              (interactive-haskell-mode)
              (turn-on-haskell-indent))))

;;; antlr
(autoload 'antlr-mode "antlr-mode" nil t)
(autoload 'antlr-v4-mode "antlr-mode" nil t)
(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

;;; markdown-mode
(require-package 'markdown-mode)
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
(require-package 'guide-key)
(guide-key-mode 1)

(setq guide-key/idle-delay 0.3)
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/popup-window-position 'bottom)

(setq guide-key/guide-key-sequence
      '("C-x 4" "C-x r" "C-x RET" ",g" ",m" ",c"
        (dired-mode "*")
        (ibuffer-mode "%" "*" "/" "s")
        (sh-mode "C-c")))

(provide 'init-misc)
