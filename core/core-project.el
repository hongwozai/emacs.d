;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'projectile)

;;-------------------------------------------
;;; setting
;;-------------------------------------------
(setq projectile-completion-system 'ivy)

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

(provide 'core-project)
