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
(setq org-agenda-restore-windows-after-quit t)

;;; set org directory
(setq org-directory
      (expand-file-name "Notes" user-home-directory))

;;; basic agenda
(setq org-agenda-files
      (list org-directory))

;;; inbox
(setq org-default-notes-file
      (expand-file-name "inbox.org" org-directory))

;;; gtd keyword
(setq org-todo-keywords
      '((sequence "TODO(t!)"
                  "DOING(i@/!)"
                  "|"
                  "DONE(d@/!)"
                  "CANCELED(c@/!)")))
;;; refile
(setq org-refile-targets
      '((org-agenda-files :maxlevel . 1)))

;;-------------------------------------------
;;; key
;;-------------------------------------------
(add-hook 'org-mode-hook
          (lambda ()
            (setq-local completion-at-point-functions
                        (cons 'pcomplete-completions-at-point
                              completion-at-point-functions))
            (toggle-truncate-lines)))

;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/set-key org-mode-map
  :state 'normal
  (kbd "TAB") 'org-cycle)

;;; global
(core/leader-set-key
  "co" 'org-capture)

;;-------------------------------------------
;;; babel (eval code)
;;-------------------------------------------
(org-babel-do-load-languages
 'org-babel-load-languages
 '((python     . t)
   (sql        . t)
   (js         . t)
   (emacs-lisp . t)
   (ruby       . t)
   (dot        . t)
   (plantuml   . t)
   (octave     . t)))

;;-------------------------------------------
;;; org display image
;;-------------------------------------------
(add-hook 'org-mode-hook 'org-display-inline-images)
(add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)

;;-------------------------------------------
;;; org export markdown
;;-------------------------------------------
(require-package 'ox-gfm)

(eval-after-load "org"
  '(require 'ox-gfm nil t))