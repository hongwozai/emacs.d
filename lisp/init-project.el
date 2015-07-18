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

(defun hong/remove-the-key-from-project-cache (key)
  "delete key-value from projectile cache(hash)"
  (let ((key nil))
    (mapc #'(lambda (x)
              (when (string-match (concat ".*" key) x)
                (setq key x)))
          (projectile-hash-keys projectile-project-root-cache))
    (remhash key projectile-project-root-cache)))

(defun hong/add-directory-to-projectile ()
  "add current directory to projectile project list"
  (interactive)
  (hong/remove-the-key-from-project-cache default-directory)
  (if (or (projectile-root-bottom-up default-directory)
          (projectile-root-top-down  default-directory)
          (projectile-root-top-down-recurring default-directory))
      (progn (projectile-add-known-project default-directory)
             (message "add projectile project list"))
    (message "you're not project!")))


(defun hong/new-project (project-name)
  "create new project in projectile"
  (interactive "sPlease input new project name: ")
  (let ((path    (concat (expand-file-name hong/my-default-workspace) project-name))
        (istemp  (read-char-choice "Is temp project [Y|n]:" '(?y ?n))))
    (if  (file-exists-p path)
        (message "project exist!")
      (progn (make-directory path)
             (when (equal istemp ?n)
               (with-temp-file (concat path "/" ".projectile")))
             (dired path)))))

(provide 'init-project)
