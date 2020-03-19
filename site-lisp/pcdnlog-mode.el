(setq pcdnlog-font-lock-keywords
  '(("\\([[:digit:]]\\{4\\}-[[:digit:]]\\{2\\}-[[:digit:]]\\{2\\}[[:space:]][[:digit:]]\\{2\\}:[[:digit:]]\\{2\\}:[[:digit:]]\\{2\\}.[[:digit:]]\\{2,4\\}\\)" 1 'font-lock-type-face append)
    ("\\[[0-9]+:0x[A-Fa-f0-9]*\\]" 0 'font-lock-comment-face append)
    ("\\[[a-zA-Z_\\-0-9]+\\.cpp-[0-9a-zA-Z~_]+:[[:digit:]]+\\]" 0 'font-lock-comment-face append)
    ("\\[[[:alpha:]]+\\([[:space:]]+id:[[:space:]]*[[:digit:]]+\\)?\\]" 0 'font-lock-keyword-face append)
    ("[[:digit:]]\\{1,3\\}\\.[[:digit:]]\\{1,3\\}\\.[[:digit:]]\\{1,3\\}\\.[[:digit:]]\\{1,3\\}" 0 'font-lock-string-face append)
    ("[tT][aA][sS][kK][iI][dD][[:space:]+]\\([[:digit:]]+\\)" 0 'font-lock-string-face append)
))

(defun pcdnlog-hide-all-time ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((loop-var t))
      (while loop-var
        (let* ((pos (re-search-forward
                     "^[[:space:][:digit:]-:.]+\\[[^]]+\\] . \\[[^]]+\\]"
                     nil
                     t))
               (ov (make-overlay (line-beginning-position)
                                 (or pos (+ (line-beginning-position) 46)))))
          (overlay-put ov 'invisible t))
        (setq loop-var (= 0 (forward-line 1)))))))

(defun pcdnlog-show-all-time ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (let ((loop-var t))
      (while loop-var
        (let* ((pos (re-search-forward
                     "^[[:space:][:digit:]-:.]+\\[[^]]+\\] . \\[[^]]+\\]"
                     nil
                     t))
              (ovs (overlays-in (line-beginning-position)
                                (or pos (+ (line-beginning-position) 46)))))
          (mapcar #'delete-overlay ovs))
        (setq loop-var (= 0 (forward-line 1)))))))

;;;###autoload
(defun pcdnlog-mode ()
  "pcdn log"
  (interactive)
  (kill-all-local-variables)
  (setq mode-name "pcdnlog")
  (setq major-mode 'pcdnlog-mode)

  (make-local-variable 'font-lock-defaults)
  (setq font-lock-defaults '(pcdnlog-font-lock-keywords t t nil))
  (buffer-disable-undo)
  (toggle-read-only 1)
  ;; (run-hooks 'pcdnlog-mode-hook)
  )

(add-to-list 'auto-mode-alist
             '("teg-pcdnvodsdk.txt.xlog" . pcdnlog-mode))

(provide 'pcdnlog-mode)