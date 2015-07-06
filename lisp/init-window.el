;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(custom-set-faces
 '(window-numbering-face
   ((t (:foreground "Grey" :weight bold)))))

(window-numbering-mode)

;;; autoresize window
(require-package 'golden-ratio)
(golden-ratio-mode 1)
(setq golden-ratio-auto-scale t)

;;; defadvice window-numbering's select-window-n
(defadvice select-window-by-number (after golden-ratio-select-window activate)
  (when golden-ratio-mode
    (golden-ratio)))

(provide 'init-window)
