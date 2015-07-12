;; bookmark
(setq bookmark-save-flag 1)

(require-package 'find-file-in-project)
(require-package 'projectile)
(projectile-global-mode)
(setq projectile-enable-caching nil)
(setq projectile-file-exists-remote-cache-expire nil)
(format "Pro[%s]" (projectile-project-name))

(provide 'init-project)
