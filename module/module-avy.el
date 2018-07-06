;;-------------------------------------------
;;; i jump
;;-------------------------------------------
(require-package 'avy)

;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/set-key global
  :state 'native
  (kbd "C-'") 'avy-goto-line)

(core/set-key isearch-mode-map
  :state 'native
  (kbd "C-'") 'avy-isearch)
