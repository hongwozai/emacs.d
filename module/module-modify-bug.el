;;-------------------------------------------
;;; modify
;;-------------------------------------------
(defun ivy--occur-insert-lines (cands)
  "Insert CANDS into `ivy-occur' buffer."
  (font-lock-mode -1)
  (dolist (str cands)
    (setq str (ivy--highlight-fuzzy (copy-sequence str)))
    (add-text-properties
     0 (length str)
     '(mouse-face
       highlight
       help-echo "mouse-1: call ivy-action")
     str)
    ;; NOTE: here
    (insert str ?\n))
  (goto-char (point-min))
  (forward-line 4)
  (while (re-search-forward "^[^:]+:[[:digit:]]+:" nil t)
    (ivy-add-face-text-property
     (match-beginning 0)
     (match-end 0)
     'compilation-info
     nil
     t)))
