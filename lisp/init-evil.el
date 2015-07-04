;; evil
(require-package 'evil)
(evil-mode 1)

(setq evil-move-cursor-back nil)

(dolist (mode '(term-mode gud-mode
                eshell-mode shell-mode
                flycheck-error-list-mode))
  (evil-set-initial-state mode 'emacs))

;; (evil-declare-key 'normal org-mode-map)
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)
(define-key evil-normal-state-map (kbd "SPC") 'avy-goto-word-1)
(define-key evil-visual-state-map (kbd "SPC") 'avy-goto-word-1)
(define-key evil-normal-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-visual-state-map (kbd "RET") 'avy-goto-line)
(define-key evil-normal-state-map (kbd "K") 'helm-man-woman)

;;; evil escape
(require-package 'evil-escape)
(setq-default evil-escape-key-sequence "fd")
(setq evil-escape-excluded-major-modes '(dired-mode))
(setq-default evil-escape-delay 0.2)
(evil-escape-mode 1)

;;; evil surround
(require-package 'evil-surround)
(global-evil-surround-mode 1)

;; evil leader custom key
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "bl"  'helm-mini
  "cd" 'yasdcv-translate-at-point
  "dj" 'dired-jump
  "oa"  'org-agenda
  "ff"  'ido-find-file-other-window
  "fb"  'ido-switch-buffer-other-window
  "fl"  'flycheck-list-errors
  "ha" 'helm-apropos
  "hs" 'hs-toggle-hiding
  "im" 'helm-imenu
  "kb"  'kill-this-buffer
  "mf"  'mark-defun
  "pa"  'helm-projectile
  "sd" 'sudo-edit
  "uk" 'gud-kill-yes
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
  "xc" 'save-buffers-kill-terminal
  "xf"  'ido-find-file
  "xe" 'eval-last-sexp
  "xs" 'save-buffer
  "xz" 'suspend-frame
  )

(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)

(lexical-let ((default-color ;; (cons (face-background 'mode-line)
                ;;       (face-foreground 'mode-line))
                (cons nil nil)
                ))
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
