;;; dired
(setq-default diredp-hide-details-initially-flag nil)
(autoload 'dired-jump "dired" "jump current directory")
(add-hook 'dired-load-hook
          (lambda ()
            (require 'dired+)
            (setq dired-recursive-copies 'always)
            (setq dired-recursive-deletes 'always)
            (setq dired-listing-switches "-aluh")
            (setq dired-isearch-filenames t)
            (setq dired-dwim-target t)
            (define-key dired-mode-map (kbd "M-o") 'dired-omit-mode)
            (define-key dired-mode-map [mouse-2] 'dired-find-file)
            (diredp-toggle-find-file-reuse-dir 1)
            ))

(add-hook 'dired-mode-hook
          (lambda ()
            (evil-define-key 'normal dired-mode-map
              "j" 'diredp-next-line
              "k" 'diredp-previous-line
              "n" 'evil-search-next
              "p" 'evil-search-previous
              "H" 'hong--dired-top-line
              "J" 'hong--dired-jump-line
              "L" 'hong--dired-bottom-line
              "+" 'hong--dired-create-directory)

            ;; Attention: also ignore .bin .so etc.
            (setq-local dired-omit-files
                        "^\\.?#\\|^\\.$\\|^\\.[^.].+$")
            (setq dired-omit-verbose nil)
            (dired-omit-mode)
            (hl-line-mode 1)))

;;; ============================= keybindings ==============================
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

;;; ============================= misc ==============================
(defun hong--dired-top-line ()
  (interactive)
  (evil-window-top)
  (dired-next-line 1))

(defun hong--dired-bottom-line ()
  (interactive)
  (evil-window-bottom)
  (dired-previous-line 1))

(defun hong--dired-jump-line ()
  (interactive)
  (let ((ivy-minibuffer-map (copy-tree ivy-minibuffer-map)))
    (define-key ivy-minibuffer-map (kbd "C-m") 'ivy-done)
    (call-interactively #'dired-goto-file)))

(defun hong--dired-create-directory ()
  (interactive)
  (let ((completing-read-function #'completing-read-default))
    (call-interactively #'dired-create-directory)))

(provide 'init-dired)