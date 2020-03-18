;;-------------------------------------------
;;; package
;;-------------------------------------------
(module-require-manual)
(require-package 'scala-mode)
(require-package 'sbt-mode)

(setq sbt:program-name "sbt")

;;; ensime
(setq ensime-sbt-command "sbt")
(require-package 'ensime)
(setq ensime-startup-notification nil)

(setq ensime-search-interface 'ivy)
(setq ensime-eldoc-hints 'all)

(core/set-key scala-mode-map
  :state '(normal emacs)
  (kbd "C-]") 'ensime-edit-definition
  (kbd "M-.") 'ensime-edit-definition
  (kbd "C-t") 'ensime-pop-find-definition-stack)
