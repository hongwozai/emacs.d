;;; ggtags
(require-package 'ggtags)
(eval-after-load 'ggtags
  '(progn
     (setq ggtags-update-on-save t)))
(setq-local imenu-create-index-function #'ggtags-build-imenu-index)

;;; c-eldoc
(require-package 'c-eldoc)

;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; gdb
(setq gdb-many-windows t)
(setq gdb-show-main   t)

;;; bison
(require-package 'bison-mode)

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
;;; gtk
(defun hong/gtk-headers ()
  (let* ((cmd "pkg-config --cflags gtk+-3.0")
         (gtk (split-string
               (shell-command-to-string cmd))))
    (mapcar #'(lambda (x) (substring x 2))
            (remove-if #'(lambda (x) (not (eql (elt x 1) ?I))) gtk))))
(defun hong/my-gtk-config ()
  (setq flycheck-clang-include-path
        (append flycheck-clang-include-path (hong/gtk-headers)))
  (setq company-clang-arguments
        (append company-clang-arguments
                        (mapcar #'(lambda (x) (concat "-I" x)) (hong/gtk-headers))))
  (setq company-c-headers-path-system
        (append company-c-headers-path-system (hong/gtk-headers)))
  (setq c-eldoc-includes
        (concat c-eldoc-includes
                " "
                (reduce #'(lambda (x y) (concat x " " y))
                        (mapcar #'(lambda (x) (concat "-I" x)) (hong/gtk-headers))))))

(defun hong/my-c-mode-config ()
  "C/C++ only"
;;; c-eldoc
  (autoload 'c-turn-on-eldoc-mode "c-eldoc" "" t)
  (c-turn-on-eldoc-mode)
  (setq c-eldoc-buffer-regenerate-time 60)
  (setq c-eldoc-cpp-command "/usr/bin/cpp")
  (setq c-eldoc-includes "-I../ -I/usr/include "))

(add-hook 'c-mode-common-hook
          (lambda ()
            (hong/my-cc-common-config)
            (hong/my-c-mode-config)
            (ggtags-mode 1)))
(add-hook 'c-mode-hook
          (lambda ()
            (hong/my-gtk-config)))

(provide 'init-cc-mode)
