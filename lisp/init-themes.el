;; color theme
(require-package 'solarized-theme)

(defun load-solarized-theme (lod)
  "lod is light or dark"
  (defvar current-theme nil)
  (cond ((eql lod 'dark)
         (load-theme 'solarized-dark t)
         (setf current-theme 'solarized-dark))
        ((eql lod 'light)
         (load-theme 'solarized-light t)
         (setf current-theme 'solarized-light))
        (t (error "solarized theme error!"))))

(defun hong/toggle-solarized-theme ()
  "switch solarized dark or light"
  (interactive)
  (if (eql current-theme 'solarized-dark)
      (load-solarized-theme 'light)
    (load-solarized-theme 'dark)))

(load-solarized-theme 'light)

(provide 'init-themes)
