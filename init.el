;; load path

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
(require 'init-directory)
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

;;; application
(require 'init-org-mode)
(require 'init-graphviz)

;;; program language
;; C/C++
(require 'init-cc-mode)
(maybe-require "gtags"  'init-gtags)
(maybe-require "rdm"    'init-rtags)

;; lisp dialect
(require 'init-lisp)
(maybe-require "lein"   'init-clojure)
(maybe-require "sbcl"   'init-common-lisp)

;;; octave matlab
(require 'init-octave)

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

