;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ignore hidden file
(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".svn" ".git" ".hg" ".dir-locals.el"))
  (add-to-list 'ffip-prune-patterns "*/.*/*"))

;;; use ffip-project-root
(defun get-project-root ()
  (file-name-as-directory (or (ffip-project-root) default-directory)))

(defun counsel-ag-project ()
  (interactive)
  (counsel-ag nil (get-project-root)))

(provide 'init-project)