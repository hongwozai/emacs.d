;;; ===================== cc mode config ========================
;;; include c/c++, java etc.
(defun cc-common-config ()
  ;; indent
  (setq c-default-style '((c-mode . "linux")
                          (java-mode . "java")
                          (awk-mode . "awk")
                          (other . "k&r"))
        c-basic-offset  4)

  ;; auto delete
  (c-toggle-hungry-state 1)
  )

(defun c/c++-mode-config ()
  "C/C++ only"
  ;; indent (# left align)
  (setq c-electric-pound-behavior '(alignleft))

  (c-set-offset 'inline-open 0)

  ;; related file
  (setq-local cc-search-directories
              '("." ".."
                "../inc" "../Inc"
                "../include" "../Include"
                "../src" "../source"
                "../Src" "../Source"
                "/usr/include" "/usr/local/include/"))

  ;; keywords
  (font-lock-add-keywords nil '("typeof" "__attribute__" "__asm__") t)

  ;; company
  (setq-local company-backends
              '(company-etags company-gtags company-c-headers company-clang))

  )

(add-hook 'c-mode-common-hook (lambda () (cc-common-config)))
(add-hook 'c++-mode-hook (lambda () (c/c++-mode-config)))
(add-hook 'c-mode-hook (lambda () (c/c++-mode-config)))

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(provide 'init-cc-mode)
