;;-------------------------------------------
;;; keybinding
;;-------------------------------------------
(core/leader-set-key
  "cs" 'translate-brief-at-point)

;;-------------------------------------------
;;; translate
;;-------------------------------------------
(require-package 'bing-dict)

(defun translate-brief-at-point ()
  (interactive)
  (let ((word (if (use-region-p)
                  (buffer-substring-no-properties
                   (region-beginning) (region-end))
                (thing-at-point 'word t))))
    (if word
        (bing-dict-brief word)
      (message "No Word."))))

;;-------------------------------------------
;;; input method
;;-------------------------------------------
(require-package 'pyim)
(require-package 'pyim-basedict)

;;; default
(require 'pyim)
(setq default-input-method "pyim")

(with-eval-after-load "pyim"
  (require 'pyim-basedict)
  (pyim-basedict-enable)
  (setq pyim-use-tooltip 'popup)
  (setq pyim-page-length 5))

(provide 'module-chinese)