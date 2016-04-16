;; bookmark
(setq bookmark-save-flag 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ignore hidden file
(eval-after-load 'find-file-in-project
  '(progn
     (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                               "makefile" ".dir-local.el"))
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
              (setq ggtags-highlight-tag nil)
              (setq ggtags-enable-navigation-keys nil)
              (setq-local imenu-create-index-function #'ggtags-build-imenu-index)
              (define-key ggtags-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)

              ;; remote file slow in eldoc mode
              (let ((file (buffer-file-name)))
                (when (and file (file-remote-p file))
                  (eldoc-mode -1)))
              ))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; tags jump overlay
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(dolist (var '(imenu-default-goto-function
               find-tag
               pop-tag-mark
               elisp-slime-nav-find-elisp-thing-at-point
               ggtags-find-definition
               ggtags-find-other-symbol
               anaconda-mode-find-definitions
               anaconda-mode-go-back))
  (eval `(hong--display-line ,var)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; tags operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun tags-generate (directory wildcards)
  "create or update TAGS"
  (interactive (list (ido-read-directory-name
                      "Directory: "
                      (and (local-variable-if-set-p 'history-directory)
                           history-directory))
                     (read-string
                      "Wildcards: "
                      (and (local-variable-if-set-p 'history-wildcards)
                           history-wildcards))))
  (let* ((exec (or (executable-find "etags") "ctags -e"))
         (command
          (format "find %s '(' %s ')' -type f | xargs %s"
                  directory
                  (substring
                   (mapconcat (lambda (str) (format "-name '%s' -o" str))
                              (split-string wildcards) " ")
                   0 -2)
                  exec)))
    (setq-local history-directory directory)
    (setq-local history-wildcards wildcards)
    (setq-local history-command command)
    (shell-command command)))

(defun tags-update ()
  (interactive)
  (if (local-variable-if-set-p 'history-command)
      (shell-command history-command)
    (call-interactively #'tags-generate)))

(provide 'init-project)