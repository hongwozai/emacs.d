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

;;; only isearch could be use avy-isearch
(define-key evil-normal-state-map (kbd "/") 'isearch-forward-regexp)
(define-key evil-normal-state-map (kbd "?") 'isearch-backward-regexp)
(define-key evil-motion-state-map (kbd "/") 'isearch-forward-regexp)
(define-key evil-motion-state-map (kbd "?") 'isearch-backward-regexp)

(define-key isearch-mode-map (kbd "C-'") 'avy-isearch)