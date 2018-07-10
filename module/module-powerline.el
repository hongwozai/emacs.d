;;-------------------------------------------
;;; cool modeline
;;-------------------------------------------
(require-package 'telephone-line)

;;-------------------------------------------
;;; mode
;;-------------------------------------------
;;; not display flycheck
(setq telephone-line-rhs
      '((nil    . (telephone-line-misc-info-segment))
        (accent . (telephone-line-major-mode-segment))
        (evil   . (telephone-line-airline-position-segment))))

(telephone-line-mode 1)
(setq telephone-line-evil-use-short-tag t)

;;-------------------------------------------
;;; modify
;;-------------------------------------------
(set-face-attribute 'telephone-line-evil-insert nil
                    :background "red3")

(set-face-attribute 'telephone-line-evil-normal nil
                    :background "forest green")
