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
            (lambda () (push 'company-lsp company-backends)))
  (setq company-lsp-enable-recompletion t)
  (setq company-lsp-async t))
