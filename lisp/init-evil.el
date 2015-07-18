;; evil
(require-package 'evil)
(evil-mode 1)

(setq evil-move-cursor-back t)
(dolist (mode '(lisp-mode-hook lisp-interaction-mode-hook
                               emacs-lisp-mode-hook))
  (add-hook mode (lambda () (setq-local evil-move-cursor-back nil))))

(dolist (mode '(term-mode gud-mode
                eshell-mode shell-mode
                minibuffer-inactive-mode
                messages-buffer-mode
                special-mode process-menu-mode
                sql-interactive-mode
                flycheck-error-list-mode))
  (evil-set-initial-state mode 'emacs))
;;; messages-buffer-mode can't emacs state in emacs start
(kill-buffer "*Messages*")

;; (evil-declare-key 'normal org-mode-map)
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-0)
(define-key evil-visual-state-map (kbd "SPC") 'avy-goto-word-0)
(define-key evil-normal-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-visual-state-map (kbd "RET") 'avy-goto-line)

;;; evil surround
(require-package 'evil-surround)
(global-evil-surround-mode 1)

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "bl"  'ibuffer
  "bb"  'bookmark-bmenu-list
  "bs"  'bookmark-set
  "cd"  'yasdcv-translate-at-point
  "dj"  'dired-jump
  "en"  'next-error
  "ep"  'previous-error
  "fl"  'flycheck-list-errors
  "gd"  'ggtags-find-definition
  "gt"  'ggtags-find-tag-dwim
  "gr"  'ggtags-find-reference
  "gn"  'ggtags-next-mark
  "gp"  'ggtags-prev-mark
  "ha"  'helm-apropos
  "hs"  'hs-toggle-hiding
  "im"  'idomenu
  "kb"  'kill-this-buffer
  "mf"  'mark-defun
  "pA"  'hong/add-directory-to-projectile
  "pf"  'ffip
  ;; "pf"  'projectile-find-file
  "pd"  'projectile-dired
  "pe"  'projectile-recentf
  "pp"  'projectile-switch-project
  "pn"  'hong/new-project
  "pR"  'projectile-regenerate-tags
  "ps"  'projectile-ag
  "pS"  'projectile-save-project-buffers
  "pr"  'projectile-remove-known-project
  "oa"  'org-agenda
  "sc"  'shell-command
  "sd" 'sudo-edit
  "ur" 'gud-remove
  "ub" 'gud-break
  "uu" 'gud-run
  "up" 'gud-print
  "ue" 'gud-cls
  "un" 'gud-next
  "us" 'gud-step
  "ui" 'gud-stepi
  "uc" 'gud-cont
  "uf" 'gud-finish
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
  "xz" 'suspend-frame
  "."  'evil-ex
  )

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
