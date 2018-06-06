;;; -*- coding: utf-8 -*-

;; (profiler-start 'cpu)
;;-------------------------------------------
;;; package.el initialize
;;-------------------------------------------
(package-initialize)

;;-------------------------------------------
;;; gc
;;-------------------------------------------
(setq normal-gc-cons-threshold (* 20 1024 1024))
(setq init-gc-cons-threshold (* 128 1024 1024))

(setq gc-cons-threshold init-gc-cons-threshold)

;;-------------------------------------------
;;; set path
;;-------------------------------------------
;;; set default
(setq default-directory
      (file-name-as-directory (expand-file-name "~")))

;;; add sub directory to load-path
(dolist (name '("core" "site-lisp" "module"))
  (add-to-list 'load-path
               (expand-file-name name user-emacs-directory)))

;;-------------------------------------------
;;; hook start
;;-------------------------------------------
(setq inhibit-message t)
(setq emacs-load-start-time (current-time))

;;-------------------------------------------
;;; load
;;-------------------------------------------
;;; load core
(require 'core-init)

;;; load each module
(autoload-modules)

;;-------------------------------------------
;;; hook end
;;-------------------------------------------
;;; recovery
(setq inhibit-message nil)
(setq gc-cons-threshold normal-gc-cons-threshold)

;;; report(replace builtin function)
(defun display-startup-echo-area-message ()
  (when (require 'time-date nil t)
    (message "Emacs startup time: %f seconds."
             (time-to-seconds (time-since emacs-load-start-time)))))

;; (profiler-report)

(provide 'init)
