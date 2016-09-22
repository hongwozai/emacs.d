;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path (expand-file-name "~/.emacs.d/lisp"))

;;; utils
(require 'init-utils)

;;; core (no network)
(require 'init-themes)
(require 'init-evil)
(require 'init-keybinding)
(require 'init-editing-utils)
(require 'init-window)
(require 'init-dired)
(require 'init-ibuffer)
(require 'init-frame)
(require 'init-tramp)
(require 'init-fuzzy)
(require 'init-search)
(require 'init-shell)
(require 'init-term)
(require 'init-project)

;; ;;; basic (network)
(require 'init-elpa)
(require 'init-evil-plugin)
(require 'init-editing-misc)
(require 'init-chinese)
(require 'init-flycheck)
(require 'init-complete)
(require 'init-template)
(require 'init-hydra)

;;; common
(require 'init-git)
(maybe-require "gtags"  'init-gtags)

;;; application
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
(require 'init-js)

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
