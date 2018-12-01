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
        ".cquery_cached_index"))

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
  (kbd "n")   #'projectile-add-known-project)

;;-------------------------------------------
;;; function
;;-------------------------------------------
(defun counsel-projectile-find-matches ()
  (interactive)
  (let ((rootdir (projectile-project-root)))
    (cond ((executable-find "rg") (counsel-rg nil rootdir))
          ((executable-find "ag") (counsel-ag nil rootdir))
          ((and
            (locate-dominating-file rootdir ".git")
            (executable-find "git"))
           #'counsel-git-grep)
          (t #'projectile-grep))))

(provide 'core-project)
