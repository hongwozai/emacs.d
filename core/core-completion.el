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
(setq ivy-height                  12
      ivy-format-function         'ivy-format-function-arrow
      ivy-count-format            "[%d/%d] "
      ivy-extra-directories       nil
      ivy-use-virtual-buffers     t
      ivy-initial-inputs-alist    nil)

(ivy-mode t)
(counsel-mode t)

;; ignore hidden files(input . display)
(setq counsel-find-file-ignore-regexp "\\`\\.")

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

;;; xref use ivy-read
(autoload 'ivy-xref-show-xrefs "ivy-xref")
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs)

(provide 'core-completion)
