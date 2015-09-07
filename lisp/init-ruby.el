(require-package 'inf-ruby)
;;; pry pry-doc method_source
(require-package 'robe)
(require-package 'yari)

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")

(add-hook 'ruby-mode-hook
          (lambda ()
            (robe-mode)
            (push 'ruby-rubylint flycheck-disabled-checkers)
            (push 'company-robe company-backends)
            (setq compile-command "rake ")
            (inf-ruby-minor-mode)))

(autoload 'yari "yari" "" t nil)
(defalias 'ri 'yari)

(provide 'init-ruby)
