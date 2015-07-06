(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-agenda-include-diary t)
(add-hook 'org-mode-hook
          '(lambda () (setq truncate-lines nil)))

(provide 'init-org-mode)
