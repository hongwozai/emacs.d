(require 'json)

(defun llm-api--log (msg)
  (message "[llm-api] curl args %s" msg))

;; curl url -H "xxx: xxx" -d json
(defun llm-api--get-curl-args (url other-headers body temp)
  (let* ((headers
          (append '(("Content-Type" . "application/json"))
                  other-headers))
         (data-json (encode-coding-string
                     (json-encode body)
                     'utf-8)))
    (append
     (list "-XPOST" "--silent" "-D-")
     (cl-loop for (key . val) in headers
              collect (format "-H%s: %s" key val))
     (list (format "-d%s" data-json))
     (list url))))

(defun llm-api--curl-cleanup (process status)
  ;; TODO: if status not equal xxx
  (let ((code (process-get process 'http-code))
        (body-file (process-get process 'body-file))
        (buffer (process-buffer process))
        (cleanup (process-get process 'finished)))
  (message "process %s code %s status %s"
           process code status)
    (when cleanup
      (funcall cleanup process code status))
    (when (file-exists-p body-file)
      (delete-file body-file))
    (kill-buffer buffer)
    ))

(defun llm-api--parse-code (process)
  (goto-char (point-min))
  (let ((line (buffer-substring-no-properties
               (line-beginning-position)
               (line-end-position))))
    (if (string-match "^HTTP/1.1 +\\([0-9]+\\) +\\(.*\\)$" line)
        (string-to-number (match-string 1 line))
      'fail)))

(defun llm-api--parse-stream (process)
  (with-current-buffer (process-buffer process)
    (let (content)
      (while (re-search-forward "^data:" nil t)
        (save-match-data
          (if (looking-at " *\\[DONE\\]")
              ;; the stream has ended
              nil
            ;; continue
            (when-let* ((json-object-type 'plist)
                        (response (ignore-errors (json-read)))
                        (delta
                         (map-nested-elt
                          response '(:choices 0 :delta))))
              ;; (message "response %s" delta)
              (push (plist-get delta :content) content)))))
      (apply #'concat (nreverse content)))))

(defun llm-api--curl-filter (process output)
  (with-current-buffer (process-buffer process)
    (save-excursion
      (goto-char (process-mark process))
      (insert output)
      (set-marker (process-mark process) (point)))
    ;; first we parse http code and messages
    (unless (process-get process 'http-code)
      (process-put process 'http-code
                   (llm-api--parse-code process))
      (re-search-forward "^$" nil t)
      )
    ;; second we check stream data:
    (when (memq (process-get process 'http-code)
                '(200))
      (when-let* ((str (llm-api--parse-stream process))
                  (callback (process-get process 'then)))
        (funcall callback process str)))))

(cl-defun llm-api-request (&key url headers model messages optional
                             then finished)
  (let* ((body-no-msg `(,@optional :model ,model :stream t))
         ;; generate chat completions
         (body (if messages
                   (append (list :messages (vconcat messages))
                           body-no-msg)
                 body-no-msg))
         ;; generate tempfile name
         (temp (format "%s%s" (temporary-file-directory)
                       (make-temp-name "llm-api-body-")))
         ;; curl args
         (curl-args (llm-api--get-curl-args url headers body temp))
         ;; start curl process
         (process (apply #'start-process "llm-curl"
                         (generate-new-buffer "*llm-curl*")
                         "curl"
                         curl-args)))
    (llm-api--log (process-command process))
    (process-put process 'http-code nil)
    (process-put process 'then then)
    (process-put process 'body-file temp)
    (process-put process 'finished finished)
    (set-process-coding-system process 'utf-8-unix 'utf-8-unix)
    (with-current-buffer (process-buffer process)
      (set-process-query-on-exit-flag process nil)
      (set-process-sentinel process #'llm-api--curl-cleanup)
      (set-process-filter process #'llm-api--curl-filter)
      )
    process))

;; (llm-api-request
;;  :url "http://127.0.0.1:11434/v1/chat/completions"
;;  ;; :headers '(("Authorization" . "Bearer xxx"))
;;  :model "qwen2.5:3b"
;;  :messages
;;  `((:role "system" :content "you is a coder")
;;    (:role "user" :content "please write a quick sort, use python"))
;;  ;; :then (lambda (proc str) (message "%s" str))
;;  )

(provide 'llm-api)