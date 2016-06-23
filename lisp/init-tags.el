;;; ========================= etags ==================================
;;; etags-select
(define-key evil-normal-state-map
  (kbd "C-]") 'etags-select-find-tag-at-point)

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
               (or (ffip-project-root) default-directory)))
         ;; find
         (find-command
          (build-find-command
           (let ((str (assoc major-mode hong-grep-files-aliases)))
             (if str (cdr str) "*"))
           (read-directory-name "Directory: ")
           grep-find-ignored-directories
           grep-find-ignored-files))
         ;; total
         (real-command (concat find-command " | xargs " exec)))
    (when (= 0 (shell-command real-command))
      (visit-tags-table "TAGS")
      (message "Generate TAGS Successful!"))))

;;; ========================= gtags ==================================
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
              (setq-local imenu-create-index-function
                          #'ggtags-build-imenu-index)
              (define-key ggtags-mode-map
                (kbd "C-M-.") 'ggtags-find-other-symbol)
              ;; remote file slow in eldoc mode
              (let ((file (buffer-file-name)))
                (when (and file (file-remote-p file))
                  (eldoc-mode -1)))
              )))

(provide 'init-tags)