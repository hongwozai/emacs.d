;;-------------------------------------------
;;; basic option
;;-------------------------------------------
;;; org source block highlight
(setq org-startup-indented t)
(setq org-src-fontify-natively t)

;; image
(setq org-image-actual-width '(300))

;;-------------------------------------------
;;; org agenda/gtd
;;-------------------------------------------
(setq org-agenda-span 'day)
(setq org-agenda-include-diary nil)

(setq org-todo-keywords
      '((sequence "TODO(t!)"
                  "DOING(i@/!)"
                  "|"
                  "DONE(d@/!)"
                  "CANCELED(c@/!)")))

;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/set-key org-mode-map
  :state 'normal
  (kbd "TAB") 'org-cycle)

;;-------------------------------------------
;;; babel (eval code)
;;-------------------------------------------
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((python     . t)
;;    (sql        . t)
;;    (js         . t)
;;    (emacs-lisp . t)
;;    (ruby       . t)
;;    (dot        . t)
;;    (plantuml   . t)
;;    (octave     . t)))

(provide 'core-org)
