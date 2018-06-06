;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'js2-mode)
(require-package 'json-mode)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq js2-use-font-lock-faces  t
      js2-idle-timer-delay     0.1
      js2-indent-on-enter-key  t
      js2-auto-indent-p        t)

(add-hook 'js2-mode-hook
          (lambda ()
            (core/set-key js2-mode-map
              :state 'normal
              (kbd "za") 'js2-mode-toggle-element
              (kbd "zc") 'js2-mode-hide-element
              (kbd "zo") 'js2-mode-show-element)))
