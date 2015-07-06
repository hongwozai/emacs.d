;;; c-eldoc
(require-package 'c-eldoc)

;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; gdb
(setq gdb-many-windows t)
(setq gdb-show-main   t)

;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

(defun hong/my-cc-common-config ()
  ;; indent
  (setq c-default-style "k&r"
        c-basic-offset  4)
  ;; comment... use autoload
  ;; (require 'doxygen)
  ;; compile
  (setq compile-command "make")
  (setq compilation-window-height 12)
  (setq compilation-read-command t)
  (setq compilation-finish-function
        (lambda (buf str)
          (if (string-match "exited abnormally" str)
              (message "compilation errors, press C-x ` to visit'")
            (when (string-match "*compilation*" (buffer-name buf))
              (bury-buffer "*compilation*")
              (winner-undo)
              (message "NO COMPILATION ERRORS!")))))
  )
(defun hong/my-c-mode-config ()
  "C/C++ only"
;;; c-eldoc
  (autoload 'c-turn-on-eldoc-mode "c-eldoc" "" t)
  (c-turn-on-eldoc-mode)
  (setq c-eldoc-buffer-regenerate-time 60)
  (defvar c-eldoc-includes "-I./ -I../ -I/usr/include "))

(add-hook 'c-mode-common-hook
          (lambda ()
            (hong/my-cc-common-config)
            (hong/my-c-mode-config)
            (ggtags-mode 1)))


(provide 'init-cc-mode)
