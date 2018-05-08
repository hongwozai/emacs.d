;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; etags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'etags-select-find-tag-at-point "etags-select" nil t)

;;; etags-select
(define-key evil-normal-state-map
    (kbd "C-]") 'etags-select-find-tag-at-point)

(with-eval-after-load 'etags-select
  (setq etags-select-go-if-unambiguous t)
  (defadvice etags-select-find-tag-at-point (before hong-esftap activate)
    (if (eq tags-file-name nil)
        (call-interactively #'visit-tags-table))))

(defun hong/find-and-etags (dir)
  (interactive
   (list (read-directory-name "Directory: " (get-project-root))))
  (let* ((delpath (format "\\( -path '*%s/.*/*' -o -path '*/*TAGS' \\)"
                          dir))
         (curpath (concat
                   (file-name-as-directory
                    (read-directory-name "Gen Tags Directory: "))
                   "TAGS"))
         (initial-value
          (format "find %s -type f -a -not %s | etags -o %s -"
                  dir
                  delpath
                  curpath))
         (shell (read-shell-command "Command: " initial-value))
         (retstr (shell-command-to-string shell)))
    (if (string-equal retstr "")
        (progn
         (visit-tags-table curpath)
         (message "Successful Generate TAGS at %s" curpath))
      (message "ERROR: %s" retstr))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'ffip "find-file-in-project" nil t)
(autoload 'ffip-project-root "find-file-in-project" nil t)
(autoload 'find-file-in-project-by-selected "find-file-in-project" nil t)

;;; ignore hidden file
(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".git" ".hg"))
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
  (interactive
   (list
    (if current-prefix-arg
        (file-name-as-directory (read-directory-name "Directory: ")))))
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

;;; use counsel-git-grep performance problem
(setq counsel--git-grep-count-threshold 2000)

(defun hong/project-search-file ()
  (interactive)
  (let ((dir (get-project-root))
        (haveag (executable-find "ag"))
        (isgit (and (locate-dominating-file "" ".git")
                    (executable-find "git"))))
    (cond
      (isgit (counsel-git-grep))
      (haveag (counsel-ag "" dir))
      (t (hong/counsel-grep-project)))))


(provide 'init-project)