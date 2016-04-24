(defvar lisp-common-mode-hook
  '(emacs-lisp-mode-hook lisp-mode-hook lisp-interaction-mode-hook
                         scheme-mode-hook slime-repl-mode-hook
                         inferior-scheme-mode-hook ielm-mode-hook
                         eval-expression-minibuffer-setup-hook
                         clojure-mode-hook cider-mode-hook))

;;; ========================== pair ===============================
;; built-in
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

;; paredit
(autoload 'enable-paredit-mode "paredit" nil t)

(dolist (hook lisp-common-mode-hook)
  (add-hook hook '(lambda () (setq-local show-paren-style 'expression)))
  (add-hook hook #'enable-paredit-mode))

;;; ========================== misc ===============================
;; eldoc-mode
(dolist (hook lisp-common-mode-hook)
  (add-hook hook (lambda () (setq-local eldoc-idle-delay 0) (eldoc-mode)))
  (add-hook hook (lambda () (setq-local evil-move-cursor-back nil))))

;;; pretty symbol
(unless (version< emacs-version "24.4")
 (setq prettify-symbols-alist '(("lambda" . 955)))
 (global-prettify-symbols-mode 1)
 (add-hook 'scheme-mode-hook
           '(lambda () (setq prettify-symbols-alist '(("lambda" . 955)))))
 )

;;; ========================= elisp ================================
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook
                                     lisp-interaction-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords 'emacs-lisp-mode '("require-package"))
            (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)
            (define-key emacs-lisp-mode-map (kbd "C-c C-f") 'eval-defun)
            (define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)
            (define-key emacs-lisp-mode-map (kbd "<f3>") (hong-pop-func 'ielm))))

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

;;; ======================== scheme ================================
(add-hook 'scheme-mode-hook
          (lambda ()
            (define-key scheme-mode-map (kbd "<f3>")
              (hong-pop-func
               (lambda () (run-scheme (read-string "Executable: " "guile")))))))
(add-hook 'inferior-scheme-mode-hook 'hong/exit)
;;; ====================== common lisp =============================
(when (executable-find "sbcl")
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

;;;======================== clojure ===============================
(setq cider-repl-result-prefix ";; =>")
(setq cider-repl-use-pretty-printing t)
(add-hook 'cider-mode-hook #'eldoc-mode)

(provide 'init-lisp)
