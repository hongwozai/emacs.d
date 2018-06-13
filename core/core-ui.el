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
(require-package 'gruvbox-theme)
(load-theme 'gruvbox-dark-medium t)

;;; modify
(make-face-bold 'font-lock-keyword-face)
(make-face-bold 'font-lock-function-name-face)
(with-eval-after-load 'ivy
  (set-face-attribute 'ivy-current-match nil
                      :background (face-background 'mode-line-inactive)
                      :underline  nil))

;;-------------------------------------------
;;; diminish
;;-------------------------------------------
;;; purge minor modes display
(defvar show-minor-modes '(iedit-mode))

(defun purge-minor-modes ()
  (setf minor-mode-alist
        (mapcar #'(lambda (x)
                    (if (member (car x) show-minor-modes)
                        x
                        (list (car x) "")))
                minor-mode-alist)))

(add-hook 'after-change-major-mode-hook 'purge-minor-modes)

;;-------------------------------------------
;;; startup mode
;;-------------------------------------------
(setq initial-scratch-message "#+TITLE: Scratch \n\n\n")
(setq initial-major-mode 'org-mode)

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
