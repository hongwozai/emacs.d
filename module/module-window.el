;;-------------------------------------------
;;; ace-window
;;-------------------------------------------
(require-package 'ace-window)

(setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
(setq aw-background nil)

(set-face-attribute 'aw-leading-char-face nil
                    :background (face-background 'default) :box nil)
;;-------------------------------------------
;;; key
;;-------------------------------------------
(core/set-key global
  :state '(normal emacs insert motion)
  (kbd "M-o") 'ace-window)
