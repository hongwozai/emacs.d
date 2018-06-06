;;; package
(require 'package)

;;; touch ~/.emacs.d/offline -> offline config
(setq package-archives
      `(("localelpa" . ,(expand-file-name
                         "localelpa" user-emacs-directory))))

(when (not (file-exists-p
            (expand-file-name "offline" user-emacs-directory)))
  (setcdr package-archives
          '(("gnu"   . "https://elpa.emacs-china.org/gnu/")
            ("melpa" . "https://elpa.emacs-china.org/melpa/")
            ("melpa-stable" . "https://elpa.emacs-china.org/melpa-stable/")))
  )

;;; offical Melpa (and Gnu)
;;; ("melpa" . "http://melpa.org/packages/")
;;; ("melpa-stable" . "http://stable.melpa.org/packages/")


;;-------------------------------------------
;;; quelpa install from source
;;-------------------------------------------
(require 'quelpa)
(setq quelpa-update-melpa-p nil)

;;-------------------------------------------
;;; package func
;;-------------------------------------------
(defun require-package (package &optional no-refresh)
  "Install given PACKAGE. "
  (if (package-installed-p package)
      t
    (if (eq core/package-install-mode 'source)
        (quelpa package)
      (if (or (assoc package package-archive-contents)
              no-refresh)
          (package-install package)
        (progn
          (package-refresh-contents)
          (require-package package t))))))

(font-lock-add-keywords 'emacs-lisp-mode
                        '("require-package" "maybe-require"))

(provide 'core-package)
