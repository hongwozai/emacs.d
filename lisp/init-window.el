;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(custom-set-faces
 '(window-numbering-face
   ((t (:foreground "Grey" :weight bold)))))

(window-numbering-mode)

(provide 'init-window)
