;;-------------------------------------------
;;; utilities function
;;-------------------------------------------
(require 'core-funcs)

;;-------------------------------------------
;;; load path
;;-------------------------------------------
(core/add-subdir-to-load-path
 (core/path-concat user-emacs-directory "site-lisp"))

;;-------------------------------------------
;;; basic
;;-------------------------------------------
;;; install from source
(setq core/package-install-mode 'source)
(require 'core-package)
(require 'core-options)
(require 'core-ui)
(require 'core-vim)
(require 'core-completion)
(require 'core-window)
(require 'core-keybindings)
(require 'core-modes)
(require 'core-shell)
(require 'core-remote)
(require 'core-directory)
(require 'core-buffer)

;;-------------------------------------------
;;; programming
;;-------------------------------------------
(require 'core-elisp)

;;-------------------------------------------
;;; application
;;-------------------------------------------
(require 'core-org)

(provide 'core-init)
