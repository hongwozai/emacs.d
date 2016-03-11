;; initial
(setq inhibit-startup-message t)
(setq initial-scratch-message
      ";;; To follow the path:\n;;; look for the master, follow the master,\n;;; walk with the master, see through the master\n;;; become the master.\n\n")
(setq initial-major-mode 'lisp-interaction-mode)

(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)

;;; gui
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))


(defvar show-minor-modes
  '(slime-mode))
(defun purge-minor-modes ()
  (interactive)
  (setf minor-mode-alist
        (mapcar #'(lambda (x)
                    (if (member (car x) show-minor-modes)
                        x
                      (list (car x) "")))
                minor-mode-alist)))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;;; ====================== mode line format ============================
(defface hong/mode-line-face
  `((((class color) (background dark))
     :foreground "black"
     :background "#F0DFAF"))
  "face when evil change state")

(defvar hong/mode-line
  (list
   mode-line-front-space
   " "
   mode-line-mule-info
   '(:eval (format "%c" (if buffer-read-only ?\- ?\+)))
   '(:eval (format "%s" (buffer-size)))
   "  "
   ;; mode-line-buffer-identification
   '(:eval (propertize " %b " 'face 'hong/evil-state-face))
   "  "
   '(:eval (propertize "%m" 'face 'italic))
   "  "
   mode-line-position
   ;;global-mode-string, org-timer-set-timer in org-mode need this
   (propertize "%M" 'face nil)
   mode-line-end-spaces
   ))

(setq mode-line-format hong/mode-line)
(setq-default mode-line-format hong/mode-line)

(provide 'init-frame)
