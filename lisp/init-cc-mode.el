;;; ===================== ggtags eldoc doxygen ==================
(require-package 'ggtags)
(eval-after-load 'ggtags
  '(progn
     (setq ggtags-update-on-save t)
     (setq-local imenu-create-index-function #'ggtags-build-imenu-index)))
;;; evil C-] jump to tag
(define-key evil-normal-state-map (kbd "C-]")
  '(lambda () (interactive)
     (if (file-exists-p "./GTAGS")
         (ggtags-find-definition (thing-at-point 'symbol))
       (evil-jump-to-tag))))

;;; c-eldoc
(require-package 'c-eldoc)

;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; ===================== gdb ==================
(setq gdb-many-windows t)
(setq gdb-show-main   t)

;;; ===================== gtk config ==================
(defun hong/gtk-headers ()
  (let* ((cmd "pkg-config --cflags gtk+-3.0")
         (gtk (split-string
               (shell-command-to-string cmd))))
    (mapcar #'(lambda (x) (substring x 2))
            (remove-if #'(lambda (x) (not (eql (elt x 1) ?I))) gtk))))
(defun hong/my-gtk-config ()
  (interactive)
  (setq flycheck-clang-include-path
        (append flycheck-clang-include-path (hong/gtk-headers)))
  (setq company-clang-arguments
        (append company-clang-arguments
                (mapcar #'(lambda (x) (concat "-I" x)) (hong/gtk-headers))))
  (setq company-c-headers-path-system
        (append company-c-headers-path-system (hong/gtk-headers)))
  (setq c-eldoc-includes
        (concat c-eldoc-includes
                " `pkg-config gtk+-3.0 --cflags`"))
  )
;;; ===================== cc mode config ==================
(defun hong/my-cc-common-config ()
  ;; indent
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)
  ;; related file
  (setq-local cc-search-directories
              '("../inc" "../include" "../src" "../source"
                "." "/usr/include" "/usr/local/include/*"))
  )
(defun hong/my-c-mode-config ()
  "C/C++ only"
  ;; c-eldoc
  (autoload 'c-turn-on-eldoc-mode "c-eldoc" "" t)
  (c-turn-on-eldoc-mode)
  (setq c-eldoc-buffer-regenerate-time 120)
  (setq c-eldoc-cpp-command "/usr/bin/cpp")
  (setq c-eldoc-includes "-I./ -I../")
  ;; keywords
  (font-lock-add-keywords 'c-mode '("typeof" "__attribute__" "__asm__"))
  (font-lock-add-keywords
   'c-mode
   '(("\\<\\([-v]?[0-9\.]+\\)" 1 'font-lock-string-face)
     ("\\<\\(_?[A-Z0-9_]+\\)" 1 'font-lock-constant-face)
     ("\\<\\(\\sw+\\) ?(" 1 'font-lock-function-name-face)
     ("\\(if\\|for\\|while\\)" 1 'font-lock-keyword-face t)
     ))
  )

(add-hook 'c-mode-common-hook
          (lambda ()
            (hong/my-cc-common-config)
            (ggtags-mode 1)))
(add-hook 'c++-mode-hook
          (lambda ()
            (hong/my-c-mode-config)))
(add-hook 'c-mode-hook
          (lambda ()
            (hong/my-c-mode-config)))

(provide 'init-cc-mode)
