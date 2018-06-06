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
;;
;; 10 june 2018 -- v1.0
;;;                initial

(require 'cl)

(defun shell-header--get-shell-buffer ()
  (sort
   (remove-if-not
    (lambda (x)
      (with-current-buffer x
        (or (eq major-mode 'comint-mode)
            (eq major-mode 'eshell-mode)
            (eq major-mode 'term-mode)
            (eq (get major-mode 'derived-mode-parent)
                'comint-mode))))
    (buffer-list))
   (lambda (x y)
     (string< (buffer-name x) (buffer-name y)))))

(defun shell-header--shell-mode-buffer-list ()
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
   (shell-header--get-shell-buffer)))

(defun shell-header--header-line-setup ()
  (setq-local header-line-format
              '((:eval (shell-header--shell-mode-buffer-list)))))

(defun shell-header--header-line-cancel ()
  (setq-local header-line-format nil))

(defun shell-header--switch (direction offset)
  (let* ((misc-list (shell-header--get-shell-buffer))
         (misc-list-len (length misc-list))
         (index (position (current-buffer) misc-list)))
    (if index
        (let ((target-index
               (if (eq direction 'NEXT)
                   (mod (+ index offset) misc-list-len)
                 (mod (- index offset) misc-list-len))))
          (switch-to-buffer (nth target-index misc-list))))))

;;; keymap
(defvar shell-header-mode-map (make-sparse-keymap)
  "Keymap for shell header switch")

(define-key shell-header-mode-map "M-]" 'shell-header-next)
(define-key shell-header-mode-map "M-[" 'shell-header-prev)

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
