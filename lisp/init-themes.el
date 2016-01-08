;; color theme
(require-package 'zenburn-theme)
(require-package 'highlight-numbers)

;;; only graphic color
(flet ((display-graphic-p (&optional what) t))
  (load-theme 'zenburn t))

;;; theme change
(add-hook 'after-init-hook
          (lambda ()
            (set-face-bold 'font-lock-keyword-face t)
            (set-face-bold 'font-lock-function-name-face t)
            (set-face-bold 'font-lock-type-face t)
            (set-face-bold 'minibuffer-prompt t)
            (set-face-bold 'isearch t)
            (set-face-bold 'tooltip t)
            (set-face-bold 'company-tooltip-selection t)
            (set-face-bold 'eldoc-highlight-function-argument t)
            (set-face-bold 'ido-first-match t)
            (set-face-bold 'ido-only-match t)
            (set-face-bold 'ido-vertical-match-face t)
            ))

(defvar hong/mode-line-normal "#2B2B2B")
(defvar hong/mode-line-inactive "#383838")

(custom-theme-set-faces
 'zenburn
 ;; avy
 `(avy-lead-face
   ((t (:foreground "white" :background "#e52b50"))))
 `(avy-lead-face-0
   ((t (:foreground "white" :background "#4f57f9"))))
 `(avy-background-face
   ((t (:foreground "grey40"))))

 ;; mode-line
 `(mode-line
   ((t (:box (line-width 1 :color ,hong/mode-line-normal :style nil))
       :foreground "#ffffff" :background ,hong/mode-line-normal
       :overline ,hong/mode-line-normal :inverse-video nil)))
 `(mode-line-inactive
   ((t :foreground "#ffffff" :background ,hong/mode-line-inactive
       :overline ,hong/mode-line-inactive :inverse-video nil)))
 )

;;; mode-line color
(add-hook
 'after-init-hook
 (lambda ()
   (lexical-let ((default-color (cons hong/mode-line-normal
                                      (face-foreground 'mode-line))))
     (add-hook 'post-command-hook
               (lambda ()
                 (let
                     ((color
                       (cond ((minibufferp) default-color)
                             ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                             ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                             ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                             (t default-color))))
                   (set-face-foreground 'mode-line (cdr color))
                   (set-face-background 'mode-line (car color)))))))
 )


(add-hook 'prog-mode-hook 'highlight-numbers-mode)

(provide 'init-themes)
