;;-------------------------------------------
;;; font size
;;-------------------------------------------
(defun font-size-scale (num &optional step)
  (let ((height (face-attribute 'default :height))
        (step (or step 1)))
    (set-face-attribute
     'default nil :height (+ (* num step) height))))

