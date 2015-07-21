;;debug
(setq debug-on-error nil)

;;; initiate gc allocate
(setq-default gc-cons-threshold (* 1024 1024 24)
              gc-cons-percentage 0.5)

;;; common lisp support
(require 'cl)

;;; site-lisp add path
(let ((lisp-dir "~/.emacs.d/site-lisp"))
  (setq load-path
        (append
         (loop for dir in (directory-files lisp-dir)
               unless (string-match "^\\." dir)
               collecting (expand-file-name dir lisp-dir))
         load-path)))

;;; autoexit
(defun hong/exit ()
  (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process
                           'hong/exit-prompt))))
(defun hong/exit-prompt (process state)
  ;; (message "%s" state)
  (if (or (string-match "exited abnormally with code.*" state)
          (string-match "Bye" state)
          (string-match "finished" state))
      (progn
        (kill-buffer (process-buffer process))
        (winner-undo))))
;;; ielm C-c C-d exit
(add-hook 'ielm-mode-hook 'hong/exit)

(provide 'init-utils)
