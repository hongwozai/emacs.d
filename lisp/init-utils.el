;;debug
(setq debug-on-error nil)
(setq debug-on-quit nil)
(setq ad-redefinition-action 'accept)

;;; initiate gc allocate
;; (setq-default gc-cons-threshold (* 1024 1024 24)
;;               gc-cons-percentage 0.5)

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

(setq custom-theme-directory
      (concat user-emacs-directory "site-lisp/themes"))

;;; =============================  autoexit ================================
(defun hong/exit ()
  (let ((process (ignore-errors (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process 'hong/exit-prompt))))

(defun hong/exit-prompt (process state)
  (if (string-match "\\(exited\\|finished\\)" state)
      (progn
        (winner-undo)
        (kill-buffer (process-buffer process)))))
;;; ielm C-c C-d exit
(add-hook 'ielm-mode-hook 'hong/exit)

;;; =========================== maybe =====================================
(defun maybe-require (executable feature)
  (let ((s (if (listp executable) executable (list executable))))
    (when (some (lambda (x) (executable-find x)) s)
      (require feature))))

;;; =========================== select window =============================
(defmacro hong/select-buffer-window (&rest CBS)
  (setq-local select-list '(progn))
  (dolist (num (number-sequence 0 (1- (length CBS)) 2))
    (add-to-list
     'select-list
     `(defadvice ,(nth num CBS) (after ,(gensym) activate)
        (ignore-errors (select-window (get-buffer-window ,(nth (1+ num) CBS)))))
     t))
  select-list)

(hong/select-buffer-window describe-function "*Help*"
                           describe-key  "*Help*"
                           describe-mode  "*Help*"
                           describe-coding-system  "*Help*"
                           describe-variable  "*Help*"
                           shell-command  "*Shell Command Output*"
                           list-colors-display  "*Colors*"
                           list-processes  "*Process List*"
                           grep  "*grep*"
                           rgrep  "*grep*"
                           occur  "*Occur*")

;;; ========================= system relevant ==============================
(defun hong-updatedb ()
  "updatedb need by counsel locate"
  (interactive)
  (let ((default-directory "/sudo:root@localhost:/"))
    (message (shell-command-to-string "updatedb"))))

;;; ========================= compatibility ================================
(when (version< emacs-version "24.4")
  (defun set-face-bold (face bold-p &optional frame)
    (set-face-bold-p face bold-p frame))

  (defun set-face-italic (face italic-p &optional frame)
    (set-face-italic-p face italic-p frame))

  (defmacro with-eval-after-load (file &rest body)
    "Execute BODY after FILE is loaded.
FILE is normally a feature name, but it can also be a file name,
in case that file does not provide any feature."
    (declare (indent 1) (debug t))
    `(eval-after-load ,file (lambda () ,@body))))

;;; ============================ convert number ===========================
(defun hong--special-number (num)
  "Return the number of the current workspace."
  (let* ((str (if num (int-to-string num))))
    (cond
      ((equal str "1") "➊")
      ((equal str "2") "➋")
      ((equal str "3") "➌")
      ((equal str "4") "➍")
      ((equal str "5") "➎")
      ((equal str "6") "❻")
      ((equal str "7") "➐")
      ((equal str "8") "➑")
      ((equal str "9") "➒")
      ((equal str "0") "➓"))))

;;; ========================= assistant ====================================
(defmacro with-directory (directory &rest body)
  `(let ((default-directory ,directory))
     (progn ,@body)))

;;; search and replace
(defalias 's2n 'string-to-number)
(defalias 'lineno 'line-number-at-pos)

;;; ========================= autosave ====================================

(defun hong--auto-save-buffers ()
  (dolist (buffer (buffer-list))
    (with-current-buffer buffer
      (if (and (buffer-file-name)
               (buffer-modified-p)
               ;; < 10M
               (< (buffer-size) (* 1024 1024 10)))
          (save-buffer)))))

(defvar hong--save-timer)

(defvar hong--save-timeout 5)

(defun hong--auto-save-on ()
  (setq hong--save-timer
        (run-with-idle-timer hong--save-timeout 1
                             #'hong--auto-save-buffers)))

(defun hong--auto-save-off ()
  (cancel-timer hong--save-timer))

(hong--auto-save-on)

(provide 'init-utils)
