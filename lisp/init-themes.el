;;; monokai
(load-theme 'monokai t)

;;; Hacking monokai
(let* ((monokai-class '((class color) (min-colors 257))))
  (custom-theme-set-faces
   'monokai
   `(font-lock-builtin-face
     ((,monokai-class (:foreground ,monokai-blue :weight normal))))

   `(font-lock-keyword-face
     ((,monokai-class (:foreground ,monokai-red :weight bold))))
   )
  )

;;; ====================== mode line format ============================
(defvar hong/mode-line
  (list
   mode-line-front-space
   " "
   '(:eval (propertize (concat
                        "<"
                        (upcase (substring-no-properties
                                 (symbol-name evil-state) 0 1))
                        ">")))
   " "
   mode-line-mule-info
   '(:eval (format "%c" (if buffer-read-only ?\- ?\+)))
   ;; line number
   "%l"
   ":%c  "
   ;; buffer name
   mode-line-buffer-identification
   " "
   ;; modes
   '(:eval (propertize (concat "[%m")
            'face '(:foreground "#dfaf8f")))
   '("" minor-mode-alist)
   '(:eval (propertize (concat "]")
            'face '(:foreground "#dfaf8f")))
   ;; vc
   '(:eval (propertize (format-mode-line '(vc-mode vc-mode))
            'face '(:foreground "#DCA3A3" :slant italic)))
   " "
   ;;global-mode-string, org-timer-set-timer in org-mode need this
   "%M"
   '(:eval (propertize " "
            'display
            `((space :align-to (- (+ right-fringe right-margin) 6)))))
   "%p"
   mode-line-end-spaces))

(setq-default mode-line-format hong/mode-line)
(setq mode-line-format hong/mode-line)

(defun hong//change-color-with-evil-state ()
  (let* ((default-color (cons "#49483E" "#F8F8F0"))
         (color (cond ((minibufferp) default-color)
                      ((evil-insert-state-p) '("#840228" . "#ffffff"))
                      ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                      ((evil-visual-state-p) '("#AF005F" . "#ffffff"))
                      ((and (buffer-file-name)
                            (buffer-modified-p))   '("#121a2a" . "#ffffff"))
                      (t default-color))))
    (set-face-background 'mode-line (car color))
    (set-face-foreground 'mode-line (cdr color))))

(add-hook 'post-command-hook 'hong//change-color-with-evil-state)

(provide 'init-themes)
