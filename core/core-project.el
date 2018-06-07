;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'find-file-in-project)

(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".git" ".hg"))
  (add-to-list 'ffip-prune-patterns "*/.*/*"))

;;-------------------------------------------
;;; project
;;-------------------------------------------
(defun core/project-root ()
  (ffip-project-root))

(defun core/find-all-files (&optional directory)
  (let ((ffip-project-root (or directory default-directory))
        (ffip-patterns nil))
    (find-file-in-project)))

(defun core/find-all-matches (&optional directory)
  (interactive)
  (call-interactively
   (cond ((executable-find "rg") #'counsel-rg)
         ((executable-find "ag") #'counsel-ag)
         (t #'rgrep))))

(provide 'core-project)
