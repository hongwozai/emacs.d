;; load path

(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;; utils
(require 'init-utils)

;;; core
(require 'init-elpa)
(require 'init-evil)
(require 'init-themes)
(require 'init-keybinding)
(require 'init-editing-utils)
(require 'init-window)
(require 'init-dired)
(require 'init-buffer)
(require 'init-frame)
(require 'init-tramp)
(require 'init-fuzzy)
(require 'init-search)
(require 'init-shell)
(require 'init-term)
(require 'init-project)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-compile)
(require 'init-template)
(require 'init-chinese)

;;; common
(require 'init-git)
(maybe-require "gtags"  'init-gtags)

;;; application
(require 'init-org-mode)

;;; program language
;; C/C++
(require 'init-cc-mode)

;; lisp dialect
(require 'init-lisp)
(maybe-require "lein"   'init-clojure)
(maybe-require "sbcl"   'init-common-lisp)

;; web
(require 'init-web)
(require 'init-js)

(maybe-require "python" 'init-python)
(maybe-require "ruby"   'init-ruby)
(maybe-require "go"     'init-go)
(maybe-require "ghc"    'init-haskell)
(maybe-require "lua"    'init-lua)
(maybe-require "racket" 'init-scheme)
(maybe-require "javac"  'init-java)

;;; misc mode
(require 'init-misc-mode)

;;; server
(require 'server)
(unless (server-running-p)
  (server-start))

(provide 'init)

