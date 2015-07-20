(require-package 'clojure-mode)
(require-package 'markdown-mode)
(setq auto-mode-alist
      (append '(("\\.md\\'" . markdown-mode))
              auto-mode-alist))

(require-package 'guide-key)
(setq guide-key/guide-key-sequence t)
(guide-key-mode 1)
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 0.3)
(setq guide-key/popup-window-position 'bottom)

(provide 'init-misc)
