(when (executable-find "racket")
  (defvar scheme-program-name "racket"))
(add-hook 'scheme-mode-hook 'hong/exit)

(defun hong/run-scheme ()
  "hong's function to run scheme"
  (interactive)
  (let ((swindow (get-buffer-window (buffer-name))))
    (select-window (split-window-below))
    (run-scheme scheme-program-name)
    (select-window swindow)))

;; eldoc-mode
(add-to-list 'lisp-interaction-mode-hook 'eldoc-mode)
(add-to-list 'emacs-lisp-mode-hook 'eldoc-mode)

;;; slime
(require-package 'slime)
(setq inferior-lisp-program "sbcl")
(add-hook 'lisp-mode-hook
          (lambda ()
            ;; C-c C-d h clhs帮助
            (when (file-exists-p "~/quicklisp/clhs-use-local.el")
              (load "~/quicklisp/clhs-use-local.el" t))))
(slime-setup '(slime-fancy slime-company))

(provide 'init-lisp)
