;;-------------------------------------------
;;; eshell prompt
;;-------------------------------------------
(require-package 'eshell-prompt-extras)

(unless (version< emacs-version "24.4")
  (with-eval-after-load "esh-opt"
    (autoload 'epe-theme-multiline-with-status "eshell-prompt-extras")
    (setq eshell-highlight-prompt nil
          eshell-prompt-function 'epe-theme-multiline-with-status)
    ))