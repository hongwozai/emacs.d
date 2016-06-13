;; bookmark
(setq bookmark-save-flag 1)
(evil-define-key 'motion bookmark-bmenu-mode-map
  (kbd "RET") 'bookmark-bmenu-this-window)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; find file in project
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; ignore hidden file
(with-eval-after-load 'find-file-in-project
  (setq ffip-project-file '(".svn" ".git" ".hg" "Makefile"
                            "makefile" ".dir-locals.el"))
  (add-to-list 'ffip-prune-patterns "*/.*/*"))

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
              (evil-local-set-key 'normal (kbd "C-]") 'ggtags-find-definition)
              (evil-local-set-key 'normal (kbd "C-t") 'ggtags-prev-mark)
              (define-key ggtags-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)

              ;; remote file slow in eldoc mode
              (let ((file (buffer-file-name)))
                (when (and file (file-remote-p file))
                  (eldoc-mode -1)))
              ))
  )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; project operation(tags, compile)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun project--get-root (&optional iscurr)
  "Get project root path."
  (or (ffip-project-root)
      (if iscurr default-directory)))

(defun project-regenerate-tags ()
  "Regenerate etags TAGS"
  (interactive)
  (let* ((command "find -L . '(' -path '*/.*' ')' -prune -o -type f | xargs etags -o TAGS")
         (minibuffer-setup-hook
          (append minibuffer-setup-hook
                  (list (lambda ()
                          (move-beginning-of-line 1)
                          (forward-char 9)))))
         (real-command (progn
                         (message "Create shell commanp")
                         (read-shell-command "Command: " command)))
         )
    (when (= 0 (shell-command command))
      (visit-tags-table "TAGS")
      (message "Generate TAGS Successful!"))))

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