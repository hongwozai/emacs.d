;;-------------------------------------------
;;; js develop environment
;;-------------------------------------------
(module-require-manual)
(require-package 'indium)

(autoload 'indium-interaction-mode "indium" "indium" t)

(add-hook 'js-mode-hook 'indium-interaction-mode)
(add-hook 'js2-mode-hook 'indium-interaction-mode)

(evil-set-initial-state 'indium-repl-mode 'emacs)

(core/set-key indium-repl-mode-map
  :state 'emacs
  (kbd "C-p") #'indium-repl-previous-input
  (kbd "C-n") #'indium-repl-next-input
  (kbd "C-u") #'kill-whole-line
  (kbd "C-l") #'indium-repl-clear-output)