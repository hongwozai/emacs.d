;;; ========================== windmove ==================================
(require 'windmove)

;;; ========================== winner ==================================
(require 'winner)
(winner-mode)

;;; ========================== window number =============================
(require 'window-numbering)

;;; Hack window-numbering
(defun window-numbering-get-number-string (&optional window)
  (let ((s (hong--special-number (window-numbering-get-number window))))
    (propertize s 'face 'window-numbering-face))
  )

(window-numbering-mode)

;;; ========================= change layout =============================
(defun hong/window-layout-change ()
  (interactive)
  (let* ((split-width-threshold nil)
         (layout (car (window-tree)))
         (direct (first layout))
         (other-buffer (save-selected-window
                         (other-window 1)
                         (window-buffer))))
    (save-selected-window
      (delete-other-windows)
      (split-window nil nil direct)
      (switch-to-buffer-other-window other-buffer))))

;;; windows size(above below left right)
(defun hong-window-resize (dir)
  (let* ((horiz? (or (eq dir 'right) (eq dir 'left)))
         (other (window-in-direction (if horiz? 'right 'below)))
         (plus? (or (eq dir 'right) (eq dir 'below)))
         (num 2)
         (amount (if (eq (not other) (not plus?))
                     num (- num))))
    (enlarge-window amount horiz?)))

(provide 'init-window)
