;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(require 'init-utils)
(require 'init-elpa)

(require 'init-themes)
(require 'init-evil)
(require 'init-frame)
(require 'init-window)
(require 'init-editing-utils)

(require 'init-tramp)
(require 'init-shell)
(require 'init-search)
(require 'init-ido)

(require 'init-project)
(require 'init-git)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-template)
(require 'init-compile)

(require 'init-chinese)
(require 'init-org-mode)

(require 'init-cc-mode)
(require 'init-lisp)
(require 'init-python)
(require 'init-ruby)
(require 'init-web)
(require 'init-sql)

(require 'init-misc)

(provide 'init)
