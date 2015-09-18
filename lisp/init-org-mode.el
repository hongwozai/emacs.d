(add-hook 'org-mode-hook 'org-indent-mode)

;;; org source block highlight
(setq org-src-fontify-natively t)
(setq org-agenda-include-diary t)
(add-hook 'org-mode-hook
          '(lambda () (setq truncate-lines nil)))

(eval-after-load 'evil
  '(progn
     (evil-declare-key 'normal org-mode-map
       "gh" 'outline-up-heading
       "gl" 'outline-next-visible-heading
       "gt" 'org-ctrl-c-ctrl-c
       "gj" 'org-forward-heading-same-level
       "gk" 'org-backward-heading-same-level
       "t"  'org-todo
       "<" 'org-metaleft
       ">" 'org-metaright
       (kbd "TAB") 'org-cycle)))

(provide 'init-org-mode)
