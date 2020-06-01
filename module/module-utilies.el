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
;;; ediff
;;-------------------------------------------
(defun epatch-reverse ()
  (interactive)
  (let ((ediff-patch-options "-R -f"))
    (epatch)))

;;-------------------------------------------
;;; gtest snippet
;;-------------------------------------------
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

;;-------------------------------------------
;;; project
;;; PROJECT_DIR_DIR_FILE_H
;;-------------------------------------------
(defun project-file-relative-name ()
  (let ((root-path (projectile-project-root)))
    (if root-path
        (concat
         ;; (projectile-project-name)
         ;; "_"
         (file-relative-name (file-name-sans-extension (buffer-file-name))
                             root-path))
      (file-name-nondirectory (file-name-sans-extension (buffer-file-name))))))