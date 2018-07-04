;;-------------------------------------------
;;; package
;;-------------------------------------------
(module-require "gtags")
(require 'gxref)

;;-------------------------------------------
;;; xref config
;;-------------------------------------------
(add-to-list 'xref-backend-functions 'gxref-xref-backend)

;;; gtags config
(setenv "GTAGSFORCECPP" "1")
;; (setq gxref-create-db-cmd "gtags --gtagslabel=ctags")
