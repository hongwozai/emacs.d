;;-------------------------------------------
;;; vterm mode
;;-------------------------------------------
(require 'vterm)

(evil-set-initial-state 'vterm-mode 'emacs)

(add-hook 'vterm-mode-hook
          (lambda ()
            (core--set-work-state)
            (define-key vterm-mode-map (kbd "C-u") 'vterm--self-insert)
            (core/auto-exit)
            ))