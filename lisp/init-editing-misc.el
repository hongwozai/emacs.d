;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(setq avy-background t)
(setq avy-all-windows nil)

;;; auto highlight symbol
(global-auto-highlight-symbol-mode)

;;; key hint
(add-hook 'after-init-hook #'which-key-mode)

;;; ag
(when (executable-find "ag")
  (require-package 'ag)
  (require-package 'wgrep-ag)
  (setq-default ag-highlight-search t)
  (setq-default ag-reuse-buffers t)
  (setq-default ag-reuse-window nil)

  (hong/select-buffer-window ag "*ag search*")
  )

(provide 'init-editing-misc)