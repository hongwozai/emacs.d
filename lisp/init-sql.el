;;; indent
(require-package 'sql-indent)
(eval-after-load "sql"
  '(load-library "sql-indent"))

;;; sql information
(setq sql-product 'mysql)
(setq sql-server  "localhost")
(setq sql-user    "root")
(setq sql-port     3306)

;;; M-x sql-mysql login
(setq sql-mysql-login-params '(user password))

;;; mysql exit autoclose
(add-hook 'sql-interactive-mode-hook 'hong/exit)

(provide 'init-sql)
