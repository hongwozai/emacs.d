;;-------------------------------------------
;;; paredit
;;-------------------------------------------
(require-package 'paredit)
(autoload 'enable-paredit-mode "paredit" nil t)

;;-------------------------------------------
;;; lisp common option
;;-------------------------------------------
(defun lisp-common-edit-hook-func ()
  (enable-paredit-mode)
  (setq-local show-paren-style 'expression))

;;-------------------------------------------
;;; hook
;;-------------------------------------------
(dolist (hook '(emacs-lisp-mode-hook
                ielm-mode-hook
                eval-expression-minibuffer-setup-hook))
  (add-hook hook #'lisp-common-edit-hook-func))

(provide 'core-elisp)
