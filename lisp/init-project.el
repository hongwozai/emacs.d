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

(defun counsel-ag-project (arg)
  (interactive "P")
  (counsel-ag nil (unless arg (get-project-root))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; recentf dired
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun ivy-recentf-directory ()
  (interactive)
  (ivy-read "Recentf Directory: "
            (remove-duplicates
             (mapcar (lambda (x) (if (file-remote-p x)
                                (file-name-directory x)
                                (with-directory (file-name-directory x)
                                  (or (ffip-project-root) default-directory))
                                ))
                     recentf-list)
             :test #'string=)
            :action
            (lambda (f)
              (with-ivy-window
                (counsel-find-file f)))
            :caller 'ivy-recentf-directory))

(provide 'init-project)