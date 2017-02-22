;;; ========================= gtags ==================================
(require-package 'counsel-gtags)
(setq counsel-gtags-auto-update t)

(define-key evil-normal-state-map (kbd "M-.") 'counsel-gtags-find-definition)
(define-key evil-normal-state-map (kbd "M-,") 'counsel-gtags-pop)

(provide 'init-gtags)