;;; ===================== ggtags eldoc doxygen ==================
;;; c-eldoc
(autoload 'c-turn-on-eldoc-mode "c-eldoc" "" t)

;;; doxygen
(autoload 'doxygen-insert-function-comment "doxygen" "insert comment for the function at point" t)
(autoload 'doxygen-insert-file-comment "doxygen" "insert comment for file" t)

;;; ===================== gtk config ==================
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
  (setq-local c-eldoc-includes
              (concat c-eldoc-includes
                      " `pkg-config gtk+-3.0 --cflags`"))
  )
;;; ===================== cc mode config ==================
;;; include c/c++, java etc.
(defun hong/my-cc-common-config ()
  ;; indent
  (setq c-default-style '((java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)
  )

(defun hong/my-c/c++-mode-config ()
  "C/C++ only"
  ;; indent
  (setq c-electric-pound-behavior '(alignleft))

  ;; c-eldoc
  (c-turn-on-eldoc-mode)
  (setq c-eldoc-buffer-regenerate-time 120)
  (setq c-eldoc-cpp-command "/usr/bin/cpp")
  (setq c-eldoc-includes "-I./ -I../")

  ;; related file
  (setq-local cc-search-directories
              '("." "../inc" "../include" "../src" "../source"
                "/usr/include" "/usr/local/include/*"))

  ;; keywords
  (font-lock-add-keywords 'c-mode '("typeof" "__attribute__" "__asm__"))

  ;; company
  (push 'company-c-headers company-backends)
  )

(defun hong/tags-debug-compile-setup (map)
  (define-key map (kbd "C-c C-c") 'hong/shell-compile)
  (define-key map (kbd "C-c C-s") 'hong/change-compile-command)
  (define-key map (kbd "M-,") 'ggtags-prev-mark)
  (define-key map (kbd "M-.") 'ggtags-find-definition)
  (evil-define-key 'normal map (kbd "M-.") 'ggtags-find-definition)
  (define-key map (kbd "C-M-.") 'ggtags-find-other-symbol)
  (define-key map (kbd "<f6>") 'gdb))

(defun hong/my-c-mode-config ()
  ;; key bindings
  (hong/tags-debug-compile-setup c-mode-map))

(defun hong/my-c++-mode-config ()
  ;; key bindings
  (hong/tags-debug-compile-setup c++-mode-map))

(add-hook 'c-mode-common-hook
          (lambda () (hong/my-cc-common-config)))

(add-hook 'c++-mode-hook
          (lambda ()
            (hong/my-c/c++-mode-config)
            (hong/my-c++-mode-config)))

(add-hook 'c-mode-hook
          (lambda ()
            (hong/my-c/c++-mode-config)
            (hong/my-c-mode-config)))

(provide 'init-cc-mode)
