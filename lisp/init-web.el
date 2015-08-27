;;; php
(require-package 'php-mode)
(require 'php-mode)
;;; web mode
(require-package 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")))

;;; javascript
(require-package 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(setq js2-use-font-lock-faces t
      js2-idle-timer-delay 0.5
      js2-indent-on-enter-key t
      js2-auto-indent-p t)

(provide 'init-web)
