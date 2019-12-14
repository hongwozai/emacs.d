;;-------------------------------------------
;;; theme
;;-------------------------------------------
(require-package 'autothemer)
(require 'zy-dark-theme)

;;-------------------------------------------
;;; moe light themes
;;-------------------------------------------
(require-package 'moe-theme)

;;-------------------------------------------
;;; switch themes
;;-------------------------------------------
(defvar current-theme 'zy-dark)
(defvar current-switch-themes '(moe-light zy-dark))

(load-theme current-theme t)

;;; switch theme to current-theme's next in themes
(defun one-key-switch-theme (current-theme themes order)
  (let (theme (index 0) (themes-length (length themes)))
    (find-if (lambda (x) (setq index (1+ index)) (equal x current-theme))
             themes)
    (if (eq order 'next)
        (setq index (% index themes-length))
      (setq index (% (+ (- index 2) themes-length) themes-length)))
    (setq current-theme (nth index themes))
    (load-theme current-theme t nil)
    (message "Switch Theme [%s]" (symbol-name current-theme))
    current-theme))

(defhydra hydra-color-switch (:color amaranth :hint nil)
  "Switch Color"
  ("h" (lambda () (interactive)
         (setq current-theme
               (one-key-switch-theme
                current-theme current-switch-themes 'prev)))
   "prev-theme")
  ("l" (lambda () (interactive)
         (setq current-theme
               (one-key-switch-theme
                current-theme current-switch-themes 'next)))
   "next-theme")
  ("q" nil :exit t))

(core/set-key global
  :state '(normal motion)
  (kbd "C--") 'hydra-color-switch/body)
