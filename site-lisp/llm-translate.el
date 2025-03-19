(require 'llm-api)

(defface translate-overwrite-face
  '((t :inherit highlight))
  "face use for displaying overwrite preview")

(defvar translate--content-list nil)
(defvar translate--content nil)
(defvar translate--overlay nil)
(defvar translate--bound nil)

(defvar-keymap translate-preview-mode-map
  :full nil
  "TAB" 'translate--preview-accept
  "RET" 'translate--preview-accept
  "DEL" 'translate--preview-reject
  )

(defvar translate-preview-mode-map-alist
  `((t . ,translate-preview-mode-map)))

(define-minor-mode translate-preview-mode
  "preview mode"
  :init-value nil
  :keymap translate-preview-mode-map
  (if translate-preview-mode
      (progn
        (add-to-list 'emulation-mode-map-alists 'translate-preview-mode-map-alist)
        ;; (setq overriding-local-map translate-preview-mode-map)
        )
    (translate--cleanup))
  )

(defun translate--cleanup ()
  (message "translate cancel...")
  (when translate--overlay
    (delete-overlay translate--overlay))
  (when translate--content-list
    (setq translate--content-list nil))
  (when translate--bound
    (setq translate--bound nil))
  (setq overriding-local-map nil)
  (setq emulation-mode-map-alists
        (delete 'translate-preview-mode-map-alist emulation-mode-map-alists))
  (remove-hook 'post-command-hook
               #'translate--preview-reject))

(defun translate--at-point ()
  (if (use-region-p)
      (let ((beg (use-region-beginning))
            (end (use-region-end)))
        (deactivate-mark)
        (cons beg end))
    (bounds-of-thing-at-point 'symbol)))

(defun translate--overlay-overwrite ()
  (let* ((bound translate--bound)
         (text translate--content)
         (ov (make-overlay (car bound) (cdr bound))))
    (overlay-put ov 'face 'translate-overwrite-face)
    (overlay-put ov 'display text)
    (overlay-put ov 'evaporate t)
    (setq translate--overlay ov)
    ;; goto position
    (goto-char (car bound))
    (add-hook 'post-command-hook
               #'translate--preview-reject)
    (translate-preview-mode 1)))

(defun translate--cursor-moved-p ()
  (and translate--bound
       (<= (car translate--bound) (point))
       (>= (cdr translate--bound) (point))))

(defun translate--preview-accept ()
  (interactive)
  (when-let* ((bound translate--bound)
              (text translate--content)
              (ov translate--overlay))
    (delete-region (car bound) (cdr bound))
    (insert text)
    (translate-preview-mode -1)))

(defun translate--preview-reject ()
  (interactive)
  (translate-preview-mode -1))

;;;###autoload
(defun translate-preview ()
  (interactive)
  (when-let* ((pos (translate--at-point)))
    (translate--cleanup)
    (setq translate--bound pos)
    (message "translate start...")
    (llm-api-request
     :url "http://127.0.0.1:11434/v1/chat/completions"
     :model "qwen2.5:3b"
     :messages
     `((:role "system" :content "你是一位翻译家")
       (:role "user" :content ,(format "请将下面的中文文本翻译为英文，不用解释，也不用带引号:\n\n%s"
                                       (buffer-substring-no-properties
                                        (car pos) (cdr pos)))))
     :then
     (lambda (proc str) (push str translate--content-list))
     :finished
     (lambda (proc code status)
       (setq translate--content
             (apply #'concat (reverse translate--content-list)))
       (translate--overlay-overwrite)))
    ))

(provide 'llm-translate)