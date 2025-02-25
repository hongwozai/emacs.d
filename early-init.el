;;; -*- coding: utf-8 -*-

;; start time
(setq emacs-load-start-time (current-time))

;;-------------------------------------------
;;; custom variable
;;-------------------------------------------
;;; set user home
(setq user-home-directory
      (file-name-as-directory (expand-file-name "~")))

;;; startup default directory
(setq default-directory user-home-directory)

;;; add sub directory to load-path
(dolist (name '("core" "site-lisp"))
  (add-to-list 'load-path
               (expand-file-name name user-emacs-directory)))

(setq *is-mac* (eql system-type 'darwin))

;;-------------------------------------------
;;; gc
;;-------------------------------------------
(setq normal-gc-cons-threshold (* 20 1024 1024))
(setq init-gc-cons-threshold (* 128 1024 1024))

(setq gc-cons-threshold init-gc-cons-threshold)

;; end
(add-hook 'after-init-hook
          (lambda ()
            (setq gc-cons-threshold normal-gc-cons-threshold)
            ))

;;; report(replace builtin function)
(defun display-startup-echo-area-message ()
  (when (require 'time-date nil t)
    (message "Emacs startup time: %f seconds."
             (time-to-seconds (time-since emacs-load-start-time)))))
