(require-package 'bash-completion)
;;; bash-completion *shell*
(autoload 'bash-completion-dynamic-complete 
  "bash-completion"
  "BASH completion hook")
(add-hook 'shell-dynamic-complete-functions
          'bash-completion-dynamic-complete)

;;; exec-path-from-shell
;; (getenv "PATH")
;;; (setenv "PATH" ...)
;;; shotcuts key
(global-set-key (kbd "<f2>") 'eshell)

(provide 'init-shell)
