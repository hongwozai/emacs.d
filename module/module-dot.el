;;-------------------------------------------
;;; package
;;-------------------------------------------
(module-require "dot")
(require-package 'graphviz-dot-mode)
(require-package 'plantuml-mode)

;;-------------------------------------------
;;; dot config
;;-------------------------------------------
(add-to-list 'auto-mode-alist
             '("\\.plantuml\\'" . plantuml-mode))

(with-eval-after-load 'graphviz-dot-mode
  (setq graphviz-dot-auto-indent-on-braces t)
  (setq graphviz-dot-toggle-completions    t))
