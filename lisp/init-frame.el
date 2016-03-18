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
(require-package 'powerline)
(setq powerline-default-separator 'utf-8)
(powerline-default-theme)

(defvar hong/mode-line-normal "#2B2B2B")
(defvar hong/mode-line-inactive "#383838")

(defun hong//change-color-with-evil-state ()
  (let* ((default-color hong/mode-line-normal)
         (color (cond ((minibufferp) default-color)
                      ((evil-insert-state-p) "#e80000")
                      ((evil-emacs-state-p)  "#444488")
                      ((evil-visual-state-p) "#AF005F")
                      ((buffer-modified-p)   "#006fa0")
                      (t default-color))))
    (set-face-background 'mode-line color)))

(add-hook 'post-command-hook 'hong//change-color-with-evil-state)

(provide 'init-frame)
