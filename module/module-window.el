;;-------------------------------------------
;;; ace-window
;;-------------------------------------------
(require-package 'ace-window)

(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-background nil)

;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/set-key global
  :state '(normal emacs insert motion)
  (kbd "M-o") 'ace-window)
