;;; ========================= gtags ==================================
(require-package 'counsel-gtags)
(setq counsel-gtags-auto-update t)

(autoload 'counsel-gtags--default-directory "counsel-gtags")

(defvar hong/counsel-gtags-file-size-too-big 5)

(defun hong/counsel-gtags-find-definition-nowait (tagname)
  (interactive
   (list (if (>
              (nth 7 (file-attributes
                      (concat (file-name-as-directory
                               (counsel-gtags--default-directory))
                              "GTAGS")))
              (* hong/counsel-gtags-file-size-too-big 1024 1024))
             (read-string "Pattern: " (thing-at-point 'symbol t))
           (counsel-gtags--read-tag 'definition))))
  (counsel-gtags--select-file 'definition tagname))

(defadvice counsel-gtags--collect-candidates (after hong/cgcc activate)
  (when (not ad-return-value)
    (error "No Result")))

;;; gtags .h is tread as c++ source file
(exec-path-from-shell-setenv "GTAGSFORCECPP" "1")

;;; install
(defun hong/install-gtags ()
  (interactive)
  (require 'counsel-gtags)

  ;; keybinding
  (dolist (mode '(c-mode c++-mode))
    (evil-leader/set-key-for-mode mode
        "gd" 'hong/counsel-gtags-find-definition-nowait
        "gr" 'counsel-gtags-find-reference
        "gs" 'counsel-gtags-find-symbol
        "gc" 'counsel-gtags-create-tags
        "gp" 'counsel-gtags-go-backward))

  (dolist (map '(c-mode-map c++-mode-map))
    (eval `(evil-define-key 'normal ,map
             (kbd "M-.") 'counsel-gtags-find-definition
             (kbd "M-,") 'counsel-gtags-go-backward
             (kbd "M-?") 'counsel-gtags-find-reference))))

(provide 'init-gtags)
