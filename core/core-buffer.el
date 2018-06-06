;;-------------------------------------------
;;; use ibuffer
;;-------------------------------------------
(require 'ibuf-ext)
(require 'ibuffer)
(with-eval-after-load 'ibuffer
  (add-to-list 'ibuffer-never-show-predicates "^\\*"))

(provide 'core-buffer)
