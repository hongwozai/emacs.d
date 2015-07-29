;; built-in
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

(require-package 'rainbow-delimiters)
(dolist (hook '(emacs-lisp-mode-hook
                lisp-mode-hook lisp-interaction-mode-hook
                scheme-mode-hook slime-repl-mode-hook))
  (add-hook hook 'rainbow-delimiters-mode))

;; paredit
(require-package 'paredit)
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook       #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)

(provide 'init-pair)
