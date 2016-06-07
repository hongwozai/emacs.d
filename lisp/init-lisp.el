(defvar lisp-common-mode-hook
  '(emacs-lisp-mode-hook lisp-mode-hook lisp-interaction-mode-hook
                         scheme-mode-hook slime-repl-mode-hook
                         inferior-scheme-mode-hook ielm-mode-hook
                         eval-expression-minibuffer-setup-hook
                         clojure-mode-hook cider-mode-hook))

;;; ========================== pair ===============================
;; paredit
(autoload 'enable-paredit-mode "paredit" nil t)

(dolist (hook lisp-common-mode-hook)
  (add-hook hook '(lambda () (setq-local show-paren-style 'expression)))
  (add-hook hook #'evil-paredit-mode)
  (add-hook hook #'enable-paredit-mode)

  ;; rainbow-delimiters
  (add-hook hook #'rainbow-delimiters-mode))

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
(dolist (hook '(emacs-lisp-mode-hook lisp-interaction-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (font-lock-add-keywords 'emacs-lisp-mode
                                    '("require-package" "maybe-require"))
            (define-key emacs-lisp-mode-map (kbd "C-c C-c") 'eval-buffer)
            (define-key emacs-lisp-mode-map (kbd "C-c C-f") 'eval-defun)
            (define-key emacs-lisp-mode-map (kbd "C-c C-r") 'eval-region)))

(dolist (map (list emacs-lisp-mode-map
                   lisp-interaction-mode-map))
  (evil-define-key 'insert map
     (kbd "M-?") 'elisp-slime-nav-describe-elisp-thing-at-point)
  (evil-define-key 'normal map
     (kbd "M-?") 'elisp-slime-nav-describe-elisp-thing-at-point
     (kbd "M-.") 'elisp-slime-nav-find-elisp-thing-at-point
     (kbd "M-,") 'pop-tag-mark)
  )

(provide 'init-lisp)
