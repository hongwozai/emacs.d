;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'find-file-in-project)

;;-------------------------------------------
;;; project
;;-------------------------------------------
(defalias 'core/get-project-root #'ffip-project-root)

(provide 'core-project)
