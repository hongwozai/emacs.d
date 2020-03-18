;;-------------------------------------------
;;; origin highlight
;;-------------------------------------------
(defun core/highlight-symbol ()
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

(defun core/unhighlight-all-symbol ()
  (interactive)
  (unhighlight-regexp t))

;;-------------------------------------------
;;; highlight symbol
;;-------------------------------------------
(require 'highlight-symbol)
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

;;; use remove-all of highlight-symbol
(defalias 'unhighlight-all-symbol 'highlight-symbol-remove-all)

;;; highlight-region
(defun core/highlight-region ()
  (interactive)
  (if (use-region-p)
      (progn
        (highlight-symbol
         (buffer-substring-no-properties (region-beginning) (region-end)))
        (transient-mark-mode 0))
      (highlight-symbol)))

(provide 'core-highlight)