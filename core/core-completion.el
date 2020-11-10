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
(setq ivy-height                  15
      ivy-format-function         'ivy-format-function-arrow
      ivy-count-format            "[%d/%d] "
      ivy-extra-directories       nil
      ivy-use-virtual-buffers     t
      ivy-initial-inputs-alist    nil
      enable-recursive-minibuffers t)

(ivy-mode t)
(counsel-mode t)

;; ignore hidden files(input . display)
(setq counsel-find-file-ignore-regexp "\\`\\.")

;;; use counsel-git-grep performance problem
(setq counsel--git-grep-count-threshold 2000)

;;; height
(ignore-errors
 (setcdr (assoc 'counsel-yank-pop ivy-height-alist) ivy-height))

(setq ivy-display-functions-alist nil)

;;-------------------------------------------
;;; config
;;-------------------------------------------
(core/set-key ivy-minibuffer-map
    :state 'native
    (kbd "C-m") 'ivy-alt-done
    (kbd "C-j") 'ivy-immediate-done
    (kbd "C-i") 'ivy-insert-symbol-at-point
    (kbd "C-s") 'ivy-restrict-to-matches)

(core/set-key ivy-occur-grep-mode-map
  :state '(emacs motion normal)
  (kbd "n")   'ivy-occur-next-line
  (kbd "p")   'ivy-occur-previous-line)

;; replace ido
(fset 'ido-completing-read 'ivy-completing-read)

;;; xref use ivy-read
(autoload 'ivy-xref-show-xrefs "ivy-xref")
(autoload 'ivy-xref-show-defs "ivy-xref")
(setq xref-show-xrefs-function #'ivy-xref-show-xrefs)
(when (>= emacs-major-version 27)
  (setq xref-show-definitions-function #'ivy-xref-show-defs))

;;; ivy-occur
(evil-set-initial-state 'ivy-occur-mode 'emacs)

;;-------------------------------------------
;;; funcs
;;-------------------------------------------
(defun ivy-insert-symbol-at-point ()
  "Pull next word from buffer into search string."
  (interactive)
  (let (query)
    (with-ivy-window
      (let ((tmp (symbol-at-point)))
        (setq query tmp)))
    (when query
      (insert (format "%s" query)))))

(provide 'core-completion)
