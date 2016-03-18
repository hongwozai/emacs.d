;; color theme
(require-package 'zenburn-theme)

;;; only graphic color
(cl-flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; theme change
(add-hook 'after-init-hook
          (lambda ()
            (set-face-bold 'font-lock-keyword-face t)
            (set-face-bold 'font-lock-function-name-face t)
            (set-face-bold 'font-lock-type-face t)
            (set-face-bold 'minibuffer-prompt t)
            (set-face-bold 'tooltip t)
            ))

(custom-theme-set-faces
 'zenburn
 ;; avy
 `(avy-lead-face       ((t (:foreground "white" :background "#e52b50"))))
 `(avy-lead-face-0     ((t (:foreground "white" :background "#4f57f9"))))
 `(avy-background-face ((t (:foreground "grey40"))))
 ;; ivy
 `(ivy-current-match   ((t (:background "#1a4b77" :underline nil))))
 ;; mode line
 `(mode-line           ((t (:box (:line-width 1 :color "#4F4F4F" :style nil)))))
 `(mode-line-inactive  ((t (:box (:line-width 1 :color "#4F4F4F" :style nil)))))
 ;; ido
 `(ido-first-match     ((t (:background "#1a4b77"))))
 `(ido-only-match      ((t (:background "#1a4b77"))))
 ;; window number
 `(window-numbering-face ((t (:foreground "goldenrod"))))
 ;; linum
 `(linum ((t (:foreground "Grey" :background "#3F3F3F"))))
 )

(provide 'init-themes)
