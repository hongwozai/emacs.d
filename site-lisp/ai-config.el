;;-------------------------------------------
;;; ai request
;;-------------------------------------------
(use-package gptel :ensure t :defer t
  :bind
  (("M-i s" . #'gptel-menu))
  (("M-i r" . #'gptel-rewrite))
  :autoload
  (gptel-request)
  :config
  ;; ollama
  (gptel-make-ollama "Ollama"
          :host "127.0.0.1:11434"
          :stream t
          :models '(qwen2.5-coder:3b qwen2.5:3b))

  (gptel-make-ollama "Ollama-FIM"
          :host "127.0.0.1:11434"
          :models '(qwen2.5-coder:7b)
          :endpoint "/v1/completions")

  ;; deepseek
  (gptel-make-deepseek "DeepSeek"
    :stream t
    :key gptel-api-key)

  (gptel-make-deepseek "DeepSeek-FIM"
    :key gptel-api-key
    :endpoint "/beta/completions"
    :models '(deepseek-chat))

  (gptel-make-openai "SiliconFlow"
    :stream t
    :host "api.siliconflow.cn"
    :key gptel-api-key
    :models '(Qwen/QwQ-32B Pro/deepseek-ai/DeepSeek-V3))

  ;; default
  (setq gptel-model 'qwen2.5:3b)
  (setq gptel-backend (gptel-get-backend "Ollama"))
  )

(use-package copilot :ensure t :defer t
  :bind
  (("M-i t" . #'copilot-mode))
  :config
  (define-key copilot-completion-map (kbd "M-/") 'copilot-accept-completion))

;;-------------------------------------------
;;; prompt
;;-------------------------------------------
(defun read-file-context (file)
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-substring-no-properties (point-min) (point-max))))

(defun read-all-prompt ()
  (let ((dir (locate-user-emacs-file "site-lisp/prompts"))
        (prompts '()))
    (dolist (fname (directory-files dir t ".*\.md$") prompts)
      (let ((name (file-name-base fname)))
        (push (cons (intern name) (read-file-context fname))
            prompts)))))

(setq prompt-write-coder
      "你是一个谨慎的编程专家，善于补全代码和完成需求，并且写代码不用解释也不用代码块")

(setq prompt-translate-c2e
      "你是一位翻译家，请将下面的中文文本翻译为英文，不用解释，也不用带引号，并且首字母小写:")

(setq gptel-directives
      `((default . ,prompt-write-coder)
        (chinese-tranlate . ,prompt-translate-c2e)
        ,@(read-all-prompt)))

;;-------------------------------------------
;;; translate
;;-------------------------------------------
(defun translate--at-point ()
  (if (use-region-p)
      (let ((beg (use-region-beginning))
            (end (use-region-end)))
        (deactivate-mark)
        (cons beg end))
    (bounds-of-thing-at-point 'symbol)))

;;;###autoload
(defun translate-preview ()
  (interactive)
  (require 'gptel-rewrite nil t)
  (let* ((pos (translate--at-point))
         (prompt
          (format "%s\n\n%s" prompt-translate-c2e
                  (buffer-substring-no-properties
                   (car pos) (cdr pos)))))
    (message "translate start...")
    (gptel-request prompt
      :system "你是一位翻译家"
      :context
      (let ((ov (make-overlay (car pos) (cdr pos) nil t)))
        (overlay-put ov 'category 'gptel)
        (overlay-put ov 'evaporate t)
        (cons ov (generate-new-buffer "*gptel-rewrite*")))
      :callback
      #'gptel--rewrite-callback)))

;; bind
(global-set-key (kbd "M-i e") 'translate-preview)

;;-------------------------------------------
;;; merge
;;-------------------------------------------

(provide 'ai-config)