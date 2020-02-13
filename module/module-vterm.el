;;-------------------------------------------
;;; vterm mode
;;-------------------------------------------
(require-package 'vterm)

(evil-set-initial-state 'vterm-mode 'emacs)

(add-hook 'vterm-mode-hook
          (lambda ()
            (shell-header-mode)
            (define-key vterm-mode-map (kbd "C-u") 'vterm--self-insert)
            (core/auto-exit)
            (local-set-key [escape] 'vterm--self-insert)
            ))

(defalias 'vt 'vterm)

(unless (assoc "find-file-other-window" vterm-eval-cmds)
  (add-to-list 'vterm-eval-cmds
              '("find-file-other-window" find-file-other-window)))