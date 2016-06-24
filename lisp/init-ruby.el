(require-package 'inf-ruby)
;;; pry pry-doc method_source
(require-package 'robe)
(require-package 'yari)

(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")

(add-hook 'ruby-mode-hook
          (lambda ()
            (robe-mode)
            (push 'ruby-rubylint flycheck-disabled-checkers)
            (setq-local company-backends (cons 'company-robe company-backends))
            (setq-local compile-command "rake ")
            (inf-ruby-minor-mode)
            ))

;;; key
(evil-leader/set-key-for-mode 'ruby-mode "cr" 'ruby-send-region)

;;; yari
(autoload 'yari "yari" "" t nil)
(defalias 'ri 'yari)

;;; inf-ruby
(add-hook 'inf-ruby-mode-hook #'hong/exit)

(provide 'init-ruby)
