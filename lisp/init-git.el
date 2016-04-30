;;; magit
(unless (version< emacs-version "24.4")
  (global-set-key (kbd "<f9>") 'magit-status))

;;; git-gutter
(global-git-gutter-mode +1)
(custom-set-variables
 '(git-gutter:handled-backends '(git svn)))

;;; git timemachine
(add-hook 'git-timemachine-mode-hook
          (lambda ()
            (evil-define-key 'motion git-timemachine-mode-map
              (kbd "n") 'git-timemachine-show-next-revision
              (kbd "p") 'git-timemachine-show-previous-revision
              (kbd "q") 'git-timemachine-quit)
            (evil-motion-state)))

(provide 'init-git)
