;; basic information
(setq user-full-name "luzeya")
(setq user-mail-address "hongwozai@163.com")
(setq default-directory "~/")

(fset 'yes-or-no-p 'y-or-n-p)

(setq-default default-tab-width           4
              indent-tabs-mode            nil
              column-number-mode          t
              scorll-margin               3
              make-backup-files           nil
              auto-save-mode              nil
              x-select-enable-clipboard   t
              mouse-yank-at-point         t
              truncate-lines              nil
              show-trailing-whitespace    t)

;; syntax hightlight
(global-font-lock-mode t)

;;; highlight symbol
(require-package 'highlight-symbol)
(dolist (hook '(prog-mode-hook web-mode-hook css-mode-hook))
  (add-hook hook 'highlight-symbol-mode)
  (add-hook hook 'highlight-symbol-nav-mode))
(setq highlight-symbol-idle-delay 0.5)
(global-set-key (kbd "M-n") 'highlight-symbol-next)
(global-set-key (kbd "M-p") 'highlight-symbol-prev)

;;; pretty symbol
(setq prettify-symbols-alist '(("lambda" . 955)))
(global-prettify-symbols-mode)

;;; dired
(require 'dired)
(eval-after-load 'dired
  '(progn
     (setq dired-recursive-copies t)
     (setq dired-recursive-deletes t)
     (define-key dired-mode-map "/" 'dired-isearch-filenames)
     ))

;; hs minor mode
(add-hook 'prog-mode-hook 'hs-minor-mode)

;; ispell
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "english")

;; uniquify buffer-name
(require 'uniquify)

;; expand-region
(require-package 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;;; avy
(require-package 'avy)

;; pair mode
(show-paren-mode t)

;; global special key
(global-set-key (kbd "RET") 'newline-and-indent)

(provide 'init-editing-utils)
