(require-package 'haskell-mode)
(require-package 'flycheck-haskell)
(require-package 'company-ghc)

;;; company
;; (add-to-list 'company-backends 'company-ghc)
;;; flycheck
(eval-after-load 'flycheck
  '(progn
     (add-hook 'haskell-mode-hook #'flycheck-haskell-setup)))
;;; doc
(dolist (hook '(haskell-mode-hook inferior-haskell-mode-hook
                                  haskell-interactive-mode-hook))
  (add-hook hook 'turn-on-haskell-doc-mode))
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(provide 'init-haskell)
