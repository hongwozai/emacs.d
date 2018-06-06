;;-------------------------------------------
;;; install
;;-------------------------------------------
(require-package 'ivy)
(require-package 'counsel)
(require-package 'swiper)
(require-package 'hydra)
(require-package 'ivy-hydra)
;;; for sort
(require-package 'smex)
;; for defhydra ivy-hydra
(require 'hydra)

;;-------------------------------------------
;;; ivy mode
;;-------------------------------------------
(setq ivy-height                12
      ivy-format-function       'ivy-format-function-arrow
      ivy-count-format          "[%d/%d] "
      ivy-extra-directories     nil
      ivy-use-virtual-buffers   t
      ivy-initial-inputs-alist  nil)

(ivy-mode t)
(counsel-mode t)

;;; height
(ignore-errors
 (setcdr (assoc 'counsel-yank-pop ivy-height-alist) ivy-height))
;;-------------------------------------------
;;; config
;;-------------------------------------------
(core/set-key ivy-minibuffer-map
    :state 'native
    (kbd "C-m") 'ivy-alt-done
    (kbd "C-j") 'ivy-immediate-done)

;; replace ido
(fset 'ido-completing-read 'ivy-completing-read)

(provide 'core-completion)
