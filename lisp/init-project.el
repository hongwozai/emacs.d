;; bookmark
(setq bookmark-save-flag 1)
;TODO: ede cedet
;; projectile
(require-package 'projectile)
(projectile-global-mode)

;; (setq projectile-enable-caching t)
(setq projectile-file-exists-remote-cache-expire nil)
(setq projectile-completion-system 'helm)

(provide 'init-project)
