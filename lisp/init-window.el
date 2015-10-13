;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(window-numbering-mode)
(set-face-foreground 'window-numbering-face "goldenrod")

;;; key
(global-set-key (kbd "s-h") 'windmove-left)
(global-set-key (kbd "s-j") 'windmove-down)
(global-set-key (kbd "s-k") 'windmove-up)
(global-set-key (kbd "s-l") 'windmove-right)

(global-set-key (kbd "s-o") 'delete-other-windows)
(global-set-key (kbd "s-s") 'split-window-below)
(global-set-key (kbd "s-v") 'split-window-horizontally)
(global-set-key (kbd "s-c") 'delete-window)

(global-set-key (kbd "s-<return>") 'multi-term)

(provide 'init-window)
