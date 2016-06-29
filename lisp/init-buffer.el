;;; ibuffer (list-buffers have bug: auto-recenterring)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(with-eval-after-load 'ibuffer
  (define-key ibuffer-mode-map (kbd "j") 'ibuffer-forward-line)
  (define-key ibuffer-mode-map (kbd "k") 'ibuffer-backward-line)
  (define-key ibuffer-mode-map (kbd "J") 'ibuffer-jump-to-buffer)
  (define-key ibuffer-mode-map (kbd "K") 'ibuffer-do-kill-lines)

  (setq ibuffer-show-empty-filter-groups nil)
  (add-hook 'ibuffer-hook
            (lambda ()
              (unless (eq ibuffer-sorting-mode 'filename/process)
                (ibuffer-do-sort-by-filename/process))
              (ibuffer-switch-to-saved-filter-groups "default")
              (setq-local ibuffer-hidden-filter-groups '("Default"))
              (ibuffer-update nil t)
              (hl-line-mode 1))))

(setq ibuffer-saved-filter-groups
      '(("default"
         ("C/C++"        (or (mode . c-mode)
                             (mode . c++-mode)
                             (mode . makefile-mode)
                             (mode . makefile-gmake-mode)
                             (mode . makefile-automake-mode)
                             (mode . makefile-imake-mode)))
         ("Shell-script" (or (mode . sh-mode)))
         ("Python"       (or (mode . python-mode)
                             (mode . inferior-python-mode)))
         ("Shell"        (or (mode . eshell-mode)
                             (mode . shell-mode)
                             (mode . term-mode)))
         ("Web"          (or (mode . web-mode)
                             (mode . css-mode)
                             (mode . javascript-mode)
                             (mode . php-mode)
                             (mode . js2-mode)
                             (mode . json-mode)))
         ("Configure"    (or (mode . nxml-mode)
                             (mode . xml-mode)
                             (mode . conf-mode)))
         ("Java"         (or (mode . java-mode)))
         ("Javascript"   (or (mode . js2-mode)))
         ("Lisp"         (or (mode . scheme-mode)
                             (mode . lisp-mode)))
         ("Emacs"        (or (name . "^\\*scratch\\*$")
                             (mode . emacs-lisp-mode)
                             (mode . ielm-mode)))
         ("Clojure"      (or (mode . clojure-mode)))
         ("Sql"          (or (mode . sql-interactive-mode)
                             (mode . sql-mode)))
         ("Org"          (or (mode . org-mode)))
         ("Dired"        (or (mode . dired-mode)))
         ("Text"         (or (mode . text-mode)))
         ("Help"         (or (mode . woman-mode)
                             (mode . Man-mode)
                             (mode . Info-mode)))
         )))

(provide 'init-buffer)