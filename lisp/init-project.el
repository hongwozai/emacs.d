;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; etags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(autoload 'counsel-etags-select-find-tag-at-point "counsel-etags-select" nil t)
(autoload 'counsel-etags-select-generate-etags "counsel-etags-select" nil t)
(autoload 'counsel-etags-select-visit-tag-table "counsel-etags-select" nil t)

;; Don't ask before rereading the TAGS files if they have changed
(setq tags-revert-without-query t)

;;; counsel-etags-select
(define-key evil-normal-state-map
    (kbd "C-]") 'counsel-etags-select-find-tag-at-point)

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

(defun hong/project-find-file (&optional open-other-window)
  (interactive "P")
  (let ((ffip-project-root (get-project-root)))
    (ffip open-other-window)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; fuzzy read file
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun hong/counsel-grep-project (&optional dir fs)
  (interactive)
  (let* ((dir (if current-prefix-arg
                  (file-name-as-directory
                   (read-directory-name "Directory: "))))
         (fs (if current-prefix-arg
                 (read-string "Files: " "*")))
         (keyword (read-string "Enter grep pattern: "))
         (directory (if dir dir (get-project-root)))
         (files (if fs fs "*"))
         (useless (grep-compute-defaults))
         (cands (split-string
                 (shell-command-to-string
                  (rgrep-default-command keyword files directory))
                 "[\r\n]+"
                 t))
         )
    (ivy-set-display-transformer 'hong/counsel-grep-project
                                 'counsel-git-grep-transformer)
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
      (haveag (if current-prefix-arg
                  (funcall-interactively #'counsel-ag)
                  (counsel-ag "" dir)))
      (t (if current-prefix-arg
             (funcall-interactively #'hong/counsel-grep-project)
             (hong/counsel-grep-project))))))


(provide 'init-project)