;; ;; flycheck
(require-package 'flycheck)
;; (require-package 'flycheck-pyflakes)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-check-syntax-automatically '(save mode-enable))

(setq flycheck-emacs-lisp-load-path 'inherit)

(defun hong/gtk-include-path ()
  (let* ((cmd "pkg-config --cflags gtk+-3.0")
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
