;; ;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-check-syntax-automatically '(save mode-enable))

(setq flycheck-emacs-lisp-load-path 'inherit)
(setq flycheck-clang-language-standard "c99")

(defun hong/gtk-include-path ()
  (let* ((cmd "pkg-config --cflags --libs gtk+-2.0")
         (gtk (split-string
              (shell-command-to-string cmd))))
    (mapcar #'(lambda (x) (substring x 2))
            (remove-if #'(lambda (x) (not (eql (elt x 1) ?I))) gtk))))

(setq flycheck-clang-include-path
      `( ,@(hong/gtk-include-path)
         "/usr/include"
         "include" "../include"
         "inc" "../inc"))
(provide 'init-flycheck)
