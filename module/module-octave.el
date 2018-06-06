;;-------------------------------------------
;;; octave (builtin)
;;-------------------------------------------
;;; .m
(setq auto-mode-alist
      (append (list
               '("\\.m$" . octave-mode)
               '("\\.mat$" . octave-mode))
              auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (core/set-key octave-mode-map
              :state 'normal
              (kbd "C-c C-c") 'octave-send-buffer)))
