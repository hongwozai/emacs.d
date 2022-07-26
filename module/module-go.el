;;-------------------------------------------
;;; go package
;;-------------------------------------------
(module-require "go")
(require-package 'go-mode)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(with-eval-after-load 'go-mode
  (core/set-key go-mode-map
    :state 'normal
    (kbd "M-.") 'godef-jump))

(add-hook 'go-mode-hook #'lsp)
(add-hook 'before-save-hook 'gofmt-before-save)
