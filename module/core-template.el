;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'yasnippet)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq yas-verbosity 0)
(setq yas-snippet-dirs
      (list (core/path-concat user-emacs-directory "snippets")))
(setq yas-prompt-functions '(yas-ido-prompt
                             yas-completing-prompt))

;;-------------------------------------------
;;; startup
;;-------------------------------------------
(yas-global-mode 1)

(provide 'core-template)
