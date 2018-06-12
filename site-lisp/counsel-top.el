;;; counsel-top.el --- display top command output and kill process

;; Copyright (C) 2018 ZeyaLu

;; Author: zeyalu
;; Maintainer: zeyalu
;; Created: 2018/6/12
;; Version: 1.0
;; Package-Version: v1.0
;; Keywords: top ivy

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;;; Commentary:

;;
;; I use this:
;; M-x counsel-top
;;
;; Contributers of ideas and/or code:
;;
;;; Change log:
;;
;; 10 june 2018 -- v1.0
;;;                initial

;;; Code:

(require 'ivy)

(defvar counsel-top-base-command
  (format "top -w %d -bc -n 1 " (- (frame-width) 5)))

(defvar counsel-top-by-root t
  "use top command by user root.")

(defun counsel-top--run-command ()
  (with-temp-buffer
    (insert (shell-command-to-string counsel-top-base-command))
    (goto-char (point-min))
    (when (re-search-forward "[\t ]*PID")
      (forward-line 1)
      (delete-region (point-min) (point))
      (split-string (buffer-substring-no-properties (point-min) (point-max))
                    "\n"))))

(defun counsel-top--action (line)
  (catch nil
    (start-file-process "kill" nil
                        "kill" "-9" (nth 0 (split-string line)))))

(defun counsel-top--internal (&optional directory)
  (let ((ivy-height 20)
        (default-directory (or directory default-directory)))
    (ivy-read "Top: " (counsel-top--run-command)
              :action #'counsel-top--action)))

;;;###autoload
(defun counsel-top ()
  (interactive)
  (if (or current-prefix-arg counsel-top-by-root)
      (counsel-top--internal "/sudo:root@localhost:/")
    (counsel-top--internal)))

(provide 'counsel-top)
;;; counsel-top.el ends here
