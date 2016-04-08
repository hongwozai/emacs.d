;; evil
(require-package 'evil)
(evil-mode 1)
;;; =================== evil configure =====================
(setq evil-move-cursor-back t)

;;; initial state change
(dolist (mode '(term-mode
                shell-mode eshell-mode
                minibuffer-inactive-mode
                messages-buffer-mode bs-mode
                special-mode process-menu-mode
                sql-interactive-mode diff-mode
                anaconda-nav-mode ibuffer-mode
                comint-mode image-mode inferior-python-mode
                interactive-haskell-mode haskell-error-mode
                flycheck-error-list-mode rlogin-mode))
  (evil-set-initial-state mode 'emacs))

(dolist (mode '(diff-mode occur-mode yari-mode
                          anaconda-mode-view-mode
                          package-menu-mode))
  (evil-set-initial-state mode 'motion))

;;; *Messages* can't set emacs state in emacs start
(evil-define-key 'normal messages-buffer-mode-map "q" 'quit-window)
(evil-define-key 'normal fundamental-mode-map "q" 'quit-window)
(evil-define-key 'motion fundamental-mode-map "q" 'quit-window)

(define-key evil-normal-state-map (kbd "gF") 'ff-find-related-file)
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)
(define-key evil-visual-state-map (kbd "v") 'er/expand-region)

;;; ======================== evil plugin ==========================
;;; evil-anzu
(require-package 'evil-anzu)
(require 'evil-anzu)
(global-anzu-mode)

;;; evil surround
(require-package 'evil-surround)
(global-evil-surround-mode 1)

;;; evil escape
(require-package 'evil-escape)
(setq-default evil-escape-key-sequence "kj")
(evil-escape-mode)
(dolist (hook '(minibuffer-setup-hook isearch-mode-hook))
  (add-hook hook (lambda () (setq-local evil-escape-inhibit t))))

;;; evil matchit
(require-package 'evil-matchit)
(global-evil-matchit-mode 1)

;;; evil iedit
(require-package 'iedit)
(require-package 'evil-iedit-state)
(autoload 'evil-iedit-state "evil-iedit-state")
(autoload 'evil-iedit-insert-state "evil-iedit-state")

(define-key evil-normal-state-map (kbd "C-;") 'hong/evil-iedit-state)
(define-key evil-insert-state-map (kbd "C-;") 'hong/evil-iedit-insert-state)

(defun hong/evil-iedit-state ()
  (interactive)
  (iedit-mode)
  (if (eq evil-state 'iedit)
      (evil-normal-state)
    (evil-iedit-state)))

(defun hong/evil-iedit-insert-state ()
  (interactive)
  (iedit-mode)
  (if (eq evil-state 'iedit-insert)
      (evil-insert-state)
    (evil-iedit-insert-state))
  )
;;; ===================== evil leader custom key =================
(require-package 'evil-leader)
(global-evil-leader-mode)

(evil-leader/set-leader ",")
(evil-leader/set-key
  "b"   'hydra-mark-or-buf-menu/body
  "f"   'hydra-open-files-menu/body
  "h"   'hydra-help-menu/body
  "s"   'hydra-search-menu/body
  "w"   'hydra-window-menu/body
  "o"   'org-agenda

  "al"  'avy-goto-line
  "aw"  'avy-goto-word-1
  "cd"  'yasdcv-translate-at-point
  "cs"  'hong/translate-brief-at-point
  "ds"  'sudo-edit
  "en"  'next-error
  "ep"  'previous-error
  "gc"  'ggtags-create-tags
  "gd"  'ggtags-find-definition
  "gt"  'ggtags-find-tag-dwim
  "gr"  'ggtags-find-reference
  "gn"  'ggtags-next-mark
  "gp"  'ggtags-prev-mark
  "im"  'imenu
  "kr"  'browse-kill-ring
  "mf"  'mark-defun
  "mp"  'mark-paragraph
  "mb"  'mark-whole-buffer
  "xb"  'ido-switch-buffer
  "xc"  'save-buffers-kill-terminal
  "xe"  'eval-last-sexp
  "xf"  'ido-find-file
  "xk"  'kill-this-buffer
  "xs"  'save-buffer
  "xz"  'suspend-frame)

(evil-leader/set-key-for-mode 'scheme-mode "xe" 'scheme-send-last-sexp)
(evil-leader/set-key-for-mode 'lisp-mode "xe" 'slime-eval-last-expression)
(evil-leader/set-key-for-mode 'lisp-mode "ch" 'slime-documentation-lookup)
(evil-leader/set-key-for-mode 'ruby-mode "cr" 'ruby-send-region)

;;; ===================== self ===========================
;;; evil ex cmd
(evil-ex-define-cmd "ls" 'ibuffer)
(evil-ex-define-cmd "nu" 'linum-mode)

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
