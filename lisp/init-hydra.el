(require 'hydra)
;;; dired
(defhydra hydra-dired-select-menu (:color pink :hint nil)
  "
          ^Mark^
    ^^^^^^^^----------------------------
      _._: [un]mark extension
      _%_: regexp
      _/_: all directory
      _t_: toggle marks
      _!_: unmark all mark
^
"
  ("." diredp-mark/unmark-extension)
  ("%" dired-mark-files-regexp)
  ("/" dired-mark-directories)
  ("t" dired-toggle-marks)
  ("!" dired-unmark-all-marks)
  ("q" nil "quit" :color blue))

(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "*") 'hydra-dired-select-menu/body))

(provide 'init-hydra)