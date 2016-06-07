(require-package 'geiser)

(add-hook 'geiser-mode-hook
          (lambda ()
            (evil-leader/set-key-for-mode 'scheme-mode
              "xe" 'geiser-eval-last-sexp)))

(provide 'init-scheme)