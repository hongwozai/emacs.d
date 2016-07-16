;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; etags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'etags-select)
;;; etags-select
(define-key evil-normal-state-map
    (kbd "C-]") 'etags-select-find-tag-at-point)

(defadvice etags-select-find-tag-at-point (before hong-esftap activate)
  (if (eq tags-file-name nil)
      (call-interactively #'visit-tags-table)))

;;; tags generate
(defvar ctags-executable "etags")

(defun tags-regenerate ()
  "Regenerate etags TAGS"
  (interactive)
  (require 'grep)
  (require 'find-dired)
  (let* ((exec ctags-executable)
         ;; default directory
         (dir (file-relative-name
               (read-directory-name "Directory: " (ffip-project-root))))
         ;; files
         (files (read-shell-command
                 "Files: "
                 (let ((str (assoc major-mode hong-grep-files-aliases)))
                   (if str (cdr str) "*"))))
         ;; find
         (find-command
          (build-find-command
           files
           dir
           grep-find-ignored-directories
           grep-find-ignored-files))
         ;; total
         (real-command (concat find-command " | xargs " exec)))
    (when (= 0 (shell-command real-command))
      (visit-tags-table "TAGS")
      (message "Generate TAGS Successful!"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'find-file-in-project)
;;; ignore hidden file
(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".svn" ".git" ".hg" ".dir-locals.el"))
  (add-to-list 'ffip-prune-patterns "*/.*/*"))

;;; use ffip-project-root
(defun get-project-root ()
  (file-name-as-directory (or (ffip-project-root) default-directory)))

(defun counsel-ag-project (arg)
  (interactive "P")
  (counsel-ag nil (unless arg (get-project-root))))

(defun ffip-current-directory ()
  (interactive)
  (let ((ffip-project-root (get-project-root)))
    (ffip)))

;;; C-p
(define-key evil-normal-state-map  (kbd "C-p") 'ffip-current-directory)

(provide 'init-project)