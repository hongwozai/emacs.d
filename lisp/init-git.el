(require-package 'magit)
(global-set-key (kbd "<f9>") 'magit-status)

;;; git-gutter
(require-package 'git-gutter)

(global-git-gutter-mode +1)
(git-gutter:linum-setup)
(custom-set-variables
 '(git-gutter:handled-backends '(git svn)))

(global-set-key (kbd "C-x C-g") 'git-gutter:toggle)
(global-set-key (kbd "C-x v =") 'git-gutter:popup-hunk)
;; Jump to next/previous hunk
(global-set-key (kbd "C-x p") 'git-gutter:previous-hunk)
(global-set-key (kbd "C-x n") 'git-gutter:next-hunk)
;; Stage current hunk
(global-set-key (kbd "C-x v s") 'git-gutter:stage-hunk)
;; Revert current hunk
(global-set-key (kbd "C-x v r") 'git-gutter:revert-hunk)

(provide 'init-git)
