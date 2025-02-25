;; evil
(use-package evil
  :demand t
  :config
  (evil-mode t)

  ;; configure
  (setq-default evil-move-cursor-back t)
  (setq-default evil-want-C-u-scroll nil)
  (setq-default evil-symbol-word-search t)

  ;; command
  (evil-ex-define-cmd "ls" 'ibuffer)
  (evil-ex-define-cmd "nu" 'display-line-numbers-mode)

  ;; ed backward
  (define-key evil-ex-completion-map (kbd "C-b") 'backward-char)
  (define-key evil-ex-completion-map (kbd "C-f") 'forward-char)

  ;; evil search
  (define-key isearch-mode-map (kbd "SPC")
              (lambda () (interactive)
                (setq isearch-message (concat isearch-message ".*?"))
                (setq isearch-string (concat isearch-string ".*?"))
                (isearch-push-state)
                (isearch-update)))

  ;; bindings (for evil-collection)
  ;; (setq evil-want-keybinding nil)
  )

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode t))

(use-package evil-args
  :after evil
  :config
  ;; bind evil-args text objects
  (define-key evil-inner-text-objects-map "a" 'evil-inner-arg)
  (define-key evil-outer-text-objects-map "a" 'evil-outer-arg))

(use-package evil-matchit :after evil)

(provide 'core-vim)