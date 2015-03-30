(setq c-default-style "k&r"
      c-basic-offset       4
      indent-tabs-mode     t
      default-tab-with     4)

(setq gdb-many-window t)
(setq gdb-show-main   t)

;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(provide 'init-cc-mode)
