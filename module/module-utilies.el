;;-------------------------------------------
;;; utilies
;;-------------------------------------------
(defun swiper-at-function ()
  (interactive)
  (save-restriction
   (narrow-to-defun)
   (swiper)))
