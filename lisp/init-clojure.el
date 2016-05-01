(require-package 'clojure-mode)
(require-package 'cider)

(setq cider-repl-result-prefix ";; =>")
(setq cider-repl-use-pretty-printing t)
(setq cider-font-lock-dynamically '(macro core function var))

(add-hook 'cider-mode-hook #'eldoc-mode)
(add-hook 'cider-repl-mode-hook
          (lambda ()
            (shell-like-map-setup cider-repl-mode-map)
            (evil-define-key 'insert cider-repl-mode-map
              (kbd "C-n") 'cider-repl-next-input
              (kbd "C-p") 'cider-repl-previous-input)
            (add-hook 'evil-insert-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)))

(provide 'init-clojure)