;; evil
(require-package 'evil)
(evil-mode 1)

(setq evil-move-cursor-back nil)

(dolist (mode '(term-mode gud-mode
                eshell-mode shell-mode
                minibuffer-inactive-mode
                messages-buffer-mode
                special-mode
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
  "cd"  'yasdcv-translate-at-point
  "dj"  'dired-jump
  "fp"  'flycheck-previous-error
  "fn"  'flycheck-next-error
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
  "ne"  'next-error
  "pf"  'ffip
  ;; "pf"  'projectile-find-file
  "pa"  'projectile-ag
  "pb"  'projectile-switch-to-buffer
  "pd"  'projectile-dired
  "pe"  'previous-error                 ;"ne" next-error
  "ps"  'projectile-switch-project
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
