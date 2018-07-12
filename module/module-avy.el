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

(core/leader-set-key
  "aa" 'avy-goto-word-0
  "al" 'avy-goto-line
  "aw" 'avy-goto-char-2)
