;;-------------------------------------------
;;; use ibuffer
;;-------------------------------------------
(with-eval-after-load 'ibuffer
  (require 'ibuf-ext)
  (add-to-list 'ibuffer-never-show-predicates "^\\*"))

;;-------------------------------------------
;;; key command
;;-------------------------------------------
(defalias 'sw 'switch-to-buffer)

(provide 'core-buffer)
