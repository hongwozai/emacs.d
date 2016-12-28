;; package
(require 'package)

;;; Also use Melpa for most packages
(setq package-archives
      '(("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ("melpa-stable" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")))

;;; offical Melpa (and Gnu)
;; (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;; (add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))


(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
      (if (or (assoc package package-archive-contents) no-refresh)
          (package-install package)
          (progn
            (package-refresh-contents)
            (require-package package min-version t)))))

(package-initialize)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; all package
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(mapc #'require-package
      '(hydra
        flycheck
        flycheck-pos-tip
        company
        ;; evil
        evil-mc
        evil-anzu
        evil-matchit
        evil-surround
        evil-iedit-state
        ;; edit
        avy
        ace-link
        vlf
        smex
        wgrep
        yasnippet
        which-key
        expand-region
        highlight-symbol
        bing-dict
        chinese-pyim
        aggressive-indent
        ;; version control
        with-editor
        magit
        git-gutter
        git-timemachine
        ;; cc-mode
        company-c-headers
        ;; elisp
        elisp-slime-nav
        evil-paredit
        paredit
        rainbow-delimiters
        ;; html, js, css, php
        web-mode
        php-mode
        emmet-mode
        company-web
        ;; misc
        sql-indent
        markdown-mode))

(provide 'init-elpa)
