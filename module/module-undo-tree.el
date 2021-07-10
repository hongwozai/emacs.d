;;; undo-tree
(require-package 'undo-tree)

;;; startup undo tree
(global-undo-tree-mode)
(evil-set-undo-system 'undo-tree)
