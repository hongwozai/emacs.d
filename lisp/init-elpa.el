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
        hydra
        window-numbering
        dired+
        ivy
        swiper
        counsel
        xterm-color
        multi-term
        flycheck
        flycheck-pos-tip
        company
        find-file-in-project
        ;; evil
        evil-anzu
        evil-matchit
        evil-surround
        evil-iedit-state
        ;; workspace
        eyebrowse
        ;; edit
        avy
        vlf
        smex
        wgrep
        yasnippet
        which-key
        expand-region
        exec-path-from-shell
        bing-dict
        chinese-pyim
        ;; version control
        with-editor
        magit
        git-gutter
        git-timemachine
        ;; cc-mode
        etags-select
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
