;;; email ~/.mew.el
(require-package 'mew)
(autoload 'mew "mew" nil t)
(autoload 'mew-send "mew" nil t)

;;; markdown-mode
(require-package 'markdown-mode)
(setq auto-mode-alist
      (append '(("\\.md\\'" . markdown-mode))
              auto-mode-alist))

;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

;;; guide-key
(require-package 'guide-key)
(setq guide-key/guide-key-sequence `(",p" ",xv" ",g" ",w"
                                     ",b" ",h" ",u" ",s"
                                     ",a"
                                     "C-c" "C-x 4" "C-x 5"))
(guide-key-mode 1)
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 0.1)
(setq guide-key/popup-window-position 'bottom)

(provide 'init-misc)
