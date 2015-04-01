(setq scheme-program-name "mit-scheme")

(defun hong/run-scheme ()
  "hong's function to run mit-scheme"
  (interactive)
  (split-window-below)
  (other-window 1)
  (run-scheme scheme-program-name)
  (other-window 1))


(provide 'init-lisp)
