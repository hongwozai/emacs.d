;;-------------------------------------------
;;; font size
;;-------------------------------------------
(defun font-size-scale (num &optional step)
  (let ((height (face-attribute 'default :height))
        (step (or step 1)))
    (set-face-attribute
     'default nil :height (+ (* num step) height))))


;;-------------------------------------------
;;; patch
;;-------------------------------------------
;; avy-isearch patch
;; set isearch-other-end point
(with-eval-after-load 'avy
  (defun avy-isearch ()
    "Jump to one of the current isearch candidates."
    (interactive)
    (avy-with avy-isearch
      (let ((avy-background nil)
            (avy-case-fold-search case-fold-search))
        (let ((bounds
               (avy-process
                (avy--regex-candidates
                 (if isearch-regexp
                     isearch-string
                   (regexp-quote isearch-string))))))
          (setq isearch-other-end (car bounds))
          (isearch-done)
          bounds)))))

(provide 'misc-funcs)