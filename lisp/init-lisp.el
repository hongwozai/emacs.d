(defvar scheme-program-name "mit-scheme")

(defun hong/run-scheme ()
  "hong's function to run scheme"
  (interactive)
  (split-window-below)
  (other-window 1)
  (run-scheme scheme-program-name)
  (other-window 1))

;; eldoc-mode
(add-to-list 'lisp-interaction-mode-hook 'eldoc-mode)
(add-to-list 'emacs-lisp-mode-hook 'eldoc-mode)

;;; slime
(require-package 'slime)

(provide 'init-lisp)
