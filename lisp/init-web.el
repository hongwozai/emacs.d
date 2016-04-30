;;; ======================= web mode ========================
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")))

(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset    2)
(setq web-mode-code-indent-offset   4)

(setq web-mode-enable-auto-pairing  t)
(setq web-mode-enable-css-colorization t)
(setq web-mode-enable-block-face    nil)
(setq web-mode-enable-current-element-highlight t)

;;; emmet-mode
(add-hook 'web-mode-hook 'emmet-mode)

;;; company-web
(add-hook 'web-mode-hook
          (lambda ()
            (set (make-local-variable 'company-backends)
                 '(company-web-html company-yasnippet company-files))))

(provide 'init-web)
