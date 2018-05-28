(add-hook 'org-mode-hook
          '(lambda ()
            (setq-local truncate-lines nil)
            (org-indent-mode)
            (iimage-mode)
            (org-display-inline-images)))

;;; org source block highlight
(setq org-src-fontify-natively t)
(setq org-agenda-include-diary nil)
(setq org-image-actual-width '(300))

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
      '((sequence "TODO(t!)" "INPROGRESS(i@/!)" "|" "DONE(d@/!)" "CANCELED(c@/!)")))

;;; org capture fast remember
;;; org-capture
(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/org/todo.org" "inbox")
         "* TODO %?\n %i\n" :prepend t)
        ("n" "NOTE" entry (file+headline "~/org/note.org" "note")
         "* %?\n %i\n" :prepend t :empty-lines-after 1)
        ("i" "IDEA" entry (file+headline "~/org/note.org" "idea")
         "* %?\n %i\n" :prepend t)))

(with-eval-after-load 'evil
  (evil-declare-key 'normal org-mode-map
                    "q"  'quit-window
                    (kbd "TAB") 'org-cycle))

;;; org babel
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (dot    . t)
   (octave . t)
   (awk    . t)))

(provide 'init-org-mode)
