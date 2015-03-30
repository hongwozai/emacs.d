;; evil
(require-package 'evil)
(evil-mode 1)

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "e"  'ido-find-file
  "b"  'helm-mini
  "k"  'kill-this-buffer
  "im" 'helm-imenu
  "ha" 'helm-apropos
  "hs" 'hs-toggle-hiding
  "gf" 'helm-gtags-find-tag
  "gd" 'helm-gtags-dwim
  "sd" 'sudo-edit
  "sr" 'sr-speedbar-toggle
  )
;; evil-leader/set-key-for-mode
(provide 'init-evil)
