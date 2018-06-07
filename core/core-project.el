;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'find-file-in-project)

;;-------------------------------------------
;;; project
;;-------------------------------------------
(defun core/project-root ()
  (ffip-project-root))

(defun core/find-all-files (&optional directory)
  (interactive)
  (let ((ffip-project-root (or directory default-directory))
        (ffip-patterns nil))
    (find-file-in-project)))

(provide 'core-project)
