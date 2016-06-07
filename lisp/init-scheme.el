(require-package 'geiser)

(add-hook 'geiser-mode-hook
          (lambda ()
            (evil-leader/set-key-for-mode 'scheme-mode
              "xe" 'geiser-eval-last-sexp)
            (evil-define-key 'normal scheme-mode-map
              "M-," 'geiser-pop-symbol-stack
              "M-." 'geiser-edit-symbol-at-point)
            (evil-define-key 'insert scheme-mode-map
              "M-," 'geiser-pop-symbol-stack
              "M-." 'geiser-edit-symbol-at-point)))

(provide 'init-scheme)