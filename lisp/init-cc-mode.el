;;; ===================== ggtags eldoc doxygen ==================
(require-package 'ggtags)

(autoload 'ggtags-create-tags "ggtags" nil t)
(autoload 'ggtags-find-other-symbol "ggtags" nil t)
(autoload 'ggtags-find-definition "ggtags" nil t)
(autoload 'ggtags-find-reference "ggtags" nil t)
(autoload 'ggtags-find-tag-dwim "ggtags" nil t)

(add-hook 'ggtags-mode-hook
          (lambda ()
            (setq ggtags-update-on-save t)
            (setq ggtags-highlight-tag nil)
            (setq ggtags-enable-navigation-keys nil)
            (setq-local imenu-create-index-function #'ggtags-build-imenu-index)
            (define-key ggtags-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)

            ;; remote file slow in eldoc mode
            (let ((file (buffer-file-name)))
              (when (and file (file-remote-p file))
                (eldoc-mode -1)))
            ))

;;; c-eldoc
(require-package 'c-eldoc)
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

(defun hong/my-c-mode-config ()
  ;; key bindings
  (define-key c-mode-map (kbd "C-c C-c") 'hong/shell-compile)
  (define-key c-mode-map (kbd "C-c C-s") 'hong/change-compile-command)
  (define-key c-mode-map (kbd "M-,") 'pop-tag-mark)
  (define-key c-mode-map (kbd "M-.") 'ggtags-find-definition)
  (evil-define-key 'normal c-mode-map (kbd "M-.") 'ggtags-find-definition)
  (define-key c-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)
  (define-key c-mode-map (kbd "<f5>") 'compile)
  (define-key c-mode-map (kbd "<f6>") 'gdb)
  )

(defun hong/my-c++-mode-config ()
  ;; key bindings
  (define-key c++-mode-map (kbd "M-,") 'pop-tag-mark)
  (define-key c++-mode-map (kbd "M-.") 'ggtags-find-definition)
  (evil-define-key 'normal c++-mode-map (kbd "M-.") 'ggtags-find-definition)
  (define-key c++-mode-map (kbd "C-M-.") 'ggtags-find-other-symbol)
  (define-key c++-mode-map (kbd "<f5>") 'compile)
  (define-key c++-mode-map (kbd "<f6>") 'gdb)
  )

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
