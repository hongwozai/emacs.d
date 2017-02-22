(require-package 'geiser)

(add-hook 'scheme-mode-hook
          (lambda ()
            (evil-leader/set-key-for-mode 'scheme-mode
              "xe" 'geiser-eval-last-sexp)

            (evil-define-key 'normal scheme-mode-map
              (kbd "M-,") 'geiser-pop-symbol-stack
              (kbd "M-.") 'geiser-edit-symbol-at-point)

            (evil-define-key 'insert scheme-mode-map
              (kbd "M-,") 'geiser-pop-symbol-stack
              (kbd "M-.") 'geiser-edit-symbol-at-point)

            (evil-leader/set-key-for-mode 'scheme-mode
              "ch" 'geiser-doc-look-up-manual)))

(provide 'init-scheme)