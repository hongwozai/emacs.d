;; color theme
(require-package 'solarized-theme)

(load-theme 'solarized-light t)

(defvar current-theme 'solarized-light)
(defun hong/toggle-solarized-theme ()
  "switch solarized dark or light"
  (interactive)
  (if (eq current-theme 'solarized-dark)
      (progn
        (load-theme 'solarized-light t)
        (setq current-theme 'solarized-light))
    (progn
      (load-theme 'solarized-dark t)
      (setq current-theme 'solarized-dark))))

(provide 'init-themes)
