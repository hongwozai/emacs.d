;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; etags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'etags-select-find-tag-at-point "etags-select" nil t)

;;; etags-select
(define-key evil-normal-state-map
    (kbd "C-]") 'etags-select-find-tag-at-point)

(defadvice etags-select-find-tag-at-point (before hong-esftap activate)
  (if (eq tags-file-name nil)
      (call-interactively #'visit-tags-table)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'ffip "find-file-in-project" nil t)
(autoload 'ffip-project-root "find-file-in-project" nil t)
(autoload 'find-file-in-project-by-selected "find-file-in-project" nil t)

;;; ignore hidden file
(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".svn" ".git" ".hg"))
  (add-to-list 'ffip-prune-patterns "*/.*/*"))

;;; use ffip-project-root
(defun get-project-root ()
  (file-name-as-directory (or (condition-case nil
                                  (ffip-project-root)
                                (wrong-type-argument nil))
                              default-directory)))

(defun hong/project-find-file ()
  (interactive)
  (let ((ffip-project-root (get-project-root)))
    (ffip)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fuzzy read file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hong/counsel-grep-project (&optional dir)
  (interactive)
  (let* ((keyword (read-string "Enter grep pattern: "))
         (directory (if dir dir (get-project-root)))
         (cands (split-string
                 (shell-command-to-string
                  (format "grep -rsnE \"%s\" %s" keyword directory))
                 "[\r\n]+"
                 t))
         )
    (ivy-read (format "Grep at %s: " keyword)
              cands
              :action #'counsel-git-grep-action
              :caller 'hong/counsel-grep-project
              )))

(defun hong/project-search-file ()
  (interactive)
  (let ((dir (get-project-root))
        (haveag (executable-find "ag"))
        (isgit (locate-dominating-file "" ".git")))
    (cond
      (isgit (counsel-git-grep))
      (haveag (counsel-ag "" dir))
      (t (hong/counsel-grep-project)))))

(provide 'init-project)