;;; shell-header-mode --- display all buffers like shell in header line

;; Copyright (C) 2018 ZeyaLu

;; Author: zeyalu
;; Maintainer: zeyalu
;; Created: 2018/6/5
;; Version: 1.0
;; Package-Version: v1.0
;; Keywords: auto save

;;; Commentary:

;;
;; I use this:
;;
;; Contributers of ideas and/or code:
;;
;;; Change log:
;; 20 12 2019 -- v1.1
;;               support projectile
;;
;; 10 june 2018 -- v1.0
;;;                initial

(require 'cl)

(defcustom shell-header-create-function 'eshell
  "create function when have not shell buffer"
  :type  'symbol
  :group 'shell-header)

(defcustom shell-header-use-project-support nil
  "support projectile"
  :type  'symbol
  :group 'shell-header)

(defun shell-header--get-current-buffer-list (&optional is-global)
  (if (or is-global (not shell-header-use-project-support))
      (buffer-list)
    ;; projectile buffer
    (if (and (require 'projectile nil t) (projectile-project-p))
        (projectile-project-buffers)
      (buffer-list))))

(defun shell-header--get-project-name ()
  (if (require 'projectile nil t)
      (projectile-project-name)
    ""))

(defun shell-header--get-shell-buffer (&optional is-global)
  (sort
   (remove-if-not
    (lambda (x)
      (with-current-buffer x
        (or (eq major-mode 'comint-mode)
            (eq major-mode 'eshell-mode)
            (eq major-mode 'term-mode)
            (eq (get major-mode 'derived-mode-parent)
                'comint-mode)
            (eq major-mode 'vterm-mode))))
    (shell-header--get-current-buffer-list is-global))
   (lambda (x y)
     (string< (buffer-name x) (buffer-name y)))))

(defun shell-header--shell-mode-buffer-list (&optional is-global)
  (append (when (and shell-header-use-project-support
                     (projectile-project-p))
            (list (format "<Proj: %s> |" (shell-header--get-project-name))))
          (mapcar
           (lambda (x)
             (let ((name (buffer-name x)))
               (if (eq name (buffer-name))
                   (propertize
                    (format "[%s]" name)
                    'face
                    `((:background
                       ,(face-background 'mode-line-inactive))))
                 (format "[%s]" name))))
           (shell-header--get-shell-buffer is-global))))

(defun shell-header--header-line-setup ()
  (setq-local header-line-format
              '((:eval (shell-header--shell-mode-buffer-list)))))

(defun shell-header--header-line-cancel ()
  (setq-local header-line-format nil))

(defun shell-header--switch (direction offset &optional is-global)
  (let* ((misc-list (shell-header--get-shell-buffer is-global))
         (misc-list-len (length misc-list))
         (index (position (current-buffer) misc-list)))
    (if (= misc-list-len 0)
        (call-interactively shell-header-create-function)
        (if index
            (let ((target-index
                   (if (eq direction 'NEXT)
                       (mod (+ index offset) misc-list-len)
                     (mod (- index offset) misc-list-len))))
              (switch-to-buffer (nth target-index misc-list)))
          (switch-to-buffer (nth 0 misc-list))))))

;;; keymap
(defvar shell-header-mode-map (make-sparse-keymap)
  "Keymap for shell header switch")

(define-key shell-header-mode-map (kbd "M-]") 'shell-header-next)
(define-key shell-header-mode-map (kbd "M-[") 'shell-header-prev)

;;;###autoload
(defun shell-header--kill-buffer (&optional is-global)
  (interactive)
  (when current-prefix-arg (setq is-global t))
  (mapcar (lambda (x) (kill-buffer x))
          (shell-header--get-shell-buffer is-global)))

;;;###autoload
(defun shell-header-next ()
  (interactive)
  (shell-header--switch 'NEXT 1))

;;;###autoload
(defun shell-header-prev ()
  (interactive)
  (shell-header--switch 'PREV 1))

;;;###autoload
(define-minor-mode shell-header-mode
  "display all buffers like shell in header line"
  :init-value nil
  :global nil
  :lighter nil
  (if shell-header-mode
      (shell-header--header-line-setup)
    (shell-header--header-line-cancel)))

(provide 'shell-header-mode)
;;; shell-header-mode.el ends here
