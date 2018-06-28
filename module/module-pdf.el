;;-------------------------------------------
;;; pdf tools (need run pdf-tools-install)
;;-------------------------------------------
(module-require-manual)
(require-package 'pdf-tools)

;;-------------------------------------------
;;; install pdf tools
;;-------------------------------------------
(with-eval-after-load "pdf-tools"
  (evil-set-initial-state 'pdf-view-mode 'normal)
  (core/set-key pdf-view-mode-map
    :state '(normal motion emacs)
    "j"   'pdf-view-next-line-or-next-page
    "k"   'pdf-view-previous-line-or-previous-page
    "h"   'image-backward-hscroll
    "l"   'image-forward-hscroll
    "G"   'pdf-view-goto-page
    "f"   'pdf-view-next-page
    "b"   'pdf-view-previous-page
    "d"   'pdf-view-scroll-up-or-next-page
    "u"   'pdf-view-scroll-down-or-previous-page
    (kbd "SPC") 'pdf-view-scroll-up-or-next-page
    (kbd "DEL") 'pdf-view-scroll-down-or-previous-page
    "o"   'pdf-outline
    "+"   'pdf-view-enlarge
    "-"   'pdf-view-shrink
    "0"   'pdf-view-scale-reset
    "v"   'pdf-view-midnight-minor-mode
    "q"   'quit-window)

  ;; pdf-view-midnight-minor-mode
  (setq pdf-view-midnight-colors
      `(,(face-foreground 'default) . ,(face-background 'default)))
  )

(pdf-tools-install)
