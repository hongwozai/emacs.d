;;; sql information
;; (setq sql-mysql-options '("-C" "-f" "-t" "-n")) ; for windows
(setq sql-user "root")
(setq sql-password "")

(setq sql-connection-alist
      '((pool-a
         (sql-product 'mysql)
         (sql-server  "localhost")
         (sql-user    "root")
         (sql-password "root")
         (sql-database "mysql")
         (sql-port     3306))
         ))
(provide 'init-sql)
