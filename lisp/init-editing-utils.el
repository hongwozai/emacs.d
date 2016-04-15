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
              visible-bell                t
              mode-require-final-newline  nil
              ring-bell-function          'ignore)

;;; trailing whitespace
(dolist (hook '(special-mode-hook
                comint-mode-hook
                Info-mode-hook
                minibuffer-setup-hook
                compilation-mode-hook
                term-mode-hook))
  (add-hook hook #'(lambda () (setq show-trailing-whitespace nil))))

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
(require-package 'dired+)
(require 'dired)
(eval-after-load 'dired
  '(progn
     (require 'dired+)
     (setq dired-recursive-copies 'always)
     (setq dired-recursive-deletes 'always)
     (toggle-diredp-find-file-reuse-dir 1)
     (setq dired-listing-switches "-aluh")
     (add-hook 'dired-mode-hook
               (lambda () (setq-local dired-isearch-filenames t)))
     (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
     (define-key dired-mode-map "/" 'isearch-forward)
     (define-key dired-mode-map "?" 'isearch-backward)
     (evil-define-key 'normal dired-mode-map "j" 'diredp-next-line)
     (evil-define-key 'normal dired-mode-map "k" 'diredp-previous-line)
     (evil-define-key 'normal dired-mode-map "J" 'hong/dired-goto-file)
     (diredp-toggle-find-file-reuse-dir 1)
     ))

(defun hong/dired-goto-file ()
  (interactive)
  (command-execute 'dired-goto-file)
  (diredp-find-file-reuse-dir-buffer))

(add-hook 'dired-mode-hook
          (lambda ()
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\.[^.].*$")
            (setq dired-omit-verbose nil)
            (dired-omit-mode)
            (hl-line-mode 1)))

;;; recentf
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

;;; TODO:ibuffer group
;;; ibuffer (list-buffers have bug: auto-recenterring)
(require-package 'ibuffer-vc)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(eval-after-load 'ibuffer
  '(progn
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
                 (hl-line-mode 1)))))

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
(setq enable-local-variables :all enable-local-eval t)

;;; kill ring
(require-package 'browse-kill-ring)

(provide 'init-editing-utils)