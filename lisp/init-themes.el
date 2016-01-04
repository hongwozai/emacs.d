;; color theme
(require-package 'spacemacs-theme)
(require-package 'highlight-numbers)

(setq spacemacs-theme-comment-bg nil)

;;; only graphic color
(flet ((display-graphic-p (&optional what) t))
  (load-theme 'spacemacs-dark t))

(add-hook 'prog-mode-hook 'highlight-numbers-mode)

(provide 'init-themes)
