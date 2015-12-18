;; color theme
(require-package 'spacemacs-theme)

(setq spacemacs-theme-comment-bg nil)

;;; only graphic color
(flet ((display-graphic-p (&optional what) t))
  (load-theme 'spacemacs-dark t))


(provide 'init-themes)
