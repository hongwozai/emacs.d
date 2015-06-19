;;; eshell
(add-hook 'eshell-mode
          (lambda () (setq pcomplete-cycle-completions nil
                           eshell-save-history-on-exit t
                           eshell-buffer-shorthand t)
            (set-face-attribute 'eshell-prompt nil :foreground "red")))

;;; exec-path-from-shell
(require-package 'exec-path-from-shell)
(exec-path-from-shell-initialize)

;; (getenv "PATH")
;;; (setenv "PATH" ...)
;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)

(provide 'init-shell)
