;; evil
(require-package 'evil)
(evil-mode 1)

;; (define-key evil-normal-state-map (kbd "q") 'delete-window)
(define-key evil-normal-state-map (kbd "C-=") 'er/expand-region)
(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-word-mode)
(define-key evil-visual-state-map (kbd "SPC") 'ace-jump-word-mode)

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "e"  'ido-find-file
  "b"  'helm-mini
  "k"  'kill-this-buffer
  "o"  'org-agenda
  "p"  'helm-projectile
  "cd" 'yasdcv-translate-at-point
  "ff"  'ido-find-file-other-window
  "fb"  'ido-switch-buffer-other-window
  "im" 'helm-imenu
  "ha" 'helm-apropos
  "hs" 'hs-toggle-hiding
  "gf" 'helm-gtags-find-tag
  "gd" 'helm-gtags-dwim
  "sd" 'sudo-edit
  "xc" 'save-buffers-kill-terminal
  "xe" 'eval-last-sexp
  "xs" 'save-buffer
  )
(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(provide 'init-evil)
