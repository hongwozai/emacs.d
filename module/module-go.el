;;-------------------------------------------
;;; go package
;;-------------------------------------------
(module-require "go")
(require-package 'go-mode)
(require-package 'go-eldoc)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(add-hook 'go-mode-hook #'go-eldoc-setup)

(with-eval-after-load 'go-mode
  (core/set-key go-mode-map
    :state 'normal
    (kbd "M-.") 'godef-jump))