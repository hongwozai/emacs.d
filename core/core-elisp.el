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
  (core/set-key paredit-mode-map
    :state 'native
    (kbd "M-?") 'xref-find-references)
  (setq-local show-paren-style 'expression))

;;-------------------------------------------
;;; hook
;;-------------------------------------------
(dolist (hook '(emacs-lisp-mode-hook
                ielm-mode-hook
                eval-expression-minibuffer-setup-hook
                scheme-mode-hook))
  (add-hook hook #'lisp-common-edit-hook-func))

;;-------------------------------------------
;;; emacs lisp
;;-------------------------------------------
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (setq flycheck-emacs-lisp-load-path 'inherit)
            (add-to-list 'flycheck-disabled-checkers
                         'emacs-lisp-checkdoc)))

;;; key
(core/leader-set-key-for-mode
  'emacs-lisp-mode
  "xe" 'eval-last-sexp
  "cf" 'eval-defun
  "cc" 'eval-buffer)

(provide 'core-elisp)
