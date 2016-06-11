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
              (ibuffer-switch-to-saved-filter-groups "default")
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

(setq ibuffer-saved-filter-groups
      '(("default"
         ("C/C++"        (or (mode . c-mode)
                             (mode . c++-mode)
                             (mode . makefile-mode)))
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
         ("Help"         (or (mode . woman-mode)
                             (mode . man-mode)
                             (mode . Info-mode)))
         )))

(provide 'init-buffer)