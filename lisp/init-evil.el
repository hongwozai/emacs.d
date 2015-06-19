;; evil
(require-package 'evil)
(evil-mode 1)

(setq evil-move-cursor-back nil)

;; (define-key evil-normal-state-map (kbd "q") 'delete-window)
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-1)
(define-key evil-visual-state-map (kbd "SPC") 'avy-goto-word-1)
(define-key evil-normal-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-visual-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-normal-state-map (kbd "K") 'helm-man-woman)

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "e"  'ido-find-file
  "d"  'dired
  "b"  'helm-mini
  "k"  'kill-this-buffer
  "o"  'org-agenda
  "p"  'helm-projectile
  "m"  'helm-pp-bookmarks
  "cd" 'yasdcv-translate-at-point
  "ff"  'ido-find-file-other-window
  "fb"  'ido-switch-buffer-other-window
  "fl"  'flycheck-list-errors
  "im" 'helm-imenu
  "ha" 'helm-apropos
  "hs" 'hs-toggle-hiding
  "sd" 'sudo-edit
  "xc" 'save-buffers-kill-terminal
  "xe" 'eval-last-sexp
  "xs" 'save-buffer
  )
(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)

(require-package 'evil-matchit)
(global-evil-matchit-mode 1)

(provide 'init-evil)
