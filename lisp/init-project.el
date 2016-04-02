;; bookmark
(setq bookmark-save-flag 1)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ignore hidden file
(require-package 'find-file-in-project)
(eval-after-load 'find-file-in-project
  '(progn
     (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                               "makefile" ".dir-local.el"))
     (add-to-list 'ffip-prune-patterns "*/.*/*")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; gtags
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

(provide 'init-project)