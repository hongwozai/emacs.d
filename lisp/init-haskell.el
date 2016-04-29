;;; haskell language
(require-package 'haskell-mode)

(setq haskell-font-lock-symbols t)
(add-hook 'haskell-mode-hook
          (lambda ()
            (setq haskell-tags-on-save t)
            (haskell-doc-mode)
            (interactive-haskell-mode)
            (turn-on-haskell-indent)))

(provide 'init-haskell)