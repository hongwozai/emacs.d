;; evil configure
(setq evil-move-cursor-back t)
(setq evil-want-C-u-scroll t)

;;; evil mode
(evil-mode 1)

;;; initial state change
(dolist (mode '(term-mode
                minibuffer-inactive-mode
                sql-interactive-mode diff-mode
                anaconda-nav-mode ibuffer-mode
                image-mode haskell-error-mode
                flycheck-error-list-mode
                cider-stacktrace-mode))
  (evil-set-initial-state mode 'emacs))

(dolist (mode '(diff-mode occur-mode yari-mode messages-buffer-mode
                          anaconda-mode-view-mode special-mode
                          package-menu-mode process-menu-mode
                          bookmark-bmenu-mode))
  (evil-set-initial-state mode 'motion))

;;; *Messages* can't set emacs state in emacs start
(with-current-buffer "*Messages*" (evil-motion-state))
(evil-define-key 'normal fundamental-mode-map "q" 'quit-window)
(evil-define-key 'motion fundamental-mode-map "q" 'quit-window)

(define-key evil-normal-state-map (kbd "gF") 'ff-find-related-file)

;;; ======================== evil plugin ==========================
;;; evil-anzu
(with-eval-after-load 'evil
  (global-anzu-mode)
  (require 'evil-anzu))

;;; evil surround
(global-evil-surround-mode 1)

;;; evil matchit
(global-evil-matchit-mode 1)

;;; evil iedit state
(autoload 'evil-iedit-state/iedit-mode "evil-iedit-state")

(global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode)
(with-eval-after-load 'iedit
  (global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode))

(with-eval-after-load 'evil-iedit-state
  (define-key evil-iedit-insert-state-map (kbd "C-;")
    'evil-iedit-state/quit-iedit-mode)
  (define-key evil-iedit-state-map (kbd "C-;")
    'evil-iedit-state/quit-iedit-mode))
;;; ===================== evil leader custom key =================
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
  "gc"  'ggtags-create-tags
  "gr"  'ggtags-find-reference
  "im"  'imenu
  "kr"  'counsel-yank-pop
  "mf"  'mark-defun
  "mp"  'mark-paragraph
  "mb"  'mark-whole-buffer
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
