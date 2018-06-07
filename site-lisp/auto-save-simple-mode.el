;;; auto-save-mode.el --- auto save buffers

;; Copyright (C) 2018 ZeyaLu

;; Author: zeyalu
;; Maintainer: zeyalu
;; Created: 2018/6/2
;; Version: 1.0
;; Package-Version: v1.0
;; Keywords: auto save

;;; Commentary:

;;
;; I use this:
;; (auto-save-simple-mode)
;;
;; Contributers of ideas and/or code:
;;
;;; Change log:
;;
;; 10 june 2018 -- v1.0
;;;                initial

(defcustom auto-save-simple-timeout 5
  "auto save timeout"
  :type 'number
  :group 'auto-save-simple)

(defcustom auto-save-simple-max-file-size (* 10 1024 1024)
  "auto save max file size"
  :type 'number
  :group 'auto-save-simple)

;;; private
(defvar auto-save-simple--save-timer)

(defun auto-save-simple--save-buffers ()
  (let ((inhibit-message t))
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (if (and (buffer-file-name) (buffer-modified-p)
                 ;; < 10M
                 (< (buffer-size) auto-save-simple-max-file-size))
            (save-buffer))))))

(defun auto-save-simple-on ()
  "Turn on auto save simple mode"
  (setq auto-save-simple--save-timer
        (run-with-idle-timer auto-save-simple-timeout 1
                             #'auto-save-simple--save-buffers)))

(defun auto-save-simple-off ()
  "Turn off auto save simple mode"
  (cancel-timer auto-save-simple--save-timer))

;;;###autoload
(define-minor-mode auto-save-simple-mode
    "auto save buffer minor-mode"
  :init-value nil
  :global t
  :lighter " auto-save"
  (if auto-save-simple-mode
      (auto-save-simple-on)
    (auto-save-simple-off)))

(provide 'auto-save-simple-mode)
;;; auto-save-simple-mode.el ends here