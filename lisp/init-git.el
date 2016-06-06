;;; with-editor
(autoload 'with-editor-export-editor "with-editor")
(add-hook 'eshell-mode-hook 'with-editor-export-editor)
(add-hook 'shell-mode-hook
          (lambda ()
            (with-editor-export-editor)
            (comint-send-string (get-buffer-process (buffer-name)) "\n")))

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

(defun hong--show-revision ()
  (let (collection)
    (setq collection
          (mapcar (lambda (rev)
                    (cons (concat (substring (nth 0 rev) 0 7)
                                  "|"
                                  (nth 5 rev)
                                  "|"
                                  (nth 6 rev))
                          rev))
                  (git-timemachine--revisions)))
    (ivy-read "commits:"
              collection
              :action (lambda (rev) (git-timemachine-show-revision rev)))))

(defun git-timemachine-selected ()
  (interactive)
  (unless (featurep 'git-timemachine)
    (require 'git-timemachine))
  (git-timemachine--start #'hong--show-revision))

(provide 'init-git)
