(require 'cl-macs)
(require 'gptel)
(require 'gptel-rewrite)

;;-------------------------------------------
;;; prompt
;;-------------------------------------------
(setq prompt-write-coder
      "你是一个谨慎的编程专家，善于补全代码和完成需求，并且写代码不用解释也不用代码块")

(setq prompt-translate-c2e
      "你是一位翻译家，请将下面的中文文本翻译为英文，不用解释，也不用带引号，并且首字母小写:")

(setq prompt-translate-e2c
      "你是一位翻译家，请将下面的英文文本翻译为中文，不用解释，也不用带引号")

(setq gptel-directives
      `((coder . ,prompt-write-coder)
        (english-translater . ,prompt-translate-e2c)
        (chinese-translater . ,prompt-translate-c2e)))

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
(defun translate-preview  ()
  (interactive)
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


;;-------------------------------------------
;;; aitab
;;-------------------------------------------
(use-package plz :ensure t)

(defvar aitab-backend (gptel-get-backend "Ollama-FIM"))
;; (defvar aitab-backend (gptel-get-backend "DeepSeek-FIM"))
(defvar aitab-maxtokens 54)
(defvar aitab-delay 0.5)

(defvar-local aitab--requests nil)
(defvar-local aitab--response nil "first is point, last is responses")
(defvar-local aitab--timer nil)

(cl-defun aitab--send-request (&key messages prompt suffix params)
  (let* ((backend aitab-backend)
         (url (gptel-backend-url backend))
         (key (gptel-backend-key backend))
         (model (car (gptel-backend-models backend)))
         (request
          (plz 'post url
            :headers `(("Authorization" . ,(concat "Bearer " key))
                       ("Content-Type" . "application/json"))
            :body (json-encode
                   `(,@params
                     :max_tokens ,aitab-maxtokens
                     :model ,model
                     :prompt ,prompt
                     ;; TODO: 这里暂时按行补全，本质应该是一个语法单元
                     :stop "\n"
                     :suffix ,suffix))
            :as (lambda ()
                  (let* ((data (json-read))
                         (text (map-nested-elt data '(choices 0 text))))
                    text))
            :then (apply-partially
                   (lambda (buffer pt text)
                     (with-current-buffer buffer
                       (setq-local aitab--response (list pt text))))
                   (current-buffer)
                   (point))
            :else (lambda (err) (message "plz-error %s" err))
            :connect-timeout 1)))
    (aitab--cancel-requests)
    (setq aitab--requests request)))

(defun aitab--fim ()
  (let ((fim-prefix (buffer-substring-no-properties
                     (point-min) (point)))
        (fim-suffix (buffer-substring-no-properties
                     (point) (point-max))))
    (aitab--send-request
     :prompt fim-prefix
     :suffix fim-suffix)))

(defun aitab--cancel-requests ()
  (when aitab--requests
    (delete-process aitab--requests)
    (setq aitab--requests nil)))

(defun aitab-fim-completion-at-point ()
  (when-let* ((response aitab--response)
              (curpt (point))
              (pt (car response))
              (texts (cdr response)))
    ;; (message "pt %s respt %s text %s" (point) pt texts)
    (when (< pt curpt)
      (list pt curpt texts :exclusive t))))

(defun aitab--timer-function (buffer)
  (with-current-buffer buffer
    (aitab--fim)))

(defun aitab--post-command ()
  (when (memq last-command '(self-insert-command))
    (when aitab--timer
      (cancel-timer aitab--timer)
      (setq-local aitab--timer nil))
    (setq-local aitab--timer
                (run-with-idle-timer aitab-delay
                                     nil
                                     #'aitab--timer-function
                                     (current-buffer)))))

(defun aitab--cleanup ()
  (message "aitab cleanup...")
  (aitab--cancel-requests)
  (when aitab--timer
    (cancel-timer aitab--timer))
  (remove-hook 'completion-at-point-functions #'aitab-fim-completion-at-point t)
  (remove-hook 'post-command-hook 'aitab--post-command t))

;; 实现思路：
;; 子模式固定开启，然后每条command后空闲一定时间去请求后端模型
;; 然后加入completion-at-points中，由用户启用的补全后端使用
;;;###autoload
(define-minor-mode aitab-mode ()
  :global nil
  :init-value nil
  (if aitab-mode
      (progn
        (add-hook 'completion-at-point-functions
                  #'aitab-fim-completion-at-point nil t)
        (add-hook 'post-command-hook 'aitab--post-command nil t))
    (aitab--cleanup)))

(provide 'ai-config)