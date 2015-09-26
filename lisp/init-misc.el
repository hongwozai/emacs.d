;;; bison
(require-package 'bison-mode)
(eval-after-load 'bison-mode
  '(progn
     (setq bison-all-electricity-off t)
     (setq bison-rule-separator-column 8)
     (setq bison-rule-enumeration-column 16)
     (setq bison-decl-type-column 8)
     (setq bison-decl-token-column 0)
     (define-key bison-mode-map [remap bison-indent-line]
       '(lambda () (interactive)
          (save-excursion (move-beginning-of-line 1)
                          (insert "    "))))))

;;; antlr
(autoload 'antlr-mode "antlr-mode" nil t)
(autoload 'antlr-v4-mode "antlr-mode" nil t)
(push '("\\.g4\\'" . antlr-v4-mode) auto-mode-alist)

;;; markdown-mode
(require-package 'markdown-mode)
(setq auto-mode-alist
      (append '(("\\.md\\'" . markdown-mode))
              auto-mode-alist))

;; cmake
(require-package 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode))
              '(("\\.cmake\\'" . cmake-mode))
              auto-mode-alist))

;;; guide-key
(require-package 'guide-key)
(setq guide-key/guide-key-sequence `(",p" ",xv" ",g" ",w"
                                     ",b" ",h" ",u" ",s"
                                     ",a" "C-x v"
                                     (org-mode "C-c") "C-x 4" "C-x 5"))
(guide-key-mode 1)
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/idle-delay 0.1)
(setq guide-key/popup-window-position 'bottom)
(setq guide-key/text-scale-amount -0.3)

(provide 'init-misc)
