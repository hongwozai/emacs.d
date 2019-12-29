;;-------------------------------------------
;;; clojure
;;-------------------------------------------
(require-package 'clojure-mode)

(setq clojure-indent-style 'align-arguments)

(add-hook 'clojure-mode-hook 'lisp-common-edit-hook-func)