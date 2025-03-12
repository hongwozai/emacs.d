;;; -*- coding: utf-8 -*-

;; start time
(setq emacs-load-start-time (current-time))

;;-------------------------------------------
;;; gc
;;-------------------------------------------
(setq normal-gc-cons-threshold (* 20 1024 1024))
(setq init-gc-cons-threshold (* 128 1024 1024))

(setq gc-cons-threshold init-gc-cons-threshold)

;; end
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold normal-gc-cons-threshold)))

;;; report(replace builtin function)
(defun display-startup-echo-area-message ()
  (when (require 'time-date nil t)
    (message "Emacs startup time: %f seconds."
             (time-to-seconds (time-since emacs-load-start-time)))))
