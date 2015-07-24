(require-package 'inf-ruby)
(require-package 'robe)
(require-package 'yari)

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")

(add-hook 'ruby-mode-hook
          (lambda ()
            (robo-mode)
            (push 'company-robe company-backends)
            (setq compile-command "rake ")))

(autoload 'yari "yari" "" t nil)
(provide 'init-ruby)
