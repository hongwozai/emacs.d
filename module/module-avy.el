;;-------------------------------------------
;;; i jump
;;-------------------------------------------
(require-package 'avy)

;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/leader-set-key
  "aa" 'avy-goto-word-0
  "al" 'avy-goto-line
  "aw" 'avy-goto-char-2
  "am" 'avy-move-line
  "ac" 'avy-copy-line
  )

