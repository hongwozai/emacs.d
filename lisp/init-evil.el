;; ========================= evil configure =======================
(setq evil-move-cursor-back t)
(setq evil-want-C-u-scroll t)

;;; evil mode
(evil-mode 1)

;;; ========================= evil state ==========================
;;; initial state change
(dolist (mode '(term-mode
                minibuffer-inactive-mode
                diff-mode ibuffer-mode
                eshell-mode shell-mode comint-mode
                sql-interactive-mode slime-repl-mode
                inferior-python-mode inf-ruby-mode
                image-mode haskell-error-mode
                flycheck-error-list-mode
                anaconda-nav-mode cider-mode
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

;;; evil matchit
(global-evil-matchit-mode 1)

;;; evil surround
(global-evil-surround-mode 1)
(setcdr (assoc ?t evil-surround-pairs-alist)
        (lambda () (let ((str (read-from-minibuffer "" ""))) (cons str str))))

;;; evil iedit state
(autoload 'evil-iedit-state/iedit-mode "evil-iedit-state")

(global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode)
(with-eval-after-load 'iedit
  (global-set-key (kbd "C-;") 'evil-iedit-state/iedit-mode))

(with-eval-after-load 'evil-iedit-state
  (define-key evil-iedit-insert-state-map
    (kbd "C-;") 'evil-iedit-state/quit-iedit-mode)
  (define-key evil-iedit-state-map
    (kbd "C-;") 'evil-iedit-state/quit-iedit-mode))

;;; ======================== evil misc =============================
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
