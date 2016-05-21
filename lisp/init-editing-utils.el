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
              scroll-margin               0
              scroll-step                 1
              visible-bell                t
              mode-require-final-newline  nil
              ring-bell-function          'ignore)

;;; trailing whitespace
(add-hook 'prog-mode-hook (lambda () (setq-local show-trailing-whitespace t)))

;; Auto refresh buffers, dired revert have bugs.
;;; remote file revert have bugs.
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t
      dired-auto-revert-buffer            nil
      auto-revert-verbose                 nil)

;;; cursor
(blink-cursor-mode 0)

;; syntax hightlight
(global-font-lock-mode t)

;;; dired
(autoload 'dired-jump "dired" "jump current directory")
(add-hook 'dired-load-hook
          (lambda ()
            (require 'dired+)
            (setq dired-recursive-copies 'always)
            (setq dired-recursive-deletes 'always)
            (setq dired-listing-switches "-aluh")
            (setq dired-isearch-filenames t)
            (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
            (define-key dired-mode-map "/" 'isearch-forward)
            (define-key dired-mode-map "?" 'isearch-backward)
            (diredp-toggle-find-file-reuse-dir 1)
            ))

(add-hook 'dired-mode-hook
          (lambda ()
            (evil-define-key 'normal dired-mode-map
              "j" 'diredp-next-line
              "k" 'diredp-previous-line
              "J" '(lambda () (interactive)
                     (find-alternate-file (read-directory-name "Directory: ")))
              )
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\..*$")
            (setq dired-omit-verbose nil)
            (dired-omit-mode)
            (hl-line-mode 1)))

;;; recentf
(setq recentf-auto-cleanup 'never)
(require 'recentf)
(setq recentf-max-saved-items 100)
(add-hook 'after-init-hook (lambda () (recentf-mode 1)))

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(when (executable-find "aspell")
  (setq-default ispell-program-name "aspell"))
(setq ispell-dictionary "english")

;; uniquify buffer-name
(require 'uniquify)

;;; ibuffer (list-buffers have bug: auto-recenterring)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(with-eval-after-load 'ibuffer
  (require 'ibuffer-vc)
  (define-key ibuffer-mode-map (kbd "j") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "k") 'ibuffer-backward-line)
  (define-key ibuffer-mode-map (kbd "J") 'ibuffer-jump-to-buffer)
  (define-key ibuffer-mode-map (kbd "K") 'ibuffer-do-kill-lines)
  (setq ibuffer-show-empty-filter-groups nil)
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-vc-set-filter-groups-by-vc-root)
              (unless (eq ibuffer-sorting-mode 'filename/process)
                (ibuffer-do-sort-by-filename/process))
              (hl-line-mode 1))))

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
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(setq avy-background t)

;; show pair
(show-paren-mode t)
(setq show-paren-style 'parenthesis)

;; built-in paren dir
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "M-n") 'next-error)
(global-set-key (kbd "M-p") 'previous-error)

;;; .dir-locals.el
(setq enable-local-variables :all enable-local-eval t)

(provide 'init-editing-utils)