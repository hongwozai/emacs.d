;; ;; flycheck
(require-package 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
(setq flycheck-emacs-lisp-load-path 'inherit)
(setq flycheck-clang-language-standard "c99")

(defun hong/gtk-include-path ()
  '("/usr/include/gtk-2.0/"
    "/usr/lib/x86_64-linux-gnu/gtk-2.0/include"
    "/usr/include/gio-unix-2.0"
    "/usr/include/cairo"
    "/usr/include/pango-1.0"
    "/usr/include/atk-1.0"
    "/usr/include/cairo"
    "/usr/include/pixman-1"
    "/usr/include/libpng12"
    "/usr/include/gdk-pixbuf-2.0"
    "/usr/include/harfbuzz"
    "/usr/include/glib-2.0"
    "/usr/include/freetype2"
    "/usr/lib/x86_64-linux-gnu/glib-2.0/include"
    ))
(setq flycheck-clang-include-path
      `( ,@(hong/gtk-include-path)
         "/usr/include"
         "include" "../include"
         "inc" "../inc"))
(provide 'init-flycheck)
