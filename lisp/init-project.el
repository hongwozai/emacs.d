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
  (file-name-as-directory (or (ffip-project-root) default-directory)))

(defun ffip-current-directory ()
  (interactive)
  (let ((ffip-project-root (get-project-root)))
    (ffip)))

(provide 'init-project)