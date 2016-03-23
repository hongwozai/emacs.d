;; winner(two plugin conflict with eyebrowse and winner, so winner not use)
;; (require 'winner)
;; (winner-mode)

;; window numbering
(require-package 'window-numbering)
(setq window-numbering-mode-line-position 1)
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

;;; workspace
(require-package 'eyebrowse)
(setq eyebrowse-wrap-around   t
      eyebrowse-new-workspace t)
(eyebrowse-mode)
(eyebrowse-setup-evil-keys)

(defun hong/workspace-number ()
  "Return the number of the current workspace."
  (let* ((num (eyebrowse--get 'current-slot))
         (str (if num (int-to-string num))))
    (cond
     ((equal str "1") "➊")
     ((equal str "2") "➋")
     ((equal str "3") "➌")
     ((equal str "4") "➍")
     ((equal str "5") "➎")
     ((equal str "6") "❻")
     ((equal str "7") "➐")
     ((equal str "8") "➑")
     ((equal str "9") "➒")
     ((equal str "0") "➓"))))

(defun hong/workspace-setup-mode-line ()
  (let ((mlf (default-value 'mode-line-format)))
    (push '(:eval (concat (hong/workspace-number) " ")) mlf)
    (setq-default mode-line-format mlf)
    (force-mode-line-update t)
    ))

(hong/workspace-setup-mode-line)

(let ((map eyebrowse-mode-map))
  (global-set-key (kbd "s-1") 'eyebrowse-switch-to-window-config-1)
  (global-set-key (kbd "s-2") 'eyebrowse-switch-to-window-config-2)
  (global-set-key (kbd "s-3") 'eyebrowse-switch-to-window-config-3)
  (global-set-key (kbd "s-4") 'eyebrowse-switch-to-window-config-4)
  (global-set-key (kbd "s-5") 'eyebrowse-switch-to-window-config-5)
  (define-key map (kbd "C-c C-w") 'eyebrowse-switch-to-window-config)
  )

(provide 'init-window)
