;; only graphic
(cl-flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; theme change
(zenburn-with-color-variables
  (custom-theme-set-faces
   'zenburn
   ;; font-lock
   `(font-lock-type-face ((t (:foreground "#90AFD3"))))
   ;; window number
   `(window-numbering-face ((t (:foreground "goldenrod"))))
   ))

(provide 'init-themes)
