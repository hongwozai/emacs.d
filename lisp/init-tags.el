;;; ggtags
(require-package 'ggtags)

(eval-after-load 'ggtags
  (progn
    (setq ggtags-update-on-save t)
    (setq-local eldoc-documentation-function #'ggtags-eldoc-function)
    (setq-local imenu-create-index-function #'ggtags-build-imenu-index)))


;;; ctags etags
;; (setq tags-table-list '("."))
(provide 'init-tags)
