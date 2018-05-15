;;; ======================== header line =================================
;;; header line
(add-hook 'term-mode-hook #'term-mode-header-line-setup)

(defun hong--term-mode-buffer-list ()
  (mapcar
   (lambda (x) (let ((name (buffer-name x)))
            (if (eq name (buffer-name))
                (propertize (format "[%s] " name)
                            'face
                            '((:background "#5F5F5F")))
                (format "[%s] " name))))
   multi-term-buffer-list))

(defun term-mode-header-line-setup ()
  (setq-local header-line-format
              '((:eval (hong--term-mode-buffer-list)))))

;;; ======================== multi-term ==================================
(autoload 'multi-term-prev "multi-term" nil t)
(autoload 'multi-term-next "multi-term" nil t)
(autoload 'multi-term      "multi-term" nil t)
(setq multi-term-program "/bin/bash")
(add-hook 'term-mode-hook
          (lambda ()
            ;; compatiable
            (setq-local evil-move-cursor-back nil)
            (setq-local evil-escape-inhibit t)
            ;; term
            (setq multi-term-switch-after-close nil)
            (setq multi-term-dedicated-select-after-open-p t)
            (setq multi-term-scroll-to-bottom-on-output 'others)
            (setq term-buffer-maximum-size 0)
            ;; multi-term keybinding
            (term-set-escape-char ?\C-c)
            (setq term-unbind-key-list '("C-x"))
            (setq term-bind-key-alist
                  '(("C-l" . switch-to-buffer)
                    ("C-f" . hong/ido-find-file-with-use-ffip)
                    ("M-:" . eval-expression)
                    ("M-w" . kill-ring-save)
                    ("C-y" . term-paste)
                    ("<C-backspace>" . term-send-raw-meta)
                    ("M-d" . term-send-forward-kill-word)
                    ("M-x" . execute-extended-command)
                    ("M-]" . multi-term-next)
                    ("TAB" . (lambda () (interactive)
                                (term-send-raw-string "\t")))
                    ("<escape>" . (lambda () (interactive)
                                     (term-send-raw-string "")))))
            ))
;;; ======================== tramp-term ==================================
(autoload 'tramp-term "tramp-term" nil t)
(defadvice tramp-term--create-term (after hong-ttct activate)
  (with-current-buffer ad-return-value
    (unless (featurep 'multi-term)
      (require 'multi-term))
    (setq multi-term-buffer-list
          (nconc multi-term-buffer-list (list ad-return-value)))
    (multi-term-internal)))

;;; ============================= misc ===================================
(defalias 'mt   'multi-term)
(defalias 'tt   'tramp-term)
(defalias 'mtdo 'multi-term-dedicated-open)

(provide 'init-term)