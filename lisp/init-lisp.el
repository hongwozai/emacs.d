(defvar lisp-common-mode-hook
  '(emacs-lisp-mode-hook lisp-mode-hook lisp-interaction-mode-hook
                         scheme-mode-hook slime-repl-mode-hook
                         inferior-scheme-mode-hook
                         eval-expression-minibuffer-setup-hook))

;;; ===================== pair ==================
;; built-in
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

(require-package 'rainbow-delimiters)

;; paredit
(require-package 'paredit)
(autoload 'enable-paredit-mode "paredit" nil t)

(dolist (hook lisp-common-mode-hook)
  (add-hook hook 'rainbow-delimiters-mode)
  (add-hook hook '(lambda () (setq-local show-paren-style 'expression)))
  (add-hook hook #'enable-paredit-mode))

;;; ===================== misc ==================
;; eldoc-mode
(dolist (hook lisp-common-mode-hook)
  (add-hook hook (lambda () (setq-local eldoc-idle-delay 0) (eldoc-mode)))
  (add-hook hook (lambda () (setq-local evil-move-cursor-back nil))))

;;; pretty symbol
(setq prettify-symbols-alist '(("lambda" . 955)))
(global-prettify-symbols-mode 1)
(add-hook 'scheme-mode-hook
          '(lambda () (setq prettify-symbols-alist '(("lambda" . 955)))))

;;; ===================== lisp ==================
;;; elisp
(require-package 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook
                                     lisp-interaction-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords 'emacs-lisp-mode '("require-package"))
            (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)
            (define-key emacs-lisp-mode-map (kbd "C-c C-f") 'eval-defun)
            (define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)))

(dolist (map '(emacs-lisp-mode-map ielm-mode-map lisp-interaction-mode-map))
  (eval `(evil-define-key 'insert ,map
           (kbd "M-?") 'elisp-slime-nav-describe-elisp-thing-at-point))
  (eval `(evil-define-key 'normal ,map
           (kbd "M-?") 'elisp-slime-nav-describe-elisp-thing-at-point))
  (eval `(evil-define-key 'normal ,map
           (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point))
  (eval `(evil-define-key 'normal ,map
           (kbd "M-,") 'pop-tag-mark))
  )

;;; scheme
(defvar scheme-program-list '("racket" "mit-scheme" "guile"))
(defun hong/run-scheme (program)
  (interactive
   (list (completing-read "scheme-program-name: "
                          scheme-program-list)))
  (save-selected-window
    (select-window (split-window-below))
    (run-scheme program)))
(add-hook 'inferior-scheme-mode-hook 'hong/exit)

;;; slime
(when (executable-find "/usr/bin/sbcl")
  (require-package 'slime)
  (require-package 'slime-company)

  (setq inferior-lisp-program "sbcl")
  (add-hook 'lisp-mode-hook
            (lambda ()
              ;; C-c C-d h clhs
              (when (file-exists-p "~/quicklisp/clhs-use-local.el")
                (load "~/quicklisp/clhs-use-local.el" t))))
  (slime-setup '(slime-fancy slime-company))
  )

(provide 'init-lisp)
