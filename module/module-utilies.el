;;-------------------------------------------
;;; swiper
;;-------------------------------------------
(defun swiper-at-function ()
  (interactive)
  (save-restriction
   (narrow-to-defun)
   (swiper)))

(defun my-swiper ()
  (interactive)
  (if current-prefix-arg
      (swiper-at-function)
    (swiper)))

(core/set-key global
  :state 'native
  [remap swiper] 'my-swiper)

;;-------------------------------------------
;;; gtest snippet
;;-------------------------------------------
(defun swiper-at-function ()
  (interactive)
  (save-restriction
   (narrow-to-defun)
   (swiper)))
(defvar snippets-gtest-assert-word
      '("EQ"
        "NE"
        "LT"
        "GT"
        "LE"
        "GE"
        "TRUE"
        "FALSE"
        "STREQ"
        "STRNE"
        "STRCASEEQ"
        "STRCASENE"
        "THROW"
        "ANY_THROW"
        "NO_THROW"
        "FLOAT_EQ"
        "DOUBLE_EQ"
        "DEATH"
        "EXIT"))

(defun yasnippets-gtest-assert-word ()
  (ivy-read "Method: " snippets-gtest-assert-word))
