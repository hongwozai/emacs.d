;;; ===================== evil leader custom key =================
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "o"   'org-agenda

  ;; avy
  "al"  'avy-goto-line
  "aw"  'avy-goto-word-1

  ;; chinese
  "cd"  'yasdcv-translate-at-point
  "cs"  'hong/translate-brief-at-point

  ;; file
  "fr"  'ivy-recentf
  "fl"  'counsel-locate
  "fp"  'ffip
  "fo"  'ido-find-file-other-window

  ;; gtags
  "gc"  'ggtags-create-tags
  "gr"  'ggtags-find-reference

  ;; buffer and bookmark
  "bl"  'ibuffer
  "bd"  'dired-jump
  "bo"  'ido-switch-buffer-other-window
  "bs"  'revert-buffer-with-coding-system
  "bn"  'bookmark-set
  "bj"  'bookmark-jump
  "bm"  'bookmark-bmenu-list

  "sd"  'sudo-edit
  ;; search
  "sa"  'counsel-ag
  "sA"  'ag
  "so"  'occur
  "sg"  'rgrep
  "sG"  'counsel-git-grep
  "ss"  'counsel-grep-or-swiper

  ;; window
  "wu"  'winner-undo

  ;; help
  "ha"  'apropos
  "hf"  'counsel-describe-function
  "hv"  'counsel-describe-variable
  "hm"  'describe-mode
  "hk"  'describe-key
  "hi"  'Info
  "hp"  'counsel-list-processes
  "hS"  'counsel-info-lookup-symbol

  "im"  'imenu
  "kr"  'counsel-yank-pop
  "mf"  'mark-defun
  "xb"  'ido-switch-buffer
  "xc"  'save-buffers-kill-terminal
  "xe"  'eval-last-sexp
  "xf"  'ido-find-file
  "xk"  '(lambda () (interactive) (kill-buffer (current-buffer)))
  "xs"  'save-buffer
  "xz"  'suspend-frame)

(evil-leader/set-key-for-mode 'scheme-mode  "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode    "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'clojure-mode "xe" 'cider-eval-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)
(evil-leader/set-key-for-mode 'ruby-mode "cr" 'ruby-send-region)

;;; ============================ window key ================================
(define-prefix-command 'window-prefix-map)
(define-key window-prefix-map (kbd "h")   'evil-window-left)
(define-key window-prefix-map (kbd "j")   'evil-window-down)
(define-key window-prefix-map (kbd "k")   'evil-window-up)
(define-key window-prefix-map (kbd "l")   'evil-window-right)
(define-key window-prefix-map (kbd "c")   'evil-window-delete)
(define-key window-prefix-map (kbd "o")   'delete-other-windows)
(define-key window-prefix-map (kbd "s")   'evil-window-split)
(define-key window-prefix-map (kbd "v")   'evil-window-vsplit)
(define-key window-prefix-map (kbd "v")   'evil-window-rotate-downwards)
(define-key window-prefix-map (kbd "SPC") 'hong/window-layout-change)

(global-set-key (kbd "C-w") 'window-prefix-map)
(define-key evil-emacs-state-map (kbd "C-w") 'window-prefix-map)

;;; ========================= help key =====================================
(evil-define-key 'motion help-mode-map (kbd "L") 'help-go-back)
(evil-define-key 'motion help-mode-map (kbd "R") 'help-go-forward)
(evil-define-key 'motion Info-mode-map (kbd "L") 'Info-history-back)
(evil-define-key 'motion Info-mode-map (kbd "R") 'Info-history-forward)
(evil-define-key 'motion Info-mode-map (kbd "w") 'evil-forward-word-begin)
(evil-define-key 'motion Info-mode-map (kbd "b") 'evil-backward-word-begin)

(provide 'init-keybinding)
