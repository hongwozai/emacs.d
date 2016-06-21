;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

(require 'init-utils)
(require 'init-themes)
(require 'init-elpa)

(require 'init-evil)
(require 'init-keybinding)
(require 'init-editing-utils)
(require 'init-frame)
(require 'init-window)
(require 'init-dired)
(require 'init-buffer)
(require 'init-search)
(require 'init-fuzzy)
(require 'init-tramp)
(require 'init-shell)

(require 'init-git)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-template)

(require 'init-chinese)
(require 'init-org-mode)

;;; program language
;; C/C++
(require 'init-project)
(require 'init-compile)
(require 'init-cc-mode)

;;; lisp dialect
(require 'init-lisp)
(maybe-require "lein"   'init-clojure)
(maybe-require "sbcl"   'init-common-lisp)

;; web
(require 'init-web)
(maybe-require "node"   'init-js)

(maybe-require "python" 'init-python)
(maybe-require "ruby"   'init-ruby)
(maybe-require "go"     'init-go)
(maybe-require "ghc"    'init-haskell)
(maybe-require "lua"    'init-lua)

(require 'init-misc)

;;; server
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
