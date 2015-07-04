;;; sql information

(setq sql-connection-alist
      '((pool-a
         (sql-product 'mysql)
         (sql-server  "localhost")
         (sql-user    "root")
         (sql-password "root")
         (sql-database "mysql")
         (sql-port     3306))
         ))
(defun sql-connect-prset (name)
  (eval `(let ,(cdr (assoc name sql-connection-alist))
           (flet ((sql-get-login (&rest what)))
             (sql-product-interactive sql-product)))))

(defun mysql ()
  (interactive)
  (sql-connect-preset 'pool-a))

;;; M-x sql-mysql login
(setq sql-mysql-login-params '(user password))
;; (setq sql-mysql-options nil)

(provide 'init-sql)
