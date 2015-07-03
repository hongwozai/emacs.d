(require-package 'markdown-mode)
(require-package 'lua-mode)
(require-package 'clojure-mode)

(require-package 'guide-key)
(setq guide-key/guide-key-sequence '("C-c" "C-x 4" ",u" ",b" ",p" ",o"))
(guide-key-mode 1)
(setq guide-key/highlight-command-regexp "rectange")
(setq guide-key/idle-delay 0.1)

(provide 'init-misc)
