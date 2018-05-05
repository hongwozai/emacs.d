;;; ========================= gtags ==================================
(require-package 'counsel-gtags)
(setq counsel-gtags-auto-update t)

(define-key evil-normal-state-map (kbd "M-.") 'hong/counsel-gtags-find-definition-nowait)
(define-key evil-normal-state-map (kbd "M-,") 'counsel-gtags-go-backward)

(autoload 'counsel-gtags--default-directory "counsel-gtags")

(defvar hong/counsel-gtags-file-size-too-big 50)

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
  (let ((ret (catch 'not-pattern
               (counsel-gtags--select-file 'definition tagname))))
    (if (eq ret 'pattern)
        (message "No Result"))))

(defadvice counsel-gtags--collect-candidates (after hong/cgcc activate)
  (when (not ad-return-value)
    (throw 'not-pattern 'pattern)))

(provide 'init-gtags)