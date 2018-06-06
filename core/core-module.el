;;-------------------------------------------
;;; auto load module
;;-------------------------------------------
(defun module-load (path)
  (when (file-exists-p path)
    (if (file-directory-p path)
        nil
      (ignore-errors (load path t)))))

(defun autoload-modules (&optional directory)
  (let* ((dir (or directory
                  (expand-file-name "module"
                                    user-emacs-directory)))
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

(provide 'core-module)
