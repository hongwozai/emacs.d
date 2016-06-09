;; only graphic
(cl-flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; my-zenburn theme
(zenburn-with-color-variables
  (custom-theme-set-faces
   'zenburn
   ;; font-lock
   `(font-lock-type-face ((t (:foreground "#90AFD3"))))
   ;; window number
   `(window-numbering-face ((t (:foreground "goldenrod"))))
   ;; mode-line
   `(mode-line
     ((,class (:foreground ,zenburn-green+1 :background ,zenburn-bg-1))
      (t :inverse-video t)))
   `(mode-line-inactive
     ((t (:foreground ,zenburn-fg+1 :background ,zenburn-bg+1))))
   ;; ido
   `(ido-first-match ((t (:foreground ,zenburn-bg-1
                                      :background "#65a7e2"
                                      :weight bold))))
   `(ido-only-match ((t (:foreground ,zenburn-bg-1
                                     :background "#65a7e2"
                                     :weight bold))))
   ;; linum
   `(linum ((t (:foreground ,zenburn-green :background ,zenburn-bg))))
   ;; vertical-border
   `(vertical-border ((t (:foreground ,zenburn-bg+3))))
   ;; ivy
   `(ivy-subdir ((t (:background ,zenburn-bg))))
   `(ivy-current-match ((t (:background "#65a7e2" :foreground ,zenburn-bg-1
                                        :weight bold))))
   `(ivy-minibuffer-match-face-1 ((t (:background ,zenburn-bg))))
   `(ivy-minibuffer-match-face-2 ((t (::background ,zenburn-bg-05))))
   `(ivy-minibuffer-match-face-3 ((t (:background "#7777ff"))))
   `(ivy-minibuffer-match-face-4 ((t (:background "#8a498a"))))
   ;; avy
   `(avy-lead-face-0
     ((t (:foreground ,zenburn-bg+1 :background ,zenburn-blue+1 :inverse-video nil))))
   `(avy-lead-face
     ((t (:foreground "white" :background ,zenburn-red-4 :inverse-video nil))))
   ))

(provide 'init-themes)
