;;-------------------------------------------
;;; auto load module
;;-------------------------------------------
(defvar modules-with-manual nil)

(defun module-get-path (&optional directory)
  (or directory (expand-file-name "module" user-emacs-directory)))

(defun module-load (path)
  (when (file-exists-p path)
    (if (file-directory-p path)
        nil
      (ignore-errors (load path t)))))

(defun autoload-modules (&optional directory)
  (let* ((dir (module-get-path directory))
         (files (directory-files dir))
         (module-files (remove-if-not
                        (lambda (x) (string-match-p "^module-" x))
                        files)))
    (dolist (module module-files)
      (module-load
       (concat (file-name-as-directory dir) module)))))

(defun module-require (exec)
  (when (not (executable-find exec))
    (throw 'require-exit nil)))

(defun module-require-manual ()
  (throw 'require-manual nil))

(defun module-install ()
  (interactive)
  (letf (((symbol-function 'module-require-manual)
          #'core/empty-function))
    (let* ((dir (file-name-as-directory (module-get-path)))
           (path (concat
                  dir
                  (format "module-%s.el"
                          (read-string (format "module at %s: " dir))))))
      (module-load path))))

(provide 'core-module)
