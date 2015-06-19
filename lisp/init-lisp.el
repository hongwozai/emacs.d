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
(setq inferior-lisp-program "sbcl")
(add-hook 'lisp-mode-hook
          (lambda ()
            (let ((helper (expand-file-name "~/quicklisp/slime-helper.el")))
              (if (file-exists-p helper)
                  (load helper)))
            ;; C-c C-d h clhs帮助
            (load "/home/lm/quicklisp/clhs-use-local.el" t)
            (slime-setup '(slime-company))
            ))

;;; don't display loading message
;; (slime-setup '(slime-fancy))

(provide 'init-lisp)
