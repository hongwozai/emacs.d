;;-------------------------------------------
;;; highlight
;;-------------------------------------------
(defun highlight-symbol ()
  (interactive)
  (require 'hi-lock nil t)
  (let ((regexp
         (hi-lock-regexp-okay
          (if (use-region-p)
              ;; region
              (regexp-quote
               (buffer-substring-no-properties
                (region-beginning) (region-end)))
            ;; symbol
            (find-tag-default-as-symbol-regexp)))))
    (if (assoc regexp hi-lock-interactive-patterns)
        (unhighlight-regexp regexp)
      (if (not (use-region-p))
          (highlight-symbol-at-point)
        (deactivate-mark)
        (let* ((hi-lock-auto-select-face t)
               (face (hi-lock-read-face-name)))
          (or (facep face) (setq face 'hi-yellow))
          (hi-lock-face-buffer regexp face))))))

(defun unhighlight-all-symbol ()
  (interactive)
  (unhighlight-regexp t))

;;-------------------------------------------
;;; ahs-mode
;;-------------------------------------------
(require 'auto-highlight-symbol)
(global-auto-highlight-symbol-mode)

(global-set-key [remap evil-goto-definition]
                (lambda () (interactive)
                  (ahs-highlight-now)
                  (ahs-backward-definition)))

(provide 'core-highlight)