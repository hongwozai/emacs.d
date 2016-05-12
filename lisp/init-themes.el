;; only graphic TODO: after-make-frame-functions
(cl-flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; theme change
(add-hook 'after-init-hook
          (lambda ()
            (set-face-bold 'minibuffer-prompt t)))

(zenburn-with-color-variables
  (custom-theme-set-faces
   'zenburn
   ;; mode-line
   `(mode-line           ((t (:box (:line-width 1 :color ,zenburn-bg+1 :style nil)
                                   :foreground ,zenburn-green+1 :background ,zenburn-bg-1))))
   `(mode-line-inactive  ((t (:box (:line-width 1 :color ,zenburn-bg-1 :style nil)
                                   :foreground ,zenburn-fg+1 :background ,zenburn-bg+1))))
   ;; ivy
   `(ivy-current-match   ((t (:background "#1a4b77" :underline nil))))
   ;; ido
   `(ido-first-match     ((t (:background "#1a4b77"))))
   `(ido-only-match      ((t (:background "#1a4b77"))))
   ;; window number
   `(window-numbering-face ((t (:foreground "goldenrod"))))
   ))

(provide 'init-themes)
