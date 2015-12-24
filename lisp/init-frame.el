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
  '(projectile-mode slime-mode))
(defun purge-minor-modes ()
  (interactive)
  (setf minor-mode-alist
        (mapcar #'(lambda (x)
                    (if (member (car x) show-minor-modes)
                        x
                      (list (car x) "")))
                minor-mode-alist)))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

(setq-default mode-line-format
              (list
               mode-line-front-space
               " "
               mode-line-mule-info
               '(:eval (format "%c" (if buffer-read-only ?\- ?\+)))
               '(:eval (format "%s" (buffer-size)))
               "  "
               '(:eval (format "[%s] " (elscreen-get-current-screen)))
               mode-line-buffer-identification
               "  "
               '(:eval (format "[%s]" (projectile-project-name)))
               " "
               '(:eval (propertize "%m" 'face 'italic))
               "  "
               mode-line-position
               ;;global-mode-string, org-timer-set-timer in org-mode need this
               (propertize "%M" 'face nil)
               mode-line-end-spaces
               ))


;;; mode-line color
(add-hook
 'after-init-hook
 (lambda ()
   (lexical-let ((default-color (cons "#222226"
                                      (face-foreground 'mode-line))))
     (add-hook 'post-command-hook
               (lambda ()
                 (let
                     ((color
                       (cond ((minibufferp) default-color)
                             ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                             ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                             ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                             (t default-color))))
                   (set-face-foreground 'mode-line (cdr color))
                   (set-face-background 'mode-line (car color)))))))
 )

;;; speedbar
(require-package 'sr-speedbar)
(setq sr-speedbar-right-side nil)
(setq sr-speedbar-width 25)
(setq sr-speedbar-max-width 25)
(setq sr-speedbar-default-width 25)
(setq speedbar-use-images t)

;;; resizing fixed width
(defadvice sr-speedbar-open (after hong/sr-speedbar-fixwidth activate)
  (with-current-buffer sr-speedbar-buffer-name
    (setq window-size-fixed 'width)))
;;; bury speedbar buffer
(defadvice sr-speedbar-close (after hong/sr-speedbar-bury activate)
  (bury-buffer sr-speedbar-buffer-name))

(global-set-key (kbd "<f3>") 'sr-speedbar-toggle)
(add-hook 'speedbar-mode-hook
          (lambda ()
            (define-key speedbar-mode-map (kbd "n") 'evil-search-next)
            (define-key speedbar-mode-map (kbd "N") 'evil-search-previous)
            (define-key speedbar-mode-map (kbd "q") 'sr-speedbar-toggle)))

(provide 'init-frame)
