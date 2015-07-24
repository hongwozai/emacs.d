(add-hook 'org-mode-hook 'org-indent-mode)

;;; org source block highlight
(setq org-src-fontify-natively t)
(setq org-agenda-include-diary t)
(add-hook 'org-mode-hook
          '(lambda () (setq truncate-lines nil)))

(provide 'init-org-mode)
