;;-------------------------------------------
;;; environment
;;-------------------------------------------
(prefer-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)

;;-------------------------------------------
;;; translate
;;-------------------------------------------
(require-package 'bing-dict)

(defun core/translate-brief-at-point ()
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

(require 'pyim)
(require 'pyim-basedict)
(pyim-basedict-enable)
(setq default-input-method "pyim")
(setq pyim-use-tooltip 'popup)
(setq pyim-page-length 5)

(provide 'core-chinese)