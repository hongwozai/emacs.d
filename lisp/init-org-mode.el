(add-hook 'org-mode-hook 'org-indent-mode)

;;; org source block highlight
(setq org-src-fontify-natively t)
(setq org-agenda-include-diary nil)
(add-hook 'org-mode-hook
          '(lambda () (setq-local truncate-lines nil)))

;;; org picture (insert file: link)
(add-hook 'org-mode-hook
          '(lambda () (iimage-mode)
             (org-display-inline-images)))

(defun hong/org-insert-image ()
  (interactive)
  (org-insert-link)
  (org-redisplay-inline-images))

;;; org agenda
(setq org-agenda-span 'day)

;;; org tags
(setq org-tags-column -60)
(setq org-tag-alist '(("computer" . ?c)
                      ("nocomputer" . ?n)
                      ("outside" . ?o)))

;;; todo file or todo directory
(setq org-agenda-files (list "~/org/todo.org"))

(setq org-todo-keywords
      '((sequence "TODO(t!)" "|" "DONE(d@/!)" "CANCELED(c@/!)")))

;;; org capture fast remember
(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/org/todo.org" "inbox")
         "* TODO %?\n %i\n" :prepend t)
        ("n" "NOTE" entry (file+headline "~/org/note.org" "note")
         "* %?\n %i\n" :prepend t)
        ("i" "IDEA" entry (file+headline "~/org/note.org" "idea")
         "* %?\n %i\n" :prepend t)))

(eval-after-load 'evil
  '(progn
     (evil-declare-key 'normal org-mode-map
       "q"  'quit-window
       (kbd "TAB") 'org-cycle)))

(provide 'init-org-mode)
