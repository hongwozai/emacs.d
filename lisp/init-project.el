;; bookmark
(setq bookmark-save-flag 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ignore hidden file
(eval-after-load 'find-file-in-project
  '(progn
     (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                               "makefile" ".dir-locals.el"))
     (add-to-list 'ffip-prune-patterns "*/.*/*")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(when (executable-find "gtags")
  (require-package 'ggtags)
  (autoload 'ggtags-create-tags "ggtags" nil t)
  (autoload 'ggtags-find-other-symbol "ggtags" nil t)
  (autoload 'ggtags-find-definition "ggtags" nil t)
  (autoload 'ggtags-find-reference "ggtags" nil t)
  (autoload 'ggtags-find-tag-dwim "ggtags" nil t)

  (add-hook 'ggtags-mode-hook
            (lambda ()
              (setq ggtags-update-on-save t)
              (setq-local imenu-create-index-function #'ggtags-build-imenu-index)
              (define-key ggtags-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)

              ;; remote file slow in eldoc mode
              (let ((file (buffer-file-name)))
                (when (and file (file-remote-p file))
                  (eldoc-mode -1)))
              ))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; project operation(tags, grep, compile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar project-tags-executable "etags")
(defvar project-ignore-file "*/.git* */.svn* */elpa* */obj* */build*")

(defun project--get-root (&optional iscurr)
  "Get project root path."
  (or (ffip-project-root)
      (if iscurr default-directory)))

(defun project--get-root-no-tramp (&optional iscurr)
  "For support tramp remote file"
  (let ((maybe-directory (project--get-root iscurr)))
    (when maybe-directory
      (if (file-remote-p maybe-directory)
          (file-relative-name maybe-directory default-directory)
        maybe-directory))))

(defun project--is-git ()
  (file-exists-p (concat (project--get-root) ".git")))

(defun project--build-find (wildcards)
  (let* ((find-wildcards
          (substring
           (mapconcat (lambda (str) (format "-name '%s' -o" str))
                      (split-string wildcards) " ")
           0 -2))
         (ignore-wildcards
          (substring
           (mapconcat (lambda (str) (format "-path '%s' -o" str))
                      (split-string project-ignore-file) " ")
           0 -2))
         (find-command
          (format "'(' %s ')' -prune -o '(' %s ')' -type f"
                  ignore-wildcards
                  find-wildcards)))
    find-command))

(defun project-tags-generate (wildcards)
  "Create etags TAGS"
  (interactive (list (read-shell-command
                      "Wildcards: "
                      (if (local-variable-if-set-p 'history-wildcards)
                          history-wildcards "*"))))
  (let* ((directory (project--get-root-no-tramp t))
         (tagfile (concat (file-name-as-directory directory) "TAGS"))
         (command
          (format "find %s %s | xargs %s -o %s"
                  directory
                  (project--build-find wildcards)
                  project-tags-executable
                  tagfile)))
    (setq-local history-wildcards wildcards)
    (if (= 0 (shell-command command))
        (visit-tags-table tagfile))))

(defun project-grep (wildcards regexp)
  (interactive
   (list (unless (project--is-git)
           (read-shell-command
            "Wildcards: "
            (if (local-variable-if-set-p 'history-wildcards)
                history-wildcards "*")))
         (let ((word (if (use-region-p)
                         (buffer-substring-no-properties
                          (region-beginning)
                          (region-end)))))
           (read-regexp
            (format "Regexp(default %s): " word)
            word))))
  ;; git project
  (if (project--is-git)
      (let (null-device)
        (grep (format "git --no-pager grep -n -e '%s'" regexp)))
    ;; not git project
    (let* ((directory (project--get-root-no-tramp nil))
           (command (format "find %s %s -exec grep -nH -e '%s' {} +"
                            directory
                            (project--build-find wildcards)
                            regexp)))
      (if (not directory)
          (message "NOT PROJECT!")
        (setq-local history-wildcards wildcards)
        (grep-find command)))))

(defun project-compile ()
  (interactive)
  (let ((default-directory (project--get-root t)))
    (compile compile-command)))

(defun project-compile-in-shell ()
  (interactive)
  (save-selected-window
    (let* ((path (project--get-root))
           (rpath (and path (if (file-remote-p path)
                                (progn (string-match "/.*:\\(.*\\)$" path)
                                       (match-string 1 path))
                              path)))
           (buffer-name "*shell*")
           (command (and path compile-command)))
      (if path
          (progn
            (hong/shell-run)
            (comint-send-string (get-buffer-process buffer-name)
                                (format "cd %s/ && %s \n" rpath command))
            (setq compile-command command))
        (message "CANNOT COMPILE!")))))

(provide 'init-project)