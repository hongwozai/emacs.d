;; package
(require 'package)

;;; localelpa
;;; mkdir -p ~/myelpa && emacs --batch -l ~/.emacs.d/init.el -l /home/lm/.emacs.d/elpa/elpa-mirror-20160917.10/elpa-mirror.el --eval='(setq elpamr-default-output-directory "/home/lm/.emacs.d/localelpa")' --eval='(elpamr-create-mirror-for-installed)'

;;; Also use Melpa for most packages
(setq package-archives
      '(("localelpa" . "../localelpa")
        ("gnu"   . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
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
      '(
        ace-link
        avy
        bing-dict
        chinese-pyim
        company
        company-c-headers
        company-web
        counsel
        dired+
        elisp-slime-nav
        elpa-mirror
        emmet-mode
        etags-select
        evil
        evil-anzu
        iedit
        evil-leader
        evil-matchit
        evil-mc
        evil-surround
        exec-path-from-shell
        expand-region
        find-file-in-project
        flycheck
        flycheck-pos-tip
        git-gutter
        git-timemachine
        highlight-symbol
        hydra
        ivy
        magit
        markdown-mode
        monokai-theme
        multi-term
        paredit
        php-mode
        rainbow-delimiters
        smex
        sql-indent
        tramp-term
        web-mode
        wgrep
        which-key
        window-numbering
        with-editor
        yasnippet
        ))

(provide 'init-elpa)
