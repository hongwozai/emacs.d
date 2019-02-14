;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'projectile)

;;-------------------------------------------
;;; setting
;;-------------------------------------------
(setq projectile-completion-system 'ivy)

;;; cancel qutomatically add project
(setq projectile-track-known-projects-automatically nil)

;;; ignore
(setq projectile-globally-ignored-directories
      '(".idea"
        ".ensime_cache"
        ".eunit"
        ".git"
        ".hg"
        ".fslckout"
        "_FOSSIL_"
        ".bzr"
        "_darcs"
        ".tox"
        ".svn"
        ".stack-work"
        ".cquery_cached_index"
        ".ccls-cache"))

;;-------------------------------------------
;;; enable
;;-------------------------------------------
(projectile-mode +1)

;;-------------------------------------------
;;; misc
;;-------------------------------------------
;;; keybindings
(core/set-key projectile-mode-map
  :state 'normal
  (kbd "C-p") 'projectile-command-map)

(core/set-key projectile-command-map
  :state 'native
  (kbd "s")   #'counsel-projectile-find-matches
  (kbd "n")   #'projectile-add-known-project
  (kbd "C-p") #'projectile-switch-project
  )

;;-------------------------------------------
;;; function
;;-------------------------------------------
(defun counsel-projectile-find-matches (&optional match)
  (interactive)
  (let ((rootdir (projectile-project-root))
        (matchstr match))
    (cond
     ((executable-find "rg") (counsel-rg matchstr rootdir))
     ((executable-find "ag") (counsel-ag matchstr rootdir))
     ((and
       (locate-dominating-file rootdir ".git")
       (executable-find "git"))
      (counsel-git-grep nil matchstr))
     (t (projectile-grep matchstr)))
    ))

(defun projectile-root-known-project (&optional dir)
  "find project-root from `projectile-known-projects'"
  (let* ((dir (or dir default-directory))
         (truedir (file-name-as-directory (file-truename dir))))
    (dolist (x projectile-known-projects)
      (let ((realproject (file-truename x)))
        (when (string-prefix-p realproject truedir)
          (return realproject))))))


;;; find known project first
(unless (memq 'projectile-root-known-project
              projectile-project-root-files-functions)
  (push 'projectile-root-known-project
        projectile-project-root-files-functions))

(provide 'core-project)
