;; basic information
(setq user-full-name "luzeya")
(setq user-mail-address "hongwozai@163.com")
(setq default-directory "~/")

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default default-tab-width           4
              indent-tabs-mode            nil
              column-number-mode          t
              scroll-preserve-screen-position 'always
              make-backup-files           nil
              auto-save-mode              nil
              x-select-enable-clipboard   t
              mouse-yank-at-point         t
              truncate-lines              nil
              show-trailing-whitespace    t
              scroll-margin               0
              visible-bell                t)

;;; trailing whitespace
(dolist (hook '(special-mode-hook
                comint-mode-hook
                Info-mode-hook
                minibuffer-setup-hook
                compilation-mode-hook
                term-mode-hook))
  (add-hook hook #'(lambda () (setq show-trailing-whitespace nil))))

;; Auto refresh buffers
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            t
      auto-revert-verbose                 nil)

;;; cursor
(blink-cursor-mode 0)
;; (global-hl-line-mode t)

;; syntax hightlight
(global-font-lock-mode t)

;;; dired
(require 'dired)
(eval-after-load 'dired
  '(progn
     (setq dired-recursive-copies 'always)
     (setq dired-recursive-deletes 'always)
     (add-hook 'dired-mode-hook
               (lambda () (setq-local dired-isearch-filenames t)))
     (define-key dired-mode-map "/" 'isearch-forward)
     (define-key dired-mode-map "?" 'isearch-backward)
     (define-key dired-mode-map " " 'avy-goto-line)
     ))

;;; dired single
(require-package 'dired-single)
(defun my-dired-init ()
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (dired-single-buffer "..")))))

(if (boundp 'dired-mode-map)
    (my-dired-init)
  (add-hook 'dired-load-hook 'my-dired-init))

;;; dired+
(require-package 'dired+)
(eval-after-load 'dired
  '(progn (require 'dired+)))

(add-hook 'dired-mode-hook
          (lambda ()
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^\\..*")
            (dired-omit-mode)))

;;; recentf
(require 'recentf)
(setq recentf-max-saved-items 1000)

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "english")

;; uniquify buffer-name
(require 'uniquify)

;;; ibuffer (list-buffers have bug: auto-recenterring)
(require-package 'ibuffer-vc)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(require 'ibuffer-vc)
(eval-after-load 'ibuffer
  '(progn
     (define-key ibuffer-mode-map (kbd "SPC") 'avy-goto-line)
     (define-key ibuffer-mode-map (kbd "j") 'ibuffer-forward-line)
     (define-key ibuffer-mode-map (kbd "k") 'ibuffer-backward-line)
     (define-key ibuffer-mode-map (kbd "J") 'ibuffer-jump-to-buffer)
     (define-key ibuffer-mode-map (kbd "K") 'ibuffer-do-kill-lines)
     (setq ibuffer-show-empty-filter-groups nil)
     (setq ibuffer-saved-filter-groups
           '(("default"
              ("org"   (or (mode . org-mode)
                           (mode . org-agenda-mode)))
              ("dired" (mode . dired-mode))
              ("emacs" (or (name . "^\\*scratch\\*$")
                           (name . "^\\*Messages\\*$"))))))
     (add-hook 'ibuffer-hook
               (lambda ()
                 (ibuffer-vc-set-filter-groups-by-vc-root)
                 (unless (eq ibuffer-sorting-mode 'filename/process)
                   (ibuffer-do-sort-by-filename/process))))))
(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))

;; expand-region
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(require-package 'avy)
(setq avy-background t)

;; show pair
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;;; highlight symbol
(require-package 'highlight-symbol)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)
(add-hook 'highlight-symbol-mode-hook
          (lambda ()
            (setq highlight-symbol-idle-delay 0.5)
            (highlight-symbol-nav-mode)))

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)

;;; .dir-locals.el
;;; eg. ((nil . ((indent-tabs-mode . t)
;;;              (fill-column . 80)))
;;;      (c-mode . (c-file-style . "BSD"))
;;;      ("src/imported" . ((nil . ((VAR . "VALUE)))))) ;;; subdir
;;; M-x add-dir-local-variable
;;; .dir-locals.el can "eval", eg. ((nil . ((eval . (setq VAR "VALUE")))))
(setq enable-local-variables :all enable-local-eval t)

;;; hydra key binding
(require-package 'hydra)

(provide 'init-editing-utils)
