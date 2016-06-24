(require-package 'clojure-mode)
(require-package 'cider)

(setq cider-repl-result-prefix ";; =>")
(setq cider-repl-use-pretty-printing t)
(setq cider-font-lock-dynamically '(macro core function var))

(add-hook 'cider-mode-hook
          (lambda ()
            (evil-define-key 'normal cider-mode-map
              (kbd "M-.") 'cider-find-var
              (kbd "M-,") 'cider-pop-back)
            (eldoc-mode)))

(add-hook 'cider-repl-mode-hook
          (lambda ()
            (shell-like-map-setup cider-repl-mode-map)
            (evil-define-key 'insert cider-repl-mode-map
              (kbd "C-n") 'cider-repl-next-input
              (kbd "C-p") 'cider-repl-previous-input)
            (add-hook 'evil-insert-state-entry-hook
                      (lambda () (interactive) (goto-char (point-max))) nil t)))

;;; key
(evil-leader/set-key-for-mode 'clojure-mode "xe" 'cider-eval-last-sexp)

(provide 'init-clojure)