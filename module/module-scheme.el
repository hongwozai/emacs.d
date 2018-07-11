;;-------------------------------------------
;;; interper
;;-------------------------------------------
(setq scheme-program-name "guile")

(add-hook 'scheme-mode-hook
          (lambda ()
            (require 'cmuscheme)
            (core/leader-set-key-for-mode 'scheme-mode
              "xe" 'scheme-send-last-sexp
              "cr" 'scheme-send-region
              "cf" 'scheme-send-definition
              "cc" (lambda () (interactive)
                     (scheme-send-region (point-min) (point-max))))))
