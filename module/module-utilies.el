;;-------------------------------------------
;;; utilies
;;-------------------------------------------
(defun swiper-at-function ()
  (interactive)
  (save-mark-and-excursion
   (narrow-to-defun)
   (swiper)))
