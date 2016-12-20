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

;;; keybindings
(add-hook 'web-mode-hook
          (lambda ()
            (evil-define-key 'normal web-mode-map
              (kbd "za") 'web-mode-fold-or-unfold)))

;;; php-web checker
(flycheck-define-checker php-web
  "A PHP syntax checker using the PHP command line interpreter.

See URL `http://php.net/manual/en/features.commandline.php'."
  :command ("php" "-l" "-d" "error_reporting=E_ALL" "-d" "display_errors=1"
                  "-d" "log_errors=0" source)
  :error-patterns
  ((error line-start (or "Parse" "Fatal" "syntax") " error" (any ":" ",") " "
          (message) " in " (file-name) " on line " line line-end))
  :modes (web-mode)
  :next-checkers ((warning . php-phpmd)
                  (warning . php-phpcs)))

(provide 'init-web)
