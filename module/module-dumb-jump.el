;;-------------------------------------------
;;; antlr mode
;;-------------------------------------------
(require-package 'dumb-jump)

(autoload 'dumb-jump-go "dumb-jump" "jump to definition" t)

(setq dumb-jump-selector 'ivy)

(core/set-key global
  :state '(normal motion)
  (kbd "gd") 'dumb-jump-go)

(defun dumb-jump-get-project-root (filepath)
  "(Modify) Keep looking at the parent dir of FILEPATH until a denoter file/dir is found."
  (s-chop-suffix
   "/"
   (f-expand
    (or
     ;; my add
     (projectile-project-root filepath)
     dumb-jump-project
     (locate-dominating-file filepath #'dumb-jump-get-config)
     dumb-jump-default-project))))