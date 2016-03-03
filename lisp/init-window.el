;; winner
(require 'winner)
(winner-mode)

;; window numbering
(require-package 'window-numbering)
(window-numbering-mode)
(set-face-foreground 'window-numbering-face "goldenrod")

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

(define-key evil-emacs-state-map (kbd "C-w s") 'evil-window-split)
(define-key evil-emacs-state-map (kbd "C-w v") 'evil-window-vsplit)
(define-key evil-emacs-state-map (kbd "C-w h") 'evil-window-left)
(define-key evil-emacs-state-map (kbd "C-w j") 'evil-window-down)
(define-key evil-emacs-state-map (kbd "C-w k") 'evil-window-up)
(define-key evil-emacs-state-map (kbd "C-w l") 'evil-window-right)
(define-key evil-emacs-state-map (kbd "C-w o") 'delete-other-windows)
(define-key evil-emacs-state-map (kbd "C-w c") 'evil-window-delete)

(define-key evil-normal-state-map (kbd "C-w t") 'hong/window-layout-change)
(define-key evil-emacs-state-map (kbd "C-w t") 'hong/window-layout-change)

(provide 'init-window)
