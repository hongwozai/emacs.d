;; winner 
(require 'winner)
(winner-mode)

;; speedbar
(require-package 'sr-speedbar)
(setq speedbar-use-images nil)
(setq sr-speedbar-max-width 30)

;; window numbering
(require-package 'window-numbering)
(window-numbering-mode)

(provide 'init-window)
