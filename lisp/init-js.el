(require-package 'js2-mode)

(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq js2-use-font-lock-faces t
      js2-idle-timer-delay 0.1
      js2-indent-on-enter-key t
      js2-auto-indent-p t)

(provide 'init-js)