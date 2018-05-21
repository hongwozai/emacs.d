;;; .m
(setq auto-mode-alist
      (append (list
               '("\\.m$" . octave-mode)
               '("\\.mat$" . octave-mode))
              auto-mode-alist))

(provide 'init-octave)