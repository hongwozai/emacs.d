;;-------------------------------------------
;;; lsp package
;;-------------------------------------------
(require-package 'lsp-mode)
(require-package 'company-lsp)

;;-------------------------------------------
;;; imenu
;;-------------------------------------------
(autoload 'lsp-enable-imenu "lsp-imenu")
(autoload 'lsp-prog-major-mode-enable "lsp-mode")

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq lsp-message-project-root-warning t)

;;; hook
(add-hook 'prog-major-mode #'lsp-prog-major-mode-enable)
(add-hook 'lsp-after-open-hook #'lsp-enable-imenu)

;;; company
(with-eval-after-load "company"
  (add-hook 'prog-mode-hook
            (lambda ()
              (setq-local company-backends
                          (cons 'company-lsp company-backends))))
  (setq company-lsp-enable-recompletion t)
  (setq company-lsp-async t))

;;; cancel warning
(with-eval-after-load "lsp-mode"
  (advice-add 'lsp-warn
              :around (lambda (orig-func &rest r)
                        (message (apply #'format-message r)))))
