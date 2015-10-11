(add-hook 'org-mode-hook 'org-indent-mode)

;;; org source block highlight
(setq org-src-fontify-natively t)
(setq org-agenda-include-diary nil)
(add-hook 'org-mode-hook
          '(lambda () (setq-local truncate-lines nil)))

;;; todo file or todo directory
(setq org-agenda-files (list "~/org/todo.org"))

(setq org-todo-keywords
      '((sequence "TODO(!)" "|" "DONE(@/!)" "CANCELED(@/!)")))

;;; org capture fast remember
(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/org/todo.org" "inbox")
         "* TODO %?\n %i" :prepend t)
        ("n" "NOTE" entry (file+headline "~/org/note.org" "note")
         "* %?\n %i" :prepend t :empty-lines 1)))

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
