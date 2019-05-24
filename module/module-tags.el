;;-------------------------------------------
;;; package
;;-------------------------------------------
(module-require "gtags")
(require 'gxref)

;;-------------------------------------------
;;; projectile support
;;-------------------------------------------
(defun projectile-regenerate-gxref-gtags ()
  (interactive)
  (let* ((isctags (yes-or-no-p "Use Ctags Backend?")))
    (if isctags
        (projectile-regenerate-tags)
      (gxref-create-db (projectile-project-root)))))

(define-key projectile-command-map
  (kbd "R") #'projectile-regenerate-gxref-gtags)
;;-------------------------------------------
;;; xref config
;;-------------------------------------------
(add-to-list 'xref-backend-functions 'gxref-xref-backend)

;;; gtags config
(setenv "GTAGSFORCECPP" "1")
;; (setq gxref-create-db-cmd "gtags --gtagslabel=ctags")
