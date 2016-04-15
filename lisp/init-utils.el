;;debug
(setq debug-on-error nil)
(setq debug-on-quit nil)

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

;;; =============================  autoexit ================================
(defun hong/exit ()
  (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process 'hong/exit-prompt))))

(defun hong/exit-prompt (process state)
  (if (string-match "\\(exited\\|finished\\)" state)
      (progn
        (delete-window (get-buffer-window (process-buffer process)))
        (kill-buffer (process-buffer process)))))
;;; ielm C-c C-d exit
(add-hook 'ielm-mode-hook 'hong/exit)

;;; ===========================  select window =============================
(defmacro hong/select-buffer-window (cmd buffer-name)
  `(defadvice ,cmd (after ,(gensym) activate)
     (ignore-errors (select-window (get-buffer-window ,buffer-name)))))

(defun hong/sw (alist)
  (when (not (null alist))
    (eval `(hong/select-buffer-window ,(caar alist) ,(cdar alist)))
    (hong/sw (cdr alist))))

(hong/sw '((describe-function . "*Help*")
           (describe-key . "*Help*")
           (describe-mode . "*Help*")
           (describe-coding-system . "*Help*")
           (describe-variable . "*Help*")
           (shell-command . "*Shell Command Output*")
           (list-colors-display . "*Colors*")
           (list-processes . "*Process List*")))

;;; ========================= system relevant ==============================
(defun hong/updatedb ()
  "updatedb need by counsel locate"
  (interactive)
  (let ((default-directory "/sudo:root@localhost:/"))
    (message (shell-command-to-string "updatedb"))))

;;; ========================= compatibility ================================
(when (version< emacs-version "24.4")
  (defun set-face-bold (face bold-p &optional frame)
    (set-face-bold-p face bold-p frame))

  (defun set-face-italic (face italic-p &optional frame)
    (set-face-italic-p face italic-p frame)))

(provide 'init-utils)
