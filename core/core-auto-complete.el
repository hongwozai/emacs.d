;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'company)
(add-hook 'after-init-hook #'global-company-mode)

;;-------------------------------------------
;;; delay load config
;;-------------------------------------------
(with-eval-after-load 'company
  ;; can't work with TRAMP
  (setq company-backends
        (delete 'company-ropemacs company-backends))
  (setq company-idle-delay                 0.2)
  (setq company-minimum-prefix-length      2)
  (setq company-tooltip-flip-when-above    t)
  (setq company-tooltip-align-annotations  t)
  (setq company-show-numbers               t)
  (setq company-clang-insert-arguments     t)
  (setq company-gtags-insert-arguments     t)
  (setq company-etags-ignore-case          nil)

  (setq company-global-modes
        '(not gud-mode shell-mode eshell-mode term-mode))
  )

(provide 'core-auto-complete)
