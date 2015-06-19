;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))

(require 'init-utils)
(require 'init-elpa)

(require 'init-themes)
(require 'init-frame)
(require 'init-window)

(require 'init-editing-utils)
(require 'init-tramp)
(require 'init-shell)
(require 'init-pair)
(require 'init-tags)

(require 'init-ido)
(require 'init-helm)
(require 'init-evil)

(require 'init-project)
(require 'init-git)
(require 'init-flycheck)
(require 'init-complete)

(require 'init-dict)

(require 'init-cc-mode)
(require 'init-lisp)
(require 'init-python)
(require 'init-org-mode)
(require 'init-web)

(provide 'init)
