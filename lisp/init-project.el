;; bookmark
(setq bookmark-save-flag 1)

(require-package 'find-file-in-project)
(require-package 'projectile)
;;; projectile
(projectile-global-mode)
(setq projectile-enable-caching nil)
(setq projectile-file-exists-remote-cache-expire nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; my-project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq hong/my-default-workspace "~/workspace/")

(defun hong/add-directory-to-projectile ()
  (interactive)
  (projectile-add-known-project default-directory))

(defun hong/new-project (project-name)
  (interactive "sPlease input new project name: ")
  (let ((path    (concat hong/my-default-workspace project-name))
        (istemp  (read-char-choice "Is temp project [Y|n]:" '(?y ?n))))
    (if  (file-exists-p path)
        (message "directory exist!")
      (progn (make-directory path)
             (when (equal istemp ?n)
               (projectile-add-known-project path))
             (dired path)))))

(provide 'init-project)
