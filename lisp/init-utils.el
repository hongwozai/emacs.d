;;debug
(setq debug-on-error nil)
(setq debug-on-quit nil)
(setq ad-redefinition-action 'accept)

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

(add-to-list 'custom-theme-load-path
             (file-truename (concat user-emacs-directory "site-lisp/hwzenburn")))

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

;;; ========================= build find ===================================
(defun build-find-command (files dir &optional ignore-dirs ignore-files)
  (grep-expand-template
   "find <D> <X> -type f <F>"
   nil
   (concat (shell-quote-argument "(")
           " " find-name-arg " "
           (mapconcat #'shell-quote-argument
                      (split-string files)
                      (concat " -o " find-name-arg " "))
           " "
           (shell-quote-argument ")"))
   dir
   (concat (and ignore-dirs
                (concat "-type d "
                        (shell-quote-argument "(")
                        ;; we should use shell-quote-argument here
                        " -path "
                        (mapconcat
                         #'(lambda (ignore)
                             (cond ((stringp ignore)
                                    (shell-quote-argument
                                     (concat "*/" ignore)))
                                   ((consp ignore)
                                    (and (funcall (car ignore) dir)
                                         (shell-quote-argument
                                          (concat "*/"
                                                  (cdr ignore)))))))
                         ignore-dirs
                         " -o -path ")
                        " "
                        (shell-quote-argument ")")
                        " -prune -o "))
           (and ignore-files
                (concat (shell-quote-argument "!") " -type d "
                        (shell-quote-argument "(")
                        ;; we should use shell-quote-argument here
                        " -name "
                        (mapconcat
                         #'(lambda (ignore)
                             (cond ((stringp ignore)
                                    (shell-quote-argument ignore))
                                   ((consp ignore)
                                    (and (funcall (car ignore) dir)
                                         (shell-quote-argument
                                          (cdr ignore))))))
                         ignore-files
                         " -o -name ")
                        " "
                        (shell-quote-argument ")")
                        " -prune -o ")))
   ))

(provide 'init-utils)
