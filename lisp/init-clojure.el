(require-package 'clojure-mode)
(require-package 'cider)

(setq cider-repl-result-prefix ";; =>")
(setq cider-repl-use-pretty-printing t)
(add-hook 'cider-mode-hook #'eldoc-mode)

(provide 'init-clojure)