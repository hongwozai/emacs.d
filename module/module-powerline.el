;;-------------------------------------------
;;; cool modeline
;;-------------------------------------------
(require-package 'telephone-line)

;;-------------------------------------------
;;; mode
;;-------------------------------------------
(telephone-line-mode 1)
(setq telephone-line-evil-use-short-tag t)

;;-------------------------------------------
;;; modify
;;-------------------------------------------
(set-face-attribute 'telephone-line-evil-insert nil
                    :background "red3")

(set-face-attribute 'telephone-line-evil-normal nil
                    :background "forest green")
