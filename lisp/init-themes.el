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
   ((t :foreground "#ffffff" :background ,hong/mode-line-normal
       :overline ,hong/mode-line-normal :inverse-video nil)))
 `(mode-line-inactive
   ((t :foreground "#ffffff" :background ,hong/mode-line-inactive
       :overline ,hong/mode-line-inactive :inverse-video nil)))
 )

;;; ======================== mode line theme ==============================
(defface hong/evil-state-face
  `((((class color) (background dark))
     :foreground "#F0DFAF"
     :background ,hong/mode-line-normal :weight bold))
  "face when evil change state")

(defun hong//change-color-with-evil-state ()
  (let* ((default-color hong/mode-line-normal)
         (color (cond ((minibufferp) default-color)
                      ((evil-insert-state-p) "#e80000")
                      ((evil-emacs-state-p)  "#444488")
                      ((buffer-modified-p)   "#006fa0")
                      (t default-color))))
    (set-face-background 'hong/evil-state-face color)))

(add-hook 'post-command-hook 'hong//change-color-with-evil-state)

(provide 'init-themes)
