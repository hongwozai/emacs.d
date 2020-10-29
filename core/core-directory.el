;;-------------------------------------------
;;; dired
;;-------------------------------------------
(with-eval-after-load 'dired
  ;; diredp
  (setq dired-recursive-copies   'always)
  (setq dired-recursive-deletes  'always)
  (setq dired-isearch-filenames  t)
  (setq dired-dwim-target        t)
  (if *is-mac*
      (setq dired-listing-switches "-aluh")
    (setq dired-listing-switches "-aluh --time-style=iso"))

  ;; key
  (core/set-key dired-mode-map
    :state 'native
    (kbd "M-o") 'dired-omit-mode
    [mouse-2]   'dired-find-file)
  (core/set-key dired-mode-map
    :state 'normal
    "j" 'dired-next-line
    "k" 'dired-previous-line
    "n" 'evil-search-next
    "N" 'evil-search-previous))

(add-hook 'dired-mode-hook
          (lambda ()
            (require 'dired-x)
            (setq-local truncate-lines t)
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\.[^.].+$")
            (setq dired-omit-verbose nil)
            (dired-omit-mode)
            (dired-hide-details-mode 1)
            (hl-line-mode 1)))

(provide 'core-directory)
