;; evil
(require-package 'evil)
(evil-mode 1)
;;; =================== evil configure =====================
(setq evil-move-cursor-back t)

;;; initial state change
(dolist (mode '(term-mode
                eshell-mode shell-mode gud-mode
                minibuffer-inactive-mode
                messages-buffer-mode bs-mode
                special-mode process-menu-mode
                sql-interactive-mode
                inferior-python-mode
                anaconda-nav-mode ibuffer-mode
                comint-mode image-mode
                flycheck-error-list-mode))
  (evil-set-initial-state mode 'emacs))

(dolist (mode '(diff-mode occur-mode yari-mode))
  (evil-set-initial-state mode 'motion))
;;; messages-buffer-mode can't set emacs state in emacs start
(kill-buffer "*Messages*")

(define-key evil-normal-state-map (kbd "gF") 'ff-find-related-file)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)

;;; ======================== evil plugin ==========================
;;; evil-anzu
(require-package 'evil-anzu)
(with-eval-after-load 'evil
  (require 'evil-anzu)
  (global-anzu-mode))
(set-face-foreground 'anzu-mode-line "gold")

;;; evil surround
(require-package 'evil-surround)
(global-evil-surround-mode 1)

;;; evil jumper
;;; C-i forward jump C-o backward jump
(require-package 'evil-jumper)
(global-evil-jumper-mode)

;;; evil escape
(require-package 'evil-escape)
(setq-default evil-escape-key-sequence "jk")
(evil-escape-mode)

;;; evil matchit
(require-package 'evil-matchit)
(global-evil-matchit-mode 1)

;;; ===================== evil leader custom key =================
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "al"  'avy-goto-line
  "aw"  'avy-goto-word-0
  "bl"  'ibuffer
  "bm"  'bookmark-bmenu-list
  "bs"  'bookmark-set
  "cd"  'yasdcv-translate-at-point
  "dj"  'dired-jump
  "en"  'next-error
  "ep"  'previous-error
  "fl"  'flycheck-list-errors
  "ff"  'ffip
  "fn"  'flycheck-next-error
  "fp"  'flycheck-previous-error
  "gc"  'ggtags-create-tags
  "gd"  'ggtags-find-definition
  "gt"  'ggtags-find-tag-dwim
  "gr"  'ggtags-find-reference
  "gn"  'ggtags-next-mark
  "gp"  'ggtags-prev-mark
  "hf"  'describe-function
  "hv"  'describe-variable
  "hk"  'describe-key
  "hm"  'describe-mode
  "hi"  'info
  "hs"  'hs-toggle-hiding
  "im"  'imenu
  "kb"  'kill-this-buffer
  "kw"  'kill-buffer-and-window
  "mf"  'mark-defun
  "mp"  'mark-paragraph
  "mb"  'mark-whole-buffer
  "o"  'org-agenda
  "pf"  'projectile-find-file
  "pb"  'projectile-switch-to-buffer
  "pd"  'projectile-dired
  "pe"  'projectile-recentf
  "pk"  'projectile-kill-buffers
  "pp"  'projectile-switch-project
  "pn"  'hong/new-project
  "pR"  'projectile-regenerate-tags
  "po"  'projectile-multi-occur
  "ps"  'projectile-ag
  "pS"  'projectile-save-project-buffers
  "pr"  'projectile-remove-known-project
  "sc"  'shell-command
  "sd" 'sudo-edit
  "sr" 'sr-speedbar-toggle
  "sa" 'ag
  "so" 'occur
  "wc" 'evil-window-delete
  "ws" 'evil-window-split
  "wv" 'evil-window-vsplit
  "wg" 'golden-ratio
  "wh" 'evil-window-left
  "wj" 'evil-window-down
  "wk" 'evil-window-up
  "wl" 'evil-window-right
  "wo" 'delete-other-windows
  "wu" 'winner-undo
  "x4f"  'ido-find-file-other-window
  "x4b"  'ido-switch-buffer-other-window
  "xb"  'ido-switch-buffer
  "xc" 'save-buffers-kill-terminal
  "xe" 'eval-last-sexp
  "xf"  'ido-find-file
  "xk"  'ido-kill-buffer
  "xo"  'other-window
  "xs" 'save-buffer
  "xvs" 'git-gutter:stage-hunk
  "xvr" 'git-gutter:revert-hunk
  "xv=" 'git-gutter:popup-hunk
  "xz" 'suspend-frame
  "z"  'evil-emacs-state
  "."  'evil-ex)

(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)
(evil-leader/set-key-for-mode 'ruby-mode "cr" 'ruby-send-region)

;;; ===================== self ===========================
;;; evil ex cmd
(evil-ex-define-cmd "ls" 'ibuffer)

;;; evil make compatiable
(evil-define-command evil-make (arg)
  (interactive "<sh>")
  (if (not arg)
      (compile "make")
    (compile (concat "make " arg))))

;;; evil *, # search symbol not word
(define-key evil-motion-state-map "*"
  (lambda (count) (interactive "P") (evil-search-word-forward count t)))
(define-key evil-motion-state-map "#"
  (lambda (count) (interactive "P") (evil-search-word-backward count t)))

(provide 'init-evil)
