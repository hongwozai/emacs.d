;-------------------------------------------
;;; commonlisp support
;;-------------------------------------------
(require 'cl)

;;-------------------------------------------
;;; utils function
;;-------------------------------------------
(defun core/path-concat (basedir &rest dirs)
  "concatenate many directores to path"
  (if (null dirs)
      (expand-file-name basedir)
    (apply #'core/path-concat
           (concat (file-name-as-directory basedir) (car dirs))
           (cdr dirs))))

(defun core/add-subdir-to-load-path (directory)
  (when (file-directory-p directory)
    (let* ((files (mapcar (lambda (x) (expand-file-name x directory))
                          (remove-if
                           (lambda (x) (or (string= x ".")
                                      (string= x "..")))
                           (directory-files directory))))
           (subdirs (remove-if-not (lambda (x) (file-directory-p x)) files)))
      (dolist (dir subdirs)
        (add-to-list 'load-path dir)))))

(defun core/list-insert! (list which insert)
  (let ((mlpos list)
        pred)
    (while (and mlpos
                (let ((sym (or (car-safe (car mlpos))
                               (car mlpos))))
                  (not (eq which sym))))
      (setq pred mlpos
            mlpos (cdr mlpos)))
    (setcdr pred (cons insert mlpos))
    list))

(defun maybe-require (executable feature)
  (let ((s (if (listp executable) executable (list executable))))
    (when (some (lambda (x) (executable-find x)) s)
      (require feature))))

(defun core/empty-function ())

;;-------------------------------------------
;;; compatibility
;;-------------------------------------------
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

;;-------------------------------------------
;;; auto exit from shell, term, comint
;;-------------------------------------------
(defun core--exit-prompt (process state)
  (if (string-match "\\(exited\\|finished\\)" state)
      (progn
        (quit-window)
        (kill-buffer (process-buffer process)))))

(defun core/auto-exit ()
  (let ((process
         (ignore-errors
           (get-buffer-process (current-buffer)))))
    (when process
      (set-process-sentinel process 'core--exit-prompt))))

(provide 'core-funcs)
