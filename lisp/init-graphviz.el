(when (executable-find "dot")
  (require-package 'graphviz-dot-mode))

;;; graphviz
(with-eval-after-load "org"
  (add-to-list 'org-src-lang-modes  '("dot" . graphviz-dot))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)))
  )

(add-hook 'graphviz-dot-mode-hook
          (lambda ()
            (hong/select-buffer-window graphviz-dot-preview "*preview*")
            (setq graphviz-dot-auto-indent-on-braces t)
            (setq graphviz-dot-toggle-completions t)
            ;; use imagemagick
            (setq graphviz-dot-view-command "display %s")
            ))

(provide 'init-graphviz)