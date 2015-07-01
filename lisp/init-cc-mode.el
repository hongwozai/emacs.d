(setq c-default-style "k&r"
      c-basic-offset       4
      indent-tabs-mode     t
      default-tab-with     4)

;;; compile
(setq compilation-window-height 12)
(setq compilation-read-command t)
(setq compile-command "make")

;;; gdb
(setq gdb-many-windows t)
(setq gdb-show-main   t)

;;; TODO: cpputils-cmake
;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(provide 'init-cc-mode)
