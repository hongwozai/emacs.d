;;-------------------------------------------
;;; antlr mode
;;-------------------------------------------
(require-package 'dumb-jump)

(autoload 'dumb-jump-go "dump-jump" "jump to definition" t)

(setq dumb-jump-selector 'ivy)

(core/set-key global
  :state '(normal motion)
  (kbd "gd") 'dumb-jump-go)
