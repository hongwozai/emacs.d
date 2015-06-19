;;; ggtags
(require-package 'ggtags)
(add-hook 'prog-mode-hook
          (lambda ()
            (ggtags-mode 1)))

(setq-local eldoc-documentation-function #'ggtags-eldoc-function)
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)
(setq-local hippie-expand-try-functions-list
            (cons 'ggtags-try-complete-tag hippie-expand-try-functions-list))

;;; ctags etags
;; (setq tags-table-list '("."))
(provide 'init-tags)
