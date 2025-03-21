(require 'gptel)
(require 'gptel-rewrite)

(defvar translate-c2e-prompt
  "请将下面的中文文本翻译为英文，不用解释，也不用带引号，并且首字母小写:")

(defun translate--at-point ()
  (if (use-region-p)
      (let ((beg (use-region-beginning))
            (end (use-region-end)))
        (deactivate-mark)
        (cons beg end))
    (bounds-of-thing-at-point 'symbol)))

;;;###autoload
(defun translate-preview  ()
  (interactive)
  (let* ((pos (translate--at-point))
         (prompt
          (format "%s\n\n%s" translate-c2e-prompt
                  (buffer-substring-no-properties
                   (car pos) (cdr pos))))
         ;; (gptel-backend (gptel-get-backend "Ollama"))
         ;; (gptel-model 'qwen2.5:3b)
         )
    (message "translate start...")
    (gptel-request prompt
      :system "你是一位翻译家"
      ;; :stream t
      :context
      (let ((ov (make-overlay (car pos) (cdr pos) nil t)))
        (overlay-put ov 'category 'gptel)
        (overlay-put ov 'evaporate t)
        (cons ov (generate-new-buffer "*gptel-rewrite*")))
      :callback
      #'gptel--rewrite-callback)))

(provide 'ai-config)