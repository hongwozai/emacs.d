;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(require 'init-utils)
(require 'init-elpa)

(require 'init-themes)
(require 'init-evil)
(require 'init-keybinding)
(require 'init-frame)
(require 'init-window)
(require 'init-buffer)
(require 'init-editing-utils)

(require 'init-ido)
(require 'init-tramp)
(require 'init-shell)
(require 'init-search)

(require 'init-project)
(require 'init-git)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-template)
(require 'init-compile)

(require 'init-chinese)
(require 'init-org-mode)

;;; program language
(require 'init-cc-mode)
(require 'init-lisp)
(require 'init-web)

(maybe-require "python" 'init-python)
(maybe-require "ruby"   'init-ruby)
(maybe-require "node"   'init-js)
(maybe-require "lein"   'init-clojure)
(maybe-require "sbcl"   'init-common-lisp)
(maybe-require "go"     'init-go)
(maybe-require "ghc"    'init-haskell)
(maybe-require "lua"    'init-lua)

(require 'init-misc)

;;; server
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
