;; initial
(setq inhibit-startup-message t)
(setq initial-scratch-message ";; Happy learning, you can do it.\n\n")
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
               '(:eval (format "%s" (buffer-size)))
               "  "
               '(:eval (propertize "%b " 'face nil
                                   'help-echo (buffer-file-name)))
               '(:eval (format "[%s]" (projectile-project-name)))
               "  "
               mode-line-position
               '(:eval (format "[%s]" major-mode))
               ;;global-mode-string, org-timer-set-timer in org-mode need this
               (propertize "%M" 'face nil)
               mode-line-end-spaces
               ))

(lexical-let ((default-color (cons "#657b83" "#fdf6e3")))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-foreground 'mode-line (cdr color))
                (set-face-background 'mode-line (car color))))))

(provide 'init-frame)
