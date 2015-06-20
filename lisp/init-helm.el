(require-package 'helm)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)

(setq helm-display-header-line nil)

;; fuzzy match
(setq helm-M-x-fuzzy-match t)
(setq helm-recentf-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-locate-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(setq helm-apropos-fuzzy-match t)

;; helm projectile
(require-package 'helm-projectile)
(helm-projectile-on)

(provide 'init-helm)
