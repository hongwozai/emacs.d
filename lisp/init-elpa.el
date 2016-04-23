;; package
(require 'package)

;;; Also use Melpa for most packages
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))


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
      '(evil
        evil-leader
        zenburn-theme
        hydra
        window-numbering
        dired+
        swiper
        counsel
        multi-term
        flycheck
        flycheck-pos-tip
        company
        find-file-in-project
        ;; evil
        evil-anzu
        evil-surround
        evil-escape
        evil-matchit
        evil-iedit-state
        ;; workspace
        eyebrowse
        ;; edit
        avy
        yasnippet
        expand-region
        highlight-symbol
        ibuffer-vc
        exec-path-from-shell
        bing-dict
        chinese-pyim
        guide-key
        ;; version control
        magit
        git-gutter
        git-timemachine
        ;; cc-mode
        c-eldoc
        company-c-headers
        ;; python
        anaconda-mode
        company-anaconda
        ;; elisp
        elisp-slime-nav
        paredit
        ;; clojure
        clojure-mode
        ;; html, js, css, php
        web-mode
        js2-mode
        php-mode
        emmet-mode
        company-web
        ;; misc
        sql-indent
        markdown-mode))

(provide 'init-elpa)
