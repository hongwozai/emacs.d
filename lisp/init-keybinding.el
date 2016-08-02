(require 'evil-leader)
;;; ===================== evil leader custom key =================
(global-evil-leader-mode)
(evil-leader/set-leader ",")
(evil-leader/set-key
  "o"   (lambda () (interactive)
           (let ((split-width-threshold nil)) (org-agenda)))

  ;; avy
  "al"  'avy-goto-line
  "aw"  'avy-goto-word-1

  ;; chinese
  "cd"  'yasdcv-translate-at-point
  "cs"  'hong/translate-brief-at-point
  "c;"  'comment-dwim
  "cc"  'eval-buffer
  "cf"  'eval-defun
  "cr"  'eval-region

  ;; debug
  "dg"  'hydra-gud/body

  ;; file
  "fr"  'ivy-recentf
  "fl"  'counsel-locate
  "fo"  'ido-find-file-other-window
  ;; ffip
  "ff"  'ffip
  "fc"  'ffip-create-project-file
  "fs"  'find-file-in-project-by-selected

  ;; buffer and bookmark
  "bl"  'ibuffer
  "bd"  'dired-jump
  "bo"  'ido-switch-buffer-other-window
  "bs"  'revert-buffer-with-coding-system
  "br"  'revert-buffer
  "bn"  'bookmark-set
  "bj"  'bookmark-jump
  "bm"  'bookmark-bmenu-list

  "sd"  'sudo-edit
  ;; search
  "sa"  'counsel-ag-project
  "sA"  'ag
  "so"  'occur
  "sg"  'rgrep
  "ss"  'counsel-grep-or-swiper

  ;; vc
  "vv"  'vc-next-action
  "vl" 'vc-print-log
  "vL" 'vc-print-root-log
  "vs"  'counsel-git-grep

  ;; window
  "wu"  'winner-undo
  "wc"  'evil-window-delete
  "wv"  'evil-window-vsplit
  "ws"  'evil-window-split
  "wo"  'delete-other-windows
  "wh"  'evil-window-left
  "wl"  'evil-window-right
  "wk"  'evil-window-up
  "wj"  'evil-window-down

  ;; help
  "ha"  'apropos
  "hf"  'counsel-describe-function
  "hv"  'counsel-describe-variable
  "hm"  'describe-mode
  "hk"  'describe-key
  "hi"  'info
  "hp"  'counsel-list-processes
  "hS"  'info-lookup-symbol

  "im"  'counsel-imenu
  "kr"  'counsel-yank-pop
  "xb"  'ivy-switch-buffer
  "xc"  'save-buffers-kill-terminal
  "xe"  'eval-last-sexp
  "xf"  'ido-find-file
  "xk"  '(lambda () (interactive) (kill-buffer (current-buffer)))
  "xs"  'save-buffer
  "xz"  'suspend-frame
  "."   'counsel-M-x)

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
(define-key window-prefix-map (kbd "r")   'evil-window-rotate-downwards)
(define-key window-prefix-map (kbd "SPC") 'hong/window-layout-change)

(global-set-key (kbd "C-w") 'window-prefix-map)
(define-key evil-emacs-state-map (kbd "C-w") 'window-prefix-map)

;;; ========================= help key =====================================
(evil-define-key 'motion help-mode-map (kbd "L") 'help-go-back)
(evil-define-key 'motion help-mode-map (kbd "R") 'help-go-forward)
(evil-define-key 'motion help-mode-map (kbd "o") 'ace-link)
(evil-define-key 'motion Info-mode-map (kbd "L") 'Info-history-back)
(evil-define-key 'motion Info-mode-map (kbd "R") 'Info-history-forward)
(evil-define-key 'motion Info-mode-map (kbd "w") 'evil-forward-word-begin)
(evil-define-key 'motion Info-mode-map (kbd "b") 'evil-backward-word-begin)
(evil-define-key 'motion Info-mode-map (kbd "o") 'ace-link)
(evil-define-key 'motion woman-mode-map (kbd "o") 'ace-link)

(provide 'init-keybinding)
