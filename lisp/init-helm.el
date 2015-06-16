(require-package 'helm)
(helm-mode 1)

(global-set-key (kbd "M-x") 'helm-M-x)

;; helm find files in TAB
(define-key helm-find-files-map (kbd "<tab>") 'helm-execute-persistent-action)

;; fuzzy match
(setq helm-recentf-fuzzy-match t)
(setq helm-buffers-fuzzy-matching t)
(setq helm-locate-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
(setq helm-imenu-fuzzy-match t)
(setq helm-apropos-fuzzy-match t)

;; helm projectile
(require-package 'helm-projectile)
(helm-projectile-on)

(provide 'init-helm)
