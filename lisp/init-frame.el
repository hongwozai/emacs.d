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

;;; purge minor modes display
(defvar show-minor-modes '(slime-mode iedit-mode))

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
(defvar hong/mode-line
  (list
   ;; after init-window.el
   '(:eval (propertize (concat
                        " "
                        (hong--special-number (eyebrowse--get 'current-slot))
                        "|"
                        (window-numbering-get-number-string)
                        " ")
            'face '(:foreground "#2b2b2b" :background "#f0dfaf")))
   mode-line-front-space
   " "
   mode-line-mule-info
   '(:eval (format "%c" (if buffer-read-only ?\- ?\+)))
   ;; line number
   '(:eval (propertize "%l" 'face '(:foreground "#f0dfaf")))
   ":%c  "
   ;; buffer name
   mode-line-buffer-identification
   " "
   ;; modes
   '(:eval (propertize (concat "[%m")
            'face '(:foreground "#dfaf8f")))
   '("" minor-mode-alist)
   '(:eval (propertize (concat "]")
            'face '(:foreground "#dfaf8f")))
   ;; vc
   '(:eval (propertize (format-mode-line '(vc-mode vc-mode))
            'face '(:foreground "#DCA3A3" :slant italic)))
   " "
   ;; which-func
   '(:eval (if (memq major-mode which-func-display-mode)
               which-func-format))
   "  "
   ;;global-mode-string, org-timer-set-timer in org-mode need this
   "%M"
   '(:eval (propertize " "
            'display
            `((space :align-to (- (+ right-fringe right-margin) 6)))))
   "%p"
   mode-line-end-spaces))

(setq-default mode-line-format hong/mode-line)
(setq mode-line-format hong/mode-line)

(defvar mode-line-normal "#2B2B2B")
(defun hong//change-color-with-evil-state ()
  (let* ((default-color (cons mode-line-normal "#8fb28f"))
         (color (cond ((minibufferp) default-color)
                      ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                      ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                      ((evil-visual-state-p) '("#AF005F" . "#ffffff"))
                      ((and (buffer-file-name)
                            (buffer-modified-p))   '("#006fa0" . "#ffffff"))
                      (t default-color))))
    (set-face-background 'mode-line (car color))
    (set-face-foreground 'mode-line (cdr color))))

(add-hook 'post-command-hook 'hong//change-color-with-evil-state)

;;; ==================== scratch unkilled ===============================
(defun hong/scratch-kill-buffer-query-function ()
  (interactive)
  (if (string= "*scratch*" (buffer-name))
      (let ((bufstr (buffer-string)))
        (when (buffer-modified-p)
          (erase-buffer)
          (insert initial-scratch-message)
          (funcall initial-major-mode)
          (set-buffer-modified-p nil))
        nil)
      t))

(add-hook 'kill-buffer-query-functions 'hong/scratch-kill-buffer-query-function)

(provide 'init-frame)
