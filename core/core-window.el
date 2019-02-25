;;-------------------------------------------
;;; winner
;;-------------------------------------------
(winner-mode t)

;;-------------------------------------------
;;; windows numbering
;;-------------------------------------------
;; install
(require-package 'winum)
(require 'winum)

;; config
(set-face-attribute 'winum-face nil :weight 'bold)
(setq winum-scope 'visible)
(setq winum-auto-setup-mode-line nil)

;; startup
(winum-mode t)

;; for winum-keymap.
(core/set-key winum-keymap
  :state 'native
  (kbd "M-0") 'winum-select-window-0
  (kbd "M-1") 'winum-select-window-1
  (kbd "M-2") 'winum-select-window-2
  (kbd "M-3") 'winum-select-window-3
  (kbd "M-4") 'winum-select-window-4
  (kbd "M-5") 'winum-select-window-5
  (kbd "M-6") 'winum-select-window-6)

;;-------------------------------------------
;;; windows resize
;;-------------------------------------------
;;; windows size(above below left right)
(defun core/window-resize (dir)
  (let* ((horiz? (or (eq dir 'right) (eq dir 'left)))
         (other (window-in-direction (if horiz? 'right 'below)))
         (plus? (or (eq dir 'right) (eq dir 'below)))
         (num 2)
         (amount (if (eq (not other) (not plus?))
                     num (- num))))
    (enlarge-window amount horiz?)))

;;-------------------------------------------
;;; windows layout
;;-------------------------------------------
(defun core/window-layout-change ()
  (interactive)
  (when (listp (car (window-tree)))
    (let* ((split-width-threshold nil)
           (layout (car (window-tree)))
           (direct (first layout))
           (other-buffer (save-selected-window
                           (other-window 1)
                           (window-buffer))))
      (save-selected-window
        (delete-other-windows)
        (split-window nil nil direct)
        (switch-to-buffer-other-window other-buffer)))))

;;-------------------------------------------
;;; key panel
;;-------------------------------------------
(defhydra hydra-window (:color amaranth :hint nil)
  "
^ ^ ^ ^ _k_(_K_) ^ ^ ^ | Layout: _r_otate [_SPC_]:layout _u_ndo
^ _h_(_H_) ^+^ _l_(_L_)| Split:  _v_ert [_s_]:horz
^ ^ ^ ^ _j_(_J_) ^ ^ ^ | Delete: _c_ancel [_o_]:maximum
"
  ("h" evil-window-left)
  ("j" evil-window-down)
  ("k" evil-window-up)
  ("l" evil-window-right)
  ("H" (lambda () (interactive) (core/window-resize 'left)))
  ("J" (lambda () (interactive) (core/window-resize 'below)))
  ("K" (lambda () (interactive) (core/window-resize 'above)))
  ("L" (lambda () (interactive) (core/window-resize 'right)))
  ("r" evil-window-rotate-downwards)
  ("SPC" core/window-layout-change)
  ("s" split-window-vertically :color blue)
  ("v" split-window-horizontally :color blue)
  ("c" evil-window-delete :color blue)
  ("o" delete-other-windows :color blue)
  ("u" winner-undo)
  ("q" nil :exit t))

(provide 'core-window)
