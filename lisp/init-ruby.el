(require-package 'inf-ruby)
(require-package 'robe)
(require-package 'yari)

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
;; (setq ruby-use-encoding-map nil)

(add-hook 'ruby-mode-hook
          (lambda ()
            (robe-mode)
            (push 'company-robe company-backends)
            (setq compile-command "rake ")))

;; doc look up
(autoload 'yari-helm "yari" "" t nil)
(autoload 'yari "yari" "" t nil)
(defalias 'ri 'yari-helm)

(provide 'init-ruby)
