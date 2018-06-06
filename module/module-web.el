;;-------------------------------------------
;;; package
;;-------------------------------------------
(require-package 'web-mode)
(require-package 'company-web)
(require-package 'emmet-mode)

;;-------------------------------------------
;;; file type
;;-------------------------------------------
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;;-------------------------------------------
;;; config
;;-------------------------------------------
(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("django" . "\\.djhtml\\'")))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset    2)
(setq web-mode-code-indent-offset   4)

(setq web-mode-enable-auto-pairing  t)
(setq web-mode-enable-css-colorization t)
(setq web-mode-enable-block-face    nil)
(setq web-mode-enable-current-element-highlight t)

;;; emmet-mode
(add-hook 'web-mode-hook
          (lambda ()
            (emmet-mode)
            (setq-local electric-pair-inhibit-predicate
                        `(lambda (c)
                           (if (char-equal c ?\{)
                               t
                             (,electric-pair-inhibit-predicate c))))))

;;; company-web
(add-hook 'web-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '(company-web-html company-yasnippet company-files))))

;;; keybindings
(add-hook 'web-mode-hook
          (lambda ()
            (core/set-key web-mode-map
              :state 'normal
              "za" 'web-mode-fold-or-unfold)))
