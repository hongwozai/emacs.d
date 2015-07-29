;; evil
(require-package 'evil)
(evil-mode 1)

(setq evil-move-cursor-back t)
(dolist (mode '(lisp-mode-hook lisp-interaction-mode-hook
                               emacs-lisp-mode-hook))
  (add-hook mode (lambda () (setq-local evil-move-cursor-back nil))))
;;; initial state change
(dolist (mode '(term-mode gud-mode
                eshell-mode shell-mode
                minibuffer-inactive-mode
                messages-buffer-mode
                special-mode process-menu-mode
                sql-interactive-mode
                flycheck-error-list-mode))
  (evil-set-initial-state mode 'emacs))
(dolist (mode '(diff-mode occur-mode))
  (evil-set-initial-state mode 'motion))
;;; messages-buffer-mode can't set emacs state in emacs start
(kill-buffer "*Messages*")

(define-key evil-visual-state-map (kbd "v") 'er/expand-region)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-0)
(define-key evil-visual-state-map (kbd "SPC") 'avy-goto-word-0)
(define-key evil-normal-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-visual-state-map (kbd "RET") 'avy-goto-line)

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

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "0"   'select-window-0
  "1"   'select-window-1
  "2"   'select-window-2
  "3"   'select-window-3
  "4"   'select-window-4
  "5"   'select-window-5
  "6"   'select-window-6
  "acl" 'avy-copy-line
  "acr" 'avy-copy-region
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
  "oa"  'org-agenda
  "pA"  'hong/add-directory-to-projectile
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
  "xh"  'mark-whole-buffer
  "xo"  'other-window
  "xs" 'save-buffer
  "xvs" 'git-gutter:stage-hunk
  "xvr" 'git-gutter:revert-hunk
  "xv=" 'git-gutter:popup-hunk
  "xz" 'suspend-frame
  "."  'evil-ex)

(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)

(lexical-let ((default-color (cons "#657b83" "#fdf6e3")))
  (add-hook 'post-command-hook
            (lambda ()
              (let ((color (cond ((minibufferp) default-color)
                                 ((evil-insert-state-p) '("#e80000" . "#ffffff"))
                                 ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
                                 ((buffer-modified-p)   '("#006fa0" . "#ffffff"))
                                 (t default-color))))
                (set-face-background 'mode-line (car color))
                (set-face-foreground 'mode-line (cdr color))))))

(provide 'init-evil)
