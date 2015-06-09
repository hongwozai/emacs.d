;; load path
(setq user-emacs-directory "~/.emacs.d/")
(add-to-list 'load-path
             (expand-file-name "lisp"
                               user-emacs-directory))
(add-to-list 'load-path
             (expand-file-name "site-lisp"
                               user-emacs-directory))

(require 'init-utils)
(require 'init-elpa)

(require 'init-themes)
(require 'init-window)

(require 'init-editing-utils)
(require 'init-tramp)
(require 'init-shell)
(require 'init-pair)

(require 'init-ido)
(require 'init-helm)
(require 'init-evil)

(require 'init-project)
(require 'init-git)
(require 'init-flycheck)
(require 'init-complete)

(require 'init-dict)

(require 'init-cc-mode)
(require 'init-org-mode)
(require 'init-web)
(require 'init-lisp)

(provide 'init)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(magit-diff-use-overlays nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
