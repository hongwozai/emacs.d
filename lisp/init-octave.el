;;; .m
(setq auto-mode-alist
      (append (list
               '("\\.m$" . octave-mode)
               '("\\.mat$" . octave-mode))
              auto-mode-alist))

(add-hook 'octave-mode-hook
          (lambda ()
            (evil-define-key 'normal octave-mode-map
              (kbd "C-c C-c") 'octave-send-buffer)
            (evil-define-key 'insert octave-mode-map
              (kbd "C-c C-c") 'octave-send-buffer)))

(provide 'init-octave)