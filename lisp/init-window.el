;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(window-numbering-mode)

;;; change layout
(defun hong/window-layout-change ()
  (interactive)
  (let* ((layout (car (window-tree)))
         (direct (first layout))
         (other-buffer (save-selected-window
                         (other-window 1)
                         (window-buffer))))
    (save-selected-window
      (delete-other-windows)
      (split-window nil nil direct)
      (switch-to-buffer-other-window other-buffer))))

(provide 'init-window)
