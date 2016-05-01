;; evil
(evil-mode 1)
;;; =================== evil configure =====================
(setq evil-move-cursor-back t)

;;; initial state change
(dolist (mode '(term-mode
                minibuffer-inactive-mode
                messages-buffer-mode bs-mode
                special-mode process-menu-mode
                sql-interactive-mode diff-mode
                anaconda-nav-mode ibuffer-mode
                image-mode inferior-python-mode
                haskell-interactive-mode haskell-error-mode
                flycheck-error-list-mode rlogin-mode
                cider-stacktrace-mode))
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

;;; ======================== evil plugin ==========================
;;; evil-anzu
(global-anzu-mode)

;;; evil surround
(global-evil-surround-mode 1)

;;; evil escape
(setq-default evil-escape-key-sequence "kj")
(evil-escape-mode)
(dolist (hook '(minibuffer-setup-hook isearch-mode-hook))
  (add-hook hook (lambda () (setq-local evil-escape-inhibit t))))

;;; evil matchit
(global-evil-matchit-mode 1)

;;; evil iedit state
(autoload 'evil-iedit-state/iedit-mode "evil-iedit-state")

(global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode)
(eval-after-load 'iedit
  '(progn
     (global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode)))

(eval-after-load 'evil-iedit-state
  '(progn
     (define-key evil-iedit-insert-state-map (kbd "C-;")
       'evil-iedit-state/quit-iedit-mode)
     (define-key evil-iedit-state-map (kbd "C-;")
       'evil-iedit-state/quit-iedit-mode)))
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
  "en"  'next-error
  "ep"  'previous-error
  "gc"  'ggtags-create-tags
  "gd"  'ggtags-find-definition
  "gt"  'ggtags-find-tag-dwim
  "gr"  'ggtags-find-reference
  "gn"  'ggtags-next-mark
  "gp"  'ggtags-prev-mark
  "im"  'imenu
  "kr"  'counsel-yank-pop
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
