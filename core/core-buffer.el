;;-------------------------------------------
;;; use ibuffer
;;-------------------------------------------
(with-eval-after-load 'ibuffer
  (require 'ibuf-ext)
  ;; (add-to-list 'ibuffer-never-show-predicates "^\\*")
  (setq ibuffer-show-empty-filter-groups nil)
  (add-hook 'ibuffer-hook
            (lambda ()
              (ibuffer-switch-to-saved-filter-groups "default")
              (ibuffer-update nil t)
              (hl-line-mode 1))))

;;-------------------------------------------
;;; ibuffer configure
;;-------------------------------------------
;;; use `/ f' filter groups
(setq ibuffer-saved-filter-groups
      '(("default"
         ("C/C++"        (or (mode . c-mode)
                             (mode . c++-mode)))
         ("Build"        (or (mode . makefile-imake-mode)
                             (mode . makefile-automake-mode)
                             (mode . makefile-gmake-mode)
                             (mode . makefile-mode)
                             (mode . cmake-mode)))
         ("Shell-script" (or (mode . sh-mode)))
         ("Python"       (or (mode . python-mode)
                             (mode . inferior-python-mode)))
         ("Shell"        (or (mode . eshell-mode)
                             (mode . shell-mode)
                             (mode . term-mode)))
         ("Web"          (or (mode . web-mode)
                             (mode . css-mode)
                             (mode . php-mode)))
         ("Conf"         (or (mode . nxml-mode)
                             (mode . xml-mode)
                             (mode . conf-unix-mode)
                             (mode . conf-windows-mode)
                             (mode . conf-space-mode)
                             (mode . conf-colon-mode)))
         ("Java"         (or (mode . java-mode)))
         ("Javascript"   (or (mode . js2-mode)
                             (mode . json-mode)
                             (mode . javascript-mode)))
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
         ("Graphviz"     (or (mode . graphviz-dot-mode)
                             (mode . plantuml-mode)))
         ("VC"           (or (name . "^\*vc-")))
         ("Magit"        (or (name . "^magit")))
         )))

;;-------------------------------------------
;;; key command
;;-------------------------------------------
(defalias 'sw 'switch-to-buffer)

(core/set-key ibuffer-mode-map
  :state 'emacs
  "j" 'ibuffer-forward-line
  "k" 'ibuffer-backward-line
  "J" 'ibuffer-jump-to-buffer
  "K" 'ibuffer-kill-line)

(provide 'core-buffer)
