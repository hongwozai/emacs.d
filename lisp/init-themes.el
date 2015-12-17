;; color theme
(require-package 'spacemacs-theme)

;;; only graphic color
(flet ((display-graphic-p (&optional what) t))
  (load-theme 'spacemacs-dark t))


(provide 'init-themes)
