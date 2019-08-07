;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'ensime)
(require-package 'scala-mode)
(require-package 'sbt-mode)

(setq ensime-sbt-command "sbt"
      sbt:program-name "sbt")

(setq ensime-startup-notification nil)

(setq ensime-search-interface 'ivy)
(setq ensime-eldoc-hints 'all)