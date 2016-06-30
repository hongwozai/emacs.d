;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;; utils
(require 'init-utils)
(require 'init-themes)
(require 'init-elpa)

;;; basic
(require 'init-evil)
(require 'init-keybinding)
(require 'init-editing-utils)
(require 'init-dired)
(require 'init-tramp)
(require 'init-fuzzy)
(require 'init-frame)
(require 'init-window)
(require 'init-ibuffer)
(require 'init-search)
(require 'init-chinese)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-template)

(require 'init-git)
(require 'init-tags)
(require 'init-shell)
(require 'init-project)

;; application
(require 'init-org-mode)

;;; program language
;; C/C++
(require 'init-compile)
(require 'init-cc-mode)

;; lisp dialect
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

;;; misc mode
(require 'init-misc-mode)

;;; server
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)
