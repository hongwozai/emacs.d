;; control flatten
(setq imenu-flatter-enable t)

(defun imenu-flatter--flatten-list (prefix lst)
  (let* ((-name (car lst))
         (name (if prefix (format "%s/%s" prefix -name)
                 -name)))
    (mapcan
     (lambda (item)
       (if (consp (cdr item))
           (imenu-flatter--flatten-list name item)
         (list (cons (format "%s/%s" name (car item))
                     (cdr item)))))
     (cdr lst))))

;; work function
;; only class/variable, free other
(defun imenu-flatter-flatten (index)
  (let ((items '()))
    (dolist (origin index (reverse items))
      (cond
       ((member (car origin) '("Class" "Method" "Function"))
        (setq items
              (append (imenu-flatter--flatten-list nil origin)
                      items)))
       ((consp (cdr origin)))
       (t (push origin items))))))

;; advice function
(defun imenu-flatter-with-function (fn &rest args)
  (if (and imenu-flatter-enable
           (member major-mode '(python-mode python-ts-mode)))
      (imenu-flatter-flatten (apply fn args))
    (apply fn args)))

;; biu!
(advice-add 'imenu--make-index-alist :around
            'imenu-flatter-with-function)

(provide 'imenu-flatter)