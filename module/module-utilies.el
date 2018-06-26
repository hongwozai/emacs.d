;;-------------------------------------------
;;; utilies
;;-------------------------------------------
(defun swiper-at-function ()
  (interactive)
  (save-restriction
   (narrow-to-defun)
   (swiper)))

;;; gtest snippet
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