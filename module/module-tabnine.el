;;-------------------------------------------
;;; tabnine
;;-------------------------------------------
(module-require-manual)
(require-package 'company-tabnine)

;;; slience
(defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
  (let ((company-message-func (ad-get-arg 0)))
    (when (and company-message-func
               (stringp (funcall company-message-func)))
      (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
        ad-do-it))))

;;; default use
(with-eval-after-load 'company
  (push #'company-tabnine company-backends))

;;; before lsp
(advice-add 'lsp
            :around (lambda (orig-fun &rest r)
                      (apply orig-fun r)
                      (add-to-list 'company-backends 'company-tabnine)))