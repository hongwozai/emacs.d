;; only graphic
(cl-flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; theme change
(zenburn-with-color-variables
  (custom-theme-set-faces
   'zenburn
   ;; font-lock
   `(font-lock-type-face ((t (:foreground "#90AFD3"))))
   ;; mode-line
   `(mode-line
     ((t (:box (:line-width 1 :color ,zenburn-bg+1 :style nil)
               :foreground ,zenburn-green+1 :background ,zenburn-bg-1))))
   `(mode-line-inactive
     ((t (:box (:line-width 1 :color ,zenburn-bg-1 :style nil)
               :foreground ,zenburn-fg+1 :background ,zenburn-bg+1))))
   ;; window number
   `(window-numbering-face ((t (:foreground "goldenrod"))))
   ))

(provide 'init-themes)
