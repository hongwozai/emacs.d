;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-emacs-lisp-load-path 'inherit)

(defun hong/qt4-include-path ()
  (mapcar (lambda (x) (concat "/usr/include/qt4/" x "/"))
          (delete '".." (directory-files "/usr/include/qt4"))))

(setq flycheck-clang-include-path (hong/qt4-include-path))

(provide 'init-flycheck)
