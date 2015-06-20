(add-hook 'org-mode-hook 'org-indent-mode)

(setq org-agenda-include-diary t)
(add-hook 'org-mode-hook
          '(lambda () (setq truncate-lines nil)))

;; (defvar org-agenda-directory "~/agenda/")
;; (setq org-agenda-files
;;       (mapcar #'(lambda (x) (concat org-agenda-directory x))
;;               (list "inbox.org" "finished.org" "canceled.org")))

;; ;;; todo next note done cancel idea project
;; (setq org-todo-keywords
;;       '((sequence "TODO(t!)" "NEXT(n)" "|" "DONE(d@/!)" "ABORT(a@/!)")))

;; ;;; org-refile-target
;; (setq org-default-notes-file (first org-agenda-files))
;; (setq org-capture-templates
;;       `(("t" "TODO" entry (file+headline (first org-agenda-files) "Tasks")
;;          "** TODO %? %t\n %i %a" :prepend t)))

;;; startup display agenda list
;; (org-agenda-list t)
(provide 'init-org-mode)
