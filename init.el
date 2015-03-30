;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))

(require 'init-utils)
(require 'init-elpa)

(require 'init-themes)
(require 'init-window)

(require 'init-editing-utils)
(require 'init-tramp)
(require 'init-pair)

(require 'init-ido)
(require 'init-helm)
(require 'init-evil)

(require 'init-flycheck)
(require 'init-complete)

(require 'init-cc-mode)
(require 'init-org-mode)
(require 'init-lisp)
(require-package 'lua-mode)
(require-package 'markdown-mode)

(require 'init-locale)

(provide 'init)
