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
  "cm"  'change-compile-command

  ;; error
  "en"  'next-error
  "ep"  'previous-error

  ;; debug
  "db"  'gud-break

  ;; file
  "fr"  'counsel-recentf
  "fl"  'counsel-locate
  "fo"  'ido-find-file-other-window
  ;; ffip
  "ff"  'ffip-current-directory
  "fc"  'ffip-create-project-file
  "fs"  'find-file-in-project-by-selected

  ;; gtags
  "gc"  'counsel-gtags-create-tags
  "gd"  'counsel-gtags-find-definition
  "gu"  'counsel-gtags-update-tags
  "gr"  'counsel-gtags-find-reference
  "gs"  'counsel-gtags-find-symbol

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
  "sa"  'counsel-ag
  "sA"  'ag
  "so"  'occur
  "sg"  'rgrep
  "ss"  'counsel-grep-or-swiper

  ;; line
  "n"   'linum-mode

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
  "ww"  'evil-window-next
  "w SPC" 'hong/window-layout-change

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
  "xf"  'hong/ido-find-file-with-use-ffip
  "xk"  '(lambda () (interactive) (kill-buffer (current-buffer)))
  "xs"  'save-buffer
  "xz"  'suspend-frame
  "."   'counsel-M-x)

;;; ============================ buffer key ================================
(global-set-key (kbd "M-h") 'previous-buffer)
(global-set-key (kbd "M-l") 'next-buffer)

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


(global-set-key (kbd "C-S-<left>")
                (lambda () (interactive) (hong-window-resize 'left)))
(global-set-key (kbd "C-S-<right>")
                (lambda () (interactive) (hong-window-resize 'right)))
(global-set-key (kbd "C-S-<up>")
                (lambda () (interactive) (hong-window-resize 'above)))
(global-set-key (kbd "C-S-<down>")
                (lambda () (interactive) (hong-window-resize 'below)))

(global-set-key (kbd "C-x C-b") 'ibuffer)

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

;;; keybindings
(global-set-key (kbd "<f2>") 'eshell)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "<f9>") 'magit-status)

(global-set-key (kbd "C-x C-f") 'ido-find-file)
(global-set-key (kbd "C-s") 'counsel-grep-or-swiper)

(global-set-key (kbd "M-[") 'multi-term-prev)
(global-set-key (kbd "M-]") 'multi-term-next)

;;; C-p
(define-key evil-normal-state-map (kbd "C-p") 'ffip-current-directory)

(provide 'init-keybinding)
