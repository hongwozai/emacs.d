;;-------------------------------------------
;;; utilities function
;;-------------------------------------------
(require 'core-funcs)
(require 'core-module)

;;-------------------------------------------
;;; load path
;;-------------------------------------------
(core/add-subdir-to-load-path
 (core/path-concat user-emacs-directory "site-lisp"))

;;-------------------------------------------
;;; basic
;;-------------------------------------------
;;; install from source
(setq core/package-install-mode 'melpa)
(require 'core-package)
(require 'core-options)
(require 'core-vim)
(require 'core-completion)
(require 'core-ui)
(require 'core-window)
(require 'core-shell)
(require 'core-remote)
(require 'core-directory)
(require 'core-buffer)
(require 'core-project)
(require 'core-highlight)
(require 'core-keybindings)

;;; popup frame alert etc.
(require 'core-misc)

;;-------------------------------------------
;;; ide features
;;-------------------------------------------
(require 'core-template)
(require 'core-auto-check)
(require 'core-auto-complete)
(require 'core-lsp)

;;-------------------------------------------
;;; programming
;;-------------------------------------------
(require 'core-elisp)

(provide 'core-init)
