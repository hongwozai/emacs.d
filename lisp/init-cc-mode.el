;;; ===================== eldoc doxygen =======================
;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; ===================== gtk config ===========================
(defun hong/gtk-headers ()
  (let* ((cmd "pkg-config --cflags gtk+-3.0")
         (gtk (split-string
               (shell-command-to-string cmd))))
    (mapcar #'(lambda (x) (substring x 2))
            (remove-if #'(lambda (x) (not (eql (elt x 1) ?I))) gtk))))

(defun hong/my-gtk-config ()
  (interactive)
  (setq-local flycheck-clang-include-path
              (append flycheck-clang-include-path (hong/gtk-headers)))
  (setq-local company-clang-arguments
              (append company-clang-arguments
                      (mapcar #'(lambda (x) (concat "-I" x)) (hong/gtk-headers))))
  (setq-local company-c-headers-path-system
              (append company-c-headers-path-system (hong/gtk-headers)))
  )
;;; ===================== cc mode config ========================
;;; include c/c++, java etc.
(defun cc-common-config ()
  ;; indent
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)
  )

(defun c/c++-mode-config ()
  "C/C++ only"
  ;; indent
  (setq c-electric-pound-behavior '(alignleft))

  ;; related file
  (setq-local cc-search-directories
              '("." "../inc" "../include" "../src" "../source"
                "/usr/include" "/usr/local/include/*"))

  ;; keywords
  (font-lock-add-keywords 'c-mode '("typeof" "__attribute__" "__asm__"))

  ;; company
  (setq-local company-backends
              '(company-c-headers company-clang company-etags company-gtags))
  )

(defun hong/tags-debug-compile-setup (map)
  (define-key map (kbd "C-c C-c") 'project-compile-in-shell)
  (define-key map (kbd "C-c C-s") 'change-compile-command)
  (define-key map (kbd "M-,") 'ggtags-prev-mark)
  (define-key map (kbd "M-.") 'ggtags-find-definition)
  (evil-define-key 'normal map (kbd "M-.") 'ggtags-find-definition)
  (define-key map (kbd "C-M-.") 'ggtags-find-other-symbol)
  (define-key map (kbd "<f6>") 'gdb))

(add-hook 'c-mode-common-hook
          (lambda () (cc-common-config)))

(add-hook 'c++-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup c++-mode-map)))

(add-hook 'c-mode-hook
          (lambda ()
            (c/c++-mode-config)
            (hong/tags-debug-compile-setup c-mode-map)))

(provide 'init-cc-mode)
