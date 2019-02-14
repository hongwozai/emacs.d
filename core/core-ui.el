;;-------------------------------------------
;;; startup message
;;-------------------------------------------
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-message t)
(setq inhibit-default-init t)

;;; bug...
(setq inhibit-startup-echo-area-message t)

;;-------------------------------------------
;;; interface
;;-------------------------------------------
(when (boundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(when (boundp 'menu-bar-mode)
  (menu-bar-mode -1))

;;-------------------------------------------
;;; title
;;-------------------------------------------
(setq frame-title-format
      '((:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                   "%b"))))

;;-------------------------------------------
;;; theme
;;-------------------------------------------
(require-package 'autothemer)
(require 'zy-dark-theme)
(load-theme 'zy-dark t)

;;; switch theme to current-theme's next in themes
(defun one-key-switch-theme (current-theme themes order)
  (let (theme (index 0) (themes-length (length themes)))
    (find-if (lambda (x) (setq index (1+ index)) (equal x current-theme))
             themes)
    (if (eq order 'next)
        (setq index (% index themes-length))
      (setq index (% (+ (- index 2) themes-length) themes-length)))
    (setq current-theme (nth index themes))
    (load-theme current-theme t nil)
    (message "Switch Theme [%s]" (symbol-name current-theme))
    current-theme))

(one-key-switch-theme 'spacemacs-light
                      '(spacemacs-dark spacemacs-light zy-dark) 'prev)

;;-------------------------------------------
;;; diminish
;;-------------------------------------------
;;; purge minor modes display
(defvar show-minor-modes '(iedit-mode projectile))

(defun purge-minor-modes ()
  (setf minor-mode-alist
        (mapcar #'(lambda (x)
                    (if (member (car x) show-minor-modes)
                        x
                        (list (car x) "")))
                minor-mode-alist)))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;;-------------------------------------------
;;; don't use powerline, because too slow
;;-------------------------------------------
;;; mode-line
(setq-default mode-line-format
              '("%e"
                " "
                (:eval (winum-get-number-string))
                mode-line-front-space
                mode-line-mule-info
                mode-line-client
                mode-line-modified
                mode-line-remote
                ;; vim state
                (:eval evil-mode-line-tag)
                ;; line and column
                "[" "%02l" "," "%01c" "] "
                mode-line-frame-identification
                mode-line-buffer-identification
                (vc-mode vc-mode)
                "  "
                mode-line-modes
                mode-line-misc-info
                mode-line-end-spaces))

;;-------------------------------------------
;;; startup mode
;;-------------------------------------------
(setq initial-scratch-message ";;; Scratch\n\n\n")
(setq initial-major-mode 'emacs-lisp-mode)

(defun core/scratch-kill-buffer-query-function ()
  (if (string= "*scratch*" (buffer-name))
      (let ((bufstr (buffer-string)))
        (when (buffer-modified-p)
          (erase-buffer)
          (insert initial-scratch-message)
          (funcall initial-major-mode)
          (set-buffer-modified-p nil))
        nil)
      t))

(add-hook 'kill-buffer-query-functions
          'core/scratch-kill-buffer-query-function)

;;-------------------------------------------
;;; font size
;;-------------------------------------------
(defun font-size-scale (num &optional step)
  (let ((height (face-attribute 'default :height))
        (step (or step 1)))
    (set-face-attribute
     'default nil :height (+ (* num step) height))))

(defhydra hydra-font (:color amaranth :hint nil)
  " Zoom "
  ("+" (lambda () (interactive) (font-size-scale 5)) "zoom+")
  ("-" (lambda () (interactive) (font-size-scale -5)) "zoom-")
  ("g" text-scale-increase "increase")
  ("l" text-scale-decrease "decrease")
  ("d" (lambda () (interactive)
         (message "%s" (face-attribute 'default :height)))
   "display")
  ("q" nil :exit t))

(provide 'core-ui)
