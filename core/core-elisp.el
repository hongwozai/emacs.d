;;-------------------------------------------
;;; lisp common option
;;-------------------------------------------
(defvar lisp-common-mode-hook
  '(emacs-lisp-mode-hook
    lisp-mode-hook
    lisp-interaction-mode-hook
    scheme-mode-hook
    slime-repl-mode-hook
    inferior-scheme-mode-hook
    ielm-mode-hook
    eval-expression-minibuffer-setup-hook
    clojure-mode-hook
    cider-mode-hook))

;;-------------------------------------------
;;; paredit
;;-------------------------------------------
(require-package 'paredit)
(autoload 'enable-paredit-mode "paredit" nil t)

;;-------------------------------------------
;;; lisp common option
;;-------------------------------------------
(dolist (hook lisp-common-mode-hook)
  (add-hook hook #'enable-paredit-mode)
  (add-hook hook
            (lambda ()
              (setq-local show-paren-style 'expression))))


(provide 'core-elisp)
